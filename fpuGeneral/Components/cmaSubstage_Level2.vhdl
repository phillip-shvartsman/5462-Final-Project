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

ENTITY cmaSubstage_Level2 IS
  PORT  ( A,B                 : IN  std_logic_vector;
          muxCtrlin           : IN  std_logic;
          sum                 : OUT std_logic_vector;
          cout,coutP0,coutP1  : OUT std_logic;
          muxCtrlout          : OUT std_logic
        );
END cmaSubstage_Level2;

ARCHITECTURE dataflow of cmaSubstage_Level2 IS
  COMPONENT cmaHalfAdderCell_Level2 IS
    PORT  ( A,B                 : IN  std_logic;
            muxCtrlin           : IN  std_logic;
            sum                 : OUT std_logic;
            cout,coutP0,coutP1  : OUT std_logic;
            muxCtrlout          : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT cmaAdderCell_Level2 IS
    PORT  ( A,B                 : IN  std_logic;
            cin,cinP0,cinP1     : IN  std_logic;
            muxCtrlin           : IN  std_logic;
            sum                 : OUT std_logic;
            cout,coutP0,coutP1  : OUT std_logic;
            muxCtrlout          : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaHalfAdderCell_Level2 USE ENTITY  WORK.cmaHalfAdderCell_Level2(dataflow);
  FOR ALL : cmaAdderCell_Level2     USE ENTITY  WORK.cmaAdderCell_Level2(dataflow);
  
  SIGNAL carry,carryP0,carryP1  : std_logic_vector(A'RANGE);
  SIGNAL muxCtrl                : std_logic_vector(A'RANGE);
  
BEGIN
  GEN_ADDERS : FOR i IN A'REVERSE_RANGE GENERATE
    HALFADDER : IF i = A'LOW GENERATE
      BITLOW : cmaHalfAdderCell_Level2 PORT MAP
        ( A(i), B(i),
          muxCtrlin,
          sum(i),
          carry(i), carryP0(i), carryP1(i),
          muxCtrl(i)
        );
    END GENERATE HALFADDER;
    
    ADDERS : IF i > A'LOW GENERATE
      BITSHIGH : cmaAdderCell_Level2 PORT MAP
        ( A(i), B(i),
          carry(i-1), carryP0(i-1), carryP1(i-1),
          muxCtrl(i-1),
          sum(i),
          carry(i), carryP0(i), carryP1(i),
          muxCtrl(i)
        );
    END GENERATE ADDERS;
  END GENERATE GEN_ADDERS;
  
  cout        <=  carry(carry'HIGH);
  coutP0      <=  carryP0(carryP0'HIGH);
  coutP1      <=  carryP1(carryP1'HIGH);
  muxCtrlout  <=  muxCtrl(muxCtrl'HIGH);
        
END dataflow;