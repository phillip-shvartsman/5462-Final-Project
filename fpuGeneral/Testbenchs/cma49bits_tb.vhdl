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

ENTITY cma49bits_tb IS
END cma49bits_tb;

ARCHITECTURE testbench OF cma49bits_tb IS
  COMPONENT cma49bits IS
    PORT  ( A,B   : IN  std_logic_vector(48 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(48 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma49bits USE ENTITY WORK.cma49bits(dataflow);
  
  SIGNAL A,B : std_logic_vector(48 downto 0) := (others => '0');
  SIGNAL cin : std_logic := '0';
  SIGNAL sum : std_logic_vector(A'RANGE) := (others => '0');
  SIGNAL cout : std_logic := '0';
  
BEGIN
  
  A <= x"FFFFFFFFFFFF" & '1' after 5 ns,  x"123456789ABC" & '1' after 15 ns;
  B <= x"000000000000" & '1' after 10 ns, x"436CD5321654" & '1' after 20 ns, (others => '0') after 25 ns;
  cin <= '1' after 0 ns;
  cma1 : cma49bits PORT MAP
    (A,B,cin,sum,cout);
    
END testbench;