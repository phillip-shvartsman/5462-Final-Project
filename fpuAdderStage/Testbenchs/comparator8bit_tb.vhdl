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

ENTITY comparator8bit_tb IS
END comparator8bit_tb;

ARCHITECTURE test OF comparator8bit_tb IS
  COMPONENT comparator8bit IS
    PORT  ( left,right  : IN  std_logic_vector(7 downto 0);
            lmr,rml     : OUT std_logic_vector(7 downto 0);
            gt,eq,lt    : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : comparator8bit  USE ENTITY  WORK.comparator8bit(dataflow);
  
  SIGNAL left,right : std_logic_vector(7 downto 0) := (others => '0');
  SIGNAL lmr,rml    : std_logic_vector(7 downto 0);
  SIGNAL gt,eq,lt   : std_logic;
  
BEGIN
  left <= "0000" & "1111" after 5 ns;
  right <= "1100" & "1111" after 10 ns; 
  
  compare : comparator8bit PORT MAP
    ( left, right,
      lmr, rml,
      gt, eq, lt
    );
END test;