-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: 
-- NOTE TO READER: 
-------------------------------------------------------------------------------

--Testbench
library ieee;
use ieee.std_logic_1164.all;

ENTITY cma8bits_tb IS
END cma8bits_tb;

ARCHITECTURE testbench OF cma8bits_tb IS
  COMPONENT cma8bits IS
    PORT  ( A,B   : IN  std_logic_vector(7 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(7 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma8bits USE ENTITY WORK.cma8bits(dataflow);
  
  SIGNAL A,B : std_logic_vector(7 downto 0) := (others => '0');
  SIGNAL cin : std_logic := '0';
  SIGNAL sum : std_logic_vector(A'RANGE) := (others => '0');
  SIGNAL cout : std_logic := '0';
  
BEGIN
  
  A <= "11111111" after 5 ns;
  B <= "00000001" after 10 ns;
  cin <= '1' after 0 ns;
  cma1 : cma8bits PORT MAP
    (A,B,cin,sum,cout);
    
END testbench;