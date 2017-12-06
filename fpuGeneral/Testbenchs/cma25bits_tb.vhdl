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

ENTITY cma25bits_tb IS
END cma25bits_tb;

ARCHITECTURE test OF cma25bits_tb IS
  COMPONENT cma25bits IS
    PORT  ( A,B   : IN  std_logic_vector(24 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(24 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma25bits USE ENTITY WORK.cma25bits(dataflow);
  
  SIGNAL A,B : std_logic_vector(24 downto 0) := (others => '0');
  SIGNAL cin : std_logic := '0';
  SIGNAL sum : std_logic_vector(A'RANGE) := (others => '0');
  SIGNAL cout : std_logic := '0';
  
BEGIN
  
  A <= "0101001100100111100001011" after 5 ns, x"000C00" & '1' after 12 ns;
  B <= "1111111110011000100101011" after 10 ns;
  cin <= '1' after 7 ns;
  cma1 : cma25bits PORT MAP
    (A,B,cin,sum,cout);
    
END test;