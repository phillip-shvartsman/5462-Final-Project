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

ENTITY cma8bits IS
  PORT  ( A,B   : IN  std_logic_vector(7 downto 0);
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector(7 downto 0);
          cout  : OUT std_logic
        );
END cma8bits;

--WARNING : INCOMPLETE DUE TO NOT ALLOWING FOR GENERIC INPUTS, CAN ONLY ACCEPT INPUTS OF CERTAIN SIZE
ARCHITECTURE dataflow OF cma8bits IS
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
  
  SIGNAL carry    :  std_logic_vector(2 downto 0);
  
BEGIN
  carry(0) <= cin;
  
  GEN_STAGES : FOR i IN 0 to carry'HIGH-1 GENERATE
    STAGE1 : IF i = 0 GENERATE
      ripple0 : rippleadder PORT MAP
        ( A(2 downto 0), B(2 downto 0),
          carry(i),
          sum(2 downto 0),
          carry(i+1)
        );
    END GENERATE STAGE1;
    
    STAGE2 : IF i = 1 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(7 downto 3), B(7 downto 3),
                    carry(i),
                    sum(7 downto 3),
                    carry(i+1)
                  );
    END GENERATE STAGE2;
    
  END GENERATE GEN_STAGES;
  
  cout  <=  carry(carry'HIGH);

END dataflow;