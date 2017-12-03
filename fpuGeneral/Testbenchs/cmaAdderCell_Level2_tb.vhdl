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

ENTITY cmaAdderCell_Level2_tb IS
END cmaAdderCell_Level2_tb;

ARCHITECTURE test OF cmaAdderCell_Level2_tb IS
  COMPONENT cmaAdderCell_Level2 IS
    PORT  ( A,B                 : IN  std_logic;
            cin,cinP0,cinP1     : IN  std_logic;
            muxCtrlin           : IN  std_logic;
            sum                 : OUT std_logic;
            cout,coutP0,coutP1  : OUT std_logic;
            muxCtrlout          : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaAdderCell_Level2 USE ENTITY WORK.cmaAdderCell_Level2(dataflow);
  
  SIGNAL A,B                : std_logic;
  SIGNAL cin,cinP0,cinP1    : std_logic;
  SIGNAL muxCtrlin          : std_logic;
  SIGNAL sum                : std_logic;
  SIGNAL cout,coutP0,coutP1 : std_logic;
  SIGNAL muxCtrlout         : std_logic;
  
BEGIN
  A <= '0' after 0 ns, '1' after 5 ns;
  B <= '0' after 0 ns, '1' after 10 ns;
  cin <= '0'; cinP0 <= '0'; cinP1 <= '1';
  muxCtrlin <= '1';
  
  Add : cmaAdderCell_Level2 PORT MAP
    ( A,B,
      cin, cinP0, cinP1,
      muxCtrlin,
      sum,
      cout,coutP0,coutP1,
      muxCtrlout
    );
  
END test;