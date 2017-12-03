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

ENTITY cma48bits IS
  PORT  ( A,B   : IN  std_logic_vector(47 downto 0);
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector(47 downto 0);
          cout  : OUT std_logic
        );
END cma48bits;

--WARNING : INCOMPLETE DUE TO NOT ALLOWING FOR GENERIC INPUTS, CAN ONLY ACCEPT INPUTS OF CERTAIN SIZE
ARCHITECTURE dataflow OF cma48bits IS
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
  
  SIGNAL carry    :  std_logic_vector(5 downto 0);
  
BEGIN
  carry(0) <= cin;
  
  GEN_STAGES : FOR i IN 0 to carry'HIGH-1 GENERATE
    STAGE1 : IF i = 0 GENERATE
      ripple0 : rippleadder PORT MAP
        ( A(3 downto 0), B(3 downto 0),
          carry(i),
          sum(3 downto 0),
          carry(i+1)
        );
    END GENERATE STAGE1;
    
    STAGE2 : IF i = 1 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 3 )
        PORT MAP  ( A(10 downto 4), B(10 downto 4),
                    carry(i),
                    sum(10 downto 4),
                    carry(i+1)
                  );
    END GENERATE STAGE2;
    
    STAGE3 : IF i = 2 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 3 )
        PORT MAP  ( A(22 downto 11), B(22 downto 11),
                    carry(i),
                    sum(22 downto 11),
                    carry(i+1)
                  );
    END GENERATE STAGE3;
    
    STAGE4 : IF i = 3 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 3 )
        PORT MAP  ( A(40 downto 23), B(40 downto 23),
                    carry(i),
                    sum(40 downto 23),
                    carry(i+1)
                  );
    END GENERATE STAGE4;
    
    STAGE5 : IF i = 4 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 3 )
        PORT MAP  ( A(47 downto 41), B(47 downto 41),
                    carry(i),
                    sum(47 downto 41),
                    carry(i+1)
                  );
    END GENERATE STAGE5;
    
  END GENERATE GEN_STAGES;
  
  cout  <=  carry(carry'HIGH);

END dataflow;