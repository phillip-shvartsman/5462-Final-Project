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

ENTITY cma25bits IS
  PORT  ( A,B   : IN  std_logic_vector(24 downto 0);
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector(24 downto 0);
          cout  : OUT std_logic
        );
END cma25bits;

--WARNING : INCOMPLETE DUE TO NOT ALLOWING FOR GENERIC INPUTS, CAN ONLY ACCEPT INPUTS OF CERTAIN SIZE
ARCHITECTURE dataflow OF cma25bits IS
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
  
  FOR ALL : cmaStage            USE ENTITY  WORK.cmaStage(dataflow);
  FOR ALL : rippleadder         USE ENTITY  WORK.rippleadder(dataflow);
  
  SIGNAL carry    :  std_logic_vector(4 downto 0);
  
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
      cmaStage2 : cmaStage
      GENERIC MAP ( Init => 3 )
      PORT MAP  ( A(10 downto 4), B(10 downto 4),
                  carry(i),
                  sum(10 downto 4),
                  carry(i+1)
                );
    END GENERATE STAGE2;
    
    STAGE3 : IF i = 2 GENERATE
      cmaStage3 : cmaStage
        GENERIC MAP ( Init => 3 )
        PORT MAP  ( A(17 downto 11), B(17 downto 11),
                    carry(i),
                    sum(17 downto 11),
                    carry(i+1)
                  );
    END GENERATE STAGE3;
    
    STAGE4 : IF i = 3 GENERATE
      cmaStage4 : cmaStage
        GENERIC MAP ( Init => 3 )
        PORT MAP  ( A(24 downto 18), B(24 downto 18),
                    carry(i),
                    sum(24 downto 18),
                    carry(i+1)
                  );
    END GENERATE STAGE4;
  END GENERATE GEN_STAGES;
  
  cout  <=  carry(carry'HIGH);

END dataflow;