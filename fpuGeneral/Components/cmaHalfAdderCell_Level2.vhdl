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

ENTITY cmaHalfAdderCell_Level2 IS
  PORT  ( A,B                 : IN  std_logic;
          muxCtrlin           : IN  std_logic;
          sum                 : OUT std_logic;
          cout,coutP0,coutP1  : OUT std_logic;
          muxCtrlout          : OUT std_logic
        );
END cmaHalfAdderCell_Level2;

ARCHITECTURE dataflow OF cmaHalfAdderCell_Level2 IS
  COMPONENT cmaAdder_level2 IS
    PORT  ( A,B                 : IN  std_logic;
            cin,cinP0,cinP1     : IN  std_logic;
            muxCtrlin           : IN  std_logic;
            sum                 : OUT std_logic;
            cout,coutP0,coutP1  : OUT std_logic;
            muxCtrlout          : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaAdder_Level2 USE ENTITY WORK.cmaAdderCell_Level2(dataflow); 
  
BEGIN
  adder : cmaAdder_Level2 PORT MAP
    ( A, B,
      muxCtrlin, '0', '1',
      muxCtrlin,
      sum,
      cout, coutP0, coutP1,
      muxCtrlout
    );
    
END dataflow;