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

ENTITY cmaSubstage_Level3 IS
  PORT  ( A,B                                   : IN  std_logic_vector;
          cin                                   : IN  std_logic;
          muxCtrlin,muxCtrlP0in,muxCtrlP1in     : IN  std_logic;
          sum                                   : OUT std_logic_vector;
          cout,coutP0,coutP1                    : OUT std_logic;
          muxCtrlout,muxCtrlP0out,muxCtrlP1out  : OUT std_logic
        );
END cmaSubstage_Level3;

ARCHITECTURE dataflow of cmaSubstage_Level3 IS
  COMPONENT cmaHalfAdderCell_Level3 IS
    PORT  ( A,B                                   : IN  std_logic;
            cin                                   : IN  std_logic;
            muxCtrlin,muxCtrlP0in,muxCtrlP1in     : IN  std_logic;
            sum                                   : OUT std_logic;
            cout,coutP0,coutP1                    : OUT std_logic;
            muxCtrlout,muxCtrlP0out,muxCtrlP1out  : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT cmaAdderCell_Level3 IS
    PORT  ( A,B                                   : IN  std_logic;
            cin,cinP0,cinP1                       : IN  std_logic;
            muxCtrlin,muxCtrlP0in,muxCtrlP1in     : IN  std_logic;
            sum                                   : OUT std_logic;
            cout,coutP0,coutP1                    : OUT std_logic;
            muxCtrlout,muxCtrlP0out,muxCtrlP1out  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaHalfAdderCell_Level3 USE ENTITY  WORK.cmaHalfAdderCell_Level3(dataflow);
  FOR ALL : cmaAdderCell_Level3     USE ENTITY  WORK.cmaAdderCell_Level3(dataflow);
  
  SIGNAL carry,carryP0,carryP1        : std_logic_vector(A'RANGE);
  SIGNAL muxCtrl,muxCtrlP0,muxCtrlP1  : std_logic_vector(A'RANGE);
  
BEGIN
  GEN_ADDERS : FOR i in A'REVERSE_RANGE GENERATE
    HALFADDER : IF i = A'LOW GENERATE
      BITLOW : cmaHalfAdderCell_Level3 PORT MAP
        ( A(i), B(i),
          cin,
          muxCtrlin, muxCtrlP0in, muxCtrlP1in,
          sum(i),
          carry(i), carryP0(i), carryP1(i),
          muxCtrl(i), muxCtrlP0(i), muxCtrlP1(i)
        );
    END GENERATE HALFADDER;
    
    ADDERS : IF i > A'LOW GENERATE
      BITSHIGH : cmaAdderCell_Level3 PORT MAP
        ( A(i), B(i),
          carry(i-1), carryP0(i-1), carryP1(i-1),
          muxCtrl(i-1), muxCtrlP0(i-1), muxCtrlP1(i-1),
          sum(i),
          carry(i), carryP0(i), carryP1(i),
          muxCtrl(i), muxCtrlP0(i), muxCtrlP1(i)
        );
    END GENERATE ADDERS;
  END GENERATE GEN_ADDERS;
  
  cout          <=  carry(carry'HIGH);
  coutP0        <=  carryP0(carryP0'HIGH);
  coutP1        <=  carryP1(carryP1'HIGH);
  muxCtrlout    <=  muxCtrl(muxCtrl'HIGH);
  muxCtrlP0out  <=  muxCtrlP0(muxCtrlP0'HIGH);
  muxCtrlP1out  <=  muxCtrlP1(muxCtrlP1'HIGH);
        
END dataflow;