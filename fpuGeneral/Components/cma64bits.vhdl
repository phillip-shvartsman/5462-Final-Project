-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: 
-- NOTE TO READER: 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY cma64bits IS
  PORT  ( A,B   : IN  std_logic_vector(63 downto 0);
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector(63 downto 0);
          cout  : OUT std_logic
        );
END cma64bits;

--WARNING : INCOMPLETE DUE TO NOT ALLOWING FOR GENERIC INPUTS, CAN ONLY ACCEPT INPUTS OF CERTAIN SIZE
ARCHITECTURE dataflow OF cma64bits IS
  COMPONENT cmaStage IS
    GENERIC ( Init  : Integer
            );
    PORT  ( A,B   : IN  std_logic_vector;
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector;
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT rippleadder IS
    PORT  ( A,B   : IN  std_logic_vector;
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector;
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaStage    USE ENTITY WORK.cmaStage(dataflow);
  FOR ALL : rippleadder USE ENTITY WORK.rippleadder(dataflow);
  
  SIGNAL carry    :  std_logic_vector(7 downto 0);
  
BEGIN
  carry(0) <= cin;
  
  GEN_STAGES : FOR i IN 0 to carry'HIGH-1 GENERATE
    STAGE1 : IF i = 0 GENERATE
      cmaStage1 : rippleadder PORT MAP
        ( A(2 downto 0), B(2 downto 0),
          carry(i),
          sum(2 downto 0),
          carry(i+1)
        );
    END GENERATE STAGE1;
    
    STAGE2 : IF i = 1 GENERATE
      cmaStage2 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(7 downto 3), B(7 downto 3),
                    carry(i),
                    sum(7 downto 3),
                    carry(i+1)
                  );
    END GENERATE STAGE2;
    
    STAGE3 : IF i = 2 GENERATE
      cmaStage3 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(16 downto 8), B(16 downto 8),
                    carry(i),
                    sum(16 downto 8),
                    carry(i+1)
                  );
    END GENERATE STAGE3;
    
    STAGE4 : IF i = 3 GENERATE
      cmaStage4 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(30 downto 17), B(30 downto 17),
                    carry(i),
                    sum(30 downto 17),
                    carry(i+1)
                  );
    END GENERATE STAGE4;
    
    STAGE5 : IF i = 4 GENERATE
      cmaStage5 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(44 downto 31), B(44 downto 31),
                    carry(i),
                    sum(44 downto 31),
                    carry(i+1)
                  );
    END GENERATE STAGE5;
    
    STAGE6 : IF i = 5 GENERATE
      cmaStage6 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(58 downto 45), B(58 downto 45),
                    carry(i),
                    sum(58 downto 45),
                    carry(i+1)
                  );
    END GENERATE STAGE6;
    
    STAGE7 : IF i = 6 GENERATE
      cmaStage7 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(63 downto 59), B(63 downto 59),
                    carry(i),
                    sum(63 downto 59),
                    carry(i+1)
                  );
    END GENERATE STAGE7;
    
  END GENERATE GEN_STAGES;
  
  cout  <=  carry(carry'HIGH);

END dataflow;
