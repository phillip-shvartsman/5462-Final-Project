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

ENTITY barrelShifter_tb IS
END barrelShifter_tb;

ARCHITECTURE test OF barrelShifter_tb IS
  COMPONENT barrelShifter IS
    PORT  ( input   : IN  std_logic_vector;
            shift   : IN  std_logic_vector;
            output  : OUT std_logic_vector
          );
  END COMPONENT;
  
  FOR ALL : barrelShifter USE ENTITY WORK.barrelShifter(dataflow);
  
  SIGNAL input  : std_logic_vector(24 downto 0) := (others => '0');
  SIGNAL shift  : std_logic_vector(5 downto 1) := (others => '0');
  SIGNAL output : std_logic_vector(24 downto 0);
  
BEGIN
  input <= '1' & x"FFFFFF" after 5 ns, '0' & x"00F000" after 15 ns;
  shift <= "01100" after 10 ns;
  
  shifter : barrelShifter PORT MAP
    ( input,
      shift,
      output
    );
END test;