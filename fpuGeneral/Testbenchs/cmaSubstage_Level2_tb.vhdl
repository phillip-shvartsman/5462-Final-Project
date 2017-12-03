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

ENTITY cmaSubstage_Level2_tb IS
END cmaSubstage_Level2_tb;

ARCHITECTURE test of cmaSubstage_Level2_tb IS
  COMPONENT cmaSubstage_Level2 IS
    PORT  ( A,B                 : IN  std_logic_vector;
            muxCtrlin           : IN  std_logic;
            sum                 : OUT std_logic_vector;
            cout,coutP0,coutP1  : OUT std_logic;
            muxCtrlout          : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaSubstage_Level2  USE ENTITY  WORK.cmaSubstage_Level2(dataflow);
  
  SIGNAL A,B                : std_logic_vector(1 downto 0) := (others => 'Z');
  SIGNAL muxCtrlin          : std_logic := 'Z';
  SIGNAL sum                : std_logic_vector(A'RANGE);
  SIGNAL cout,coutP0,coutP1 : std_logic;
  SIGNAL muxCtrlout         : std_logic;
  
BEGIN
  A <= "00" after 0 ns, "11" after 5 ns;
  B <= "00" after 0 ns, "01" after 10 ns;
  muxCtrlin <= '0';
  
  Substage : cmaSubstage_Level2 PORT MAP
    ( A,B,
      muxCtrlin,
      sum,
      cout,coutP0,coutP1,
      muxCtrlout
    );
    
END test;