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

ENTITY cma24bits IS
  PORT  ( A,B   : IN  std_logic_vector(23 downto 0);
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector(23 downto 0);
          cout  : OUT std_logic
        );
END cma24bits;

--WARNING : INCOMPLETE DUE TO NOT ALLOWING FOR GENERIC INPUTS, CAN ONLY ACCEPT INPUTS OF CERTAIN SIZE
ARCHITECTURE dataflow OF cma24bits IS
  COMPONENT cmaStage IS
    GENERIC ( Init  : Integer
            );
    PORT  ( A,B   : IN  std_logic_vector;
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector;
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT cmaSubstage_Level2 IS
    PORT  ( A,B                 : IN  std_logic_vector;
            muxCtrlin           : IN  std_logic;
            sum                 : OUT std_logic_vector;
            cout,coutP0,coutP1  : OUT std_logic;
            muxCtrlout          : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT cmaSubstage_Level3 IS
    PORT  ( A,B                                   : IN  std_logic_vector;
            cin                                   : IN  std_logic;
            muxCtrlin,muxCtrlP0in,muxCtrlP1in     : IN  std_logic;
            sum                                   : OUT std_logic_vector;
            cout,coutP0,coutP1                    : OUT std_logic;
            muxCtrlout,muxCtrlP0out,muxCtrlP1out  : OUT std_logic
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
  FOR ALL : cmaSubstage_Level2  USE ENTITY  WORK.cmaSubstage_Level2(dataflow);
  FOR ALL : cmaSubstage_Level3  USE ENTITY  WORK.cmaSubstage_Level3(dataflow);
  FOR ALL : rippleadder         USE ENTITY  WORK.rippleadder(dataflow);
  
  SIGNAL carry    :  std_logic_vector(5 downto 0);
  
BEGIN
  carry(0) <= cin;
  
  GEN_STAGES : FOR i IN 0 to carry'HIGH-1 GENERATE
    
    --Stage for first 3 bits (2-0)
    STAGE1 : IF i = 0 GENERATE
      ripple0 : rippleadder PORT MAP
        ( A(1 downto 0), B(1 downto 0),
          carry(i),
          sum(1 downto 0),
          carry(i+1)
        );
    END GENERATE STAGE1;
    
    --Stage for next 5 bits (7-3)
    STAGE2 : IF i = 1 GENERATE
      cmaStage1 : cmaStage
      GENERIC MAP ( Init => 1 )
      PORT MAP  ( A(4 downto 2), B(4 downto 2),
                  carry(i),
                  sum(4 downto 2),
                  carry(i+1)
                );
    END GENERATE STAGE2;
    
    --Stage for next 9 bits (16-8)
    STAGE3 : IF i = 2 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 1 )
        PORT MAP  ( A(10 downto 5), B(10 downto 5),
                    carry(i),
                    sum(10 downto 5),
                    carry(i+1)
                  );
    END GENERATE STAGE3;
    
    STAGE4 : IF i = 3 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 1 )
        PORT MAP  ( A(20 downto 11), B(20 downto 11),
                    carry(i),
                    sum(20 downto 11),
                    carry(i+1)
                  );
    END GENERATE STAGE4;
    
    STAGE5 : IF i = 4 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 1 )
        PORT MAP  ( A(23 downto 21), B(23 downto 21),
                    carry(i),
                    sum(23 downto 21),
                    carry(i+1)
                  );
    END GENERATE STAGE5;
  END GENERATE GEN_STAGES;
  
  cout  <=  carry(carry'HIGH);

END dataflow;