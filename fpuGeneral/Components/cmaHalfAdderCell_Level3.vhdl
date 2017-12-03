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

ENTITY cmaHalfAdderCell_Level3 IS
  PORT  ( A,B                                   : IN  std_logic;
          cin                                   : IN  std_logic;
          muxCtrlin,muxCtrlP0in,muxCtrlP1in     : IN  std_logic;
          sum                                   : OUT std_logic;
          cout,coutP0,coutP1                    : OUT std_logic;
          muxCtrlout,muxCtrlP0out,muxCtrlP1out  : OUT std_logic
        );
END cmaHalfAdderCell_Level3;

ARCHITECTURE dataflow OF cmaHalfAdderCell_Level3 IS
  COMPONENT cmaAdder_Level3 IS
    PORT  ( A,B                                   : IN  std_logic;
            cin,cinP0,cinP1                       : IN  std_logic;
            muxCtrlin,muxCtrlP0in,muxCtrlP1in     : IN  std_logic;
            sum                                   : OUT std_logic;
            cout,coutP0,coutP1                    : OUT std_logic;
            muxCtrlout,muxCtrlP0out,muxCtrlP1out  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaAdder_Level3 USE ENTITY WORK.cmaAdderCell_Level3(dataflow);
  
BEGIN
  add : cmaAdder_Level3 PORT MAP
    ( A, B,
      cin, '0', '1',
      muxCtrlin, muxCtrlP0in, muxCtrlP1in,
      sum,
      cout, coutP0, coutP1,
      muxCtrlout, muxCtrlP0out, muxCtrlP1out
    );
    
END dataflow;