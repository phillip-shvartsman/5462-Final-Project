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

ENTITY cmaMultiplier_tb IS
END cmaMultiplier_tb;

ARCHITECTURE test OF cmaMultiplier_tb IS
  COMPONENT cmaMultiplier IS
    PORT  ( inputL,inputR   : IN  std_logic_vector(23 downto 0);
            output          : OUT std_logic_vector(47 downto 0)
          );
  END COMPONENT;
  
  FOR ALL : cmaMultiplier USE ENTITY WORK.cmaMultiplier(dataflow);
  
  SIGNAL inputL,inputR    : std_logic_vector(23 downto 0) := (others => '0');
  SIGNAL output,expected  : std_logic_vector(47 downto 0) := (others => '0');
  
BEGIN
  inputL <= x"BC9931" after 5 ns;
  inputR <= x"C95D31" after 10 ns, x"000000" after 20 ns;
  expected <= x"9458EF391F61";
  
  Mult : cmaMultiplier PORT MAP
    ( inputL, inputR,
      output
    );
  
END test;