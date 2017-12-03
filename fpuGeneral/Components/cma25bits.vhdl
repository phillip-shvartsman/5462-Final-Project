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
  
  SIGNAL carry    :  std_logic_vector(3 downto 0);
  
  --Signals for substages
  SIGNAL subCarry,subCarryP0,subCarryP1         : std_logic_vector(2 downto 0);
  SIGNAL subMuxCtrl,subMuxCtrlP0,subMuxCtrlP1   : std_logic_vector(2 downto 0);
  
BEGIN
  carry(0) <= cin;
  
  GEN_STAGES : FOR i IN 0 to carry'HIGH-1 GENERATE
    
    --Stage for first 3 bits (2-0)
    STAGE1 : IF i = 0 GENERATE
      ripple0 : rippleadder PORT MAP
        ( A(2 downto 0), B(2 downto 0),
          carry(i),
          sum(2 downto 0),
          carry(i+1)
        );
    END GENERATE STAGE1;
    
    --Stage for next 5 bits (7-3)
    STAGE2 : IF i = 1 GENERATE
      cmaStage1 : cmaStage
      GENERIC MAP ( Init => 2 )
      PORT MAP  ( A(7 downto 3), B(7 downto 3),
                  carry(i),
                  sum(7 downto 3),
                  carry(i+1)
                );
    END GENERATE STAGE2;
    
    --Stage for next 9 bits (16-8)
    STAGE3 : IF i = 2 GENERATE
      cmaStage1 : cmaStage
        GENERIC MAP ( Init => 2 )
        PORT MAP  ( A(16 downto 8), B(16 downto 8),
                    carry(i),
                    sum(16 downto 8),
                    carry(i+1)
                  );
    END GENERATE STAGE3;
  END GENERATE GEN_STAGES;
  
  --Generates the substages needed for the last 8 bits (24-17), if it was one more bit (i.e 25-17), a simplier STAGE could be used
  GEN_SUBSTAGES : FOR i IN 0 TO 2 GENERATE
    
    --Substage for next 2 bits (18-17)
    Substage1_Level2 : IF i = 0 GENERATE
      Substage1 : cmaSubstage_Level2 PORT MAP
        ( A(18 downto 17), B(18 downto 17), 
          carry(carry'HIGH), 
          sum(18 downto 17), 
          subCarry(i), subCarryP0(i), subCarryP1(i), 
          subMuxCtrl(i)
        );
    END GENERATE Substage1_Level2;
    
    --Substage for next 3 bits (21-19)
    Substage2_Level3 : IF i = 1 GENERATE
      Substage2 : cmaSubstage_Level3 PORT MAP
        ( A(21 downto 19), B(21 downto 19), 
          subCarry(i-1), 
          subMuxCtrl(i-1), subCarryP0(i-1), subCarryP1(i-1), 
          sum(21 downto 19), 
          subCarry(i), subCarryP0(i), subCarryP1(i), 
          subMuxCtrl(i), subMuxCtrlP0(i), subMuxCtrlP1(i)
        );
    END GENERATE Substage2_Level3;
    
    --Substage for final 3 bits (24-22)
    Substage3_Level3 : IF i = 2 GENERATE
      Substage3 : cmaSubstage_Level3 PORT MAP
        ( A(24 downto 22), B(24 downto 22), 
          subCarry(i-1), 
          subMuxCtrl(i-1), subCarryP0(i-1), subCarryP1(i-1), 
          sum(24 downto 22), 
          subCarry(i), subCarryP0(i), subCarryP1(i), 
          subMuxCtrl(i), subMuxCtrlP0(i), subMuxCtrlP1(i)
        );
    END GENERATE Substage3_Level3;
  END GENERATE GEN_SUBSTAGES;
  
  cout  <=  subCarry(subCarry'HIGH);

END dataflow;