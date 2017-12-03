
--Testbench
library ieee;
use ieee.std_logic_1164.all;

ENTITY cma24bits_tb IS
END cma24bits_tb;

ARCHITECTURE testbench OF cma24bits_tb IS
  COMPONENT cma24bits IS
    PORT  ( A,B   : IN  std_logic_vector(23 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(23 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma24bits USE ENTITY WORK.cma24bits(dataflow);
  
  SIGNAL A,B : std_logic_vector(23 downto 0) := (others => '0');
  SIGNAL cin : std_logic := '0';
  SIGNAL sum : std_logic_vector(A'RANGE) := (others => '0');
  SIGNAL cout : std_logic := '0';
  
BEGIN
  
  A <= x"FFFFFF" after 5 ns, x"000C00" after 12 ns;
  B <= x"000100" after 10 ns;
  cin <= '1' after 7 ns;
  cma1 : cma24bits PORT MAP
    (A,B,cin,sum,cout);
    
END testbench;