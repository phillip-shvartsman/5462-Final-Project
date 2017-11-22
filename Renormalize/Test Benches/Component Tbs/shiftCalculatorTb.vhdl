library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;

entity shiftTb is
end shiftTb;

architecture behave of shiftTb is
component shiftCalculator is
	PORT(
		mantissaIn : in std_logic_vector(47 downto 0);
		shiftsOut : out std_logic_vector(5 downto 0)
	);
end component;
for all : shiftCalculator use ENTITY work.shiftCalculator(behave);
signal VectorUnderTest : std_logic_vector(47 downto 0);
signal shiftsOut : std_logic_vector(5 downto 0);
signal index : integer := 0;
signal rand_num : integer;
begin
uut: shiftCalculator port map(VectorUnderTest,shiftsOut);
applyTests: process
begin
for i in 0 to 47 loop
	VectorUnderTest <= (others=>'0');
	VectorUnderTest(i) <= '1';
	
	wait for 20 ns;
end loop;
for i in 0 to 47 loop
	VectorUnderTest <= (others=>'0');
	VectorUnderTest(i) <= '1';
	VectorUnderTest(rand_num) <= '1';
	wait for 20 ns;
end loop;
end process;
generateRandom: process
	variable seed1, seed2: positive;               -- seed values for random generator
    	variable rand: real;   -- random real-number value in range 0 to 1.0  
    	variable range_of_rand : real := 47.0;
begin
uniform(seed1, seed2, rand);
rand_num <= integer(rand*range_of_rand);
wait for 5 ns;
end process;
index <= to_integer(unsigned(shiftsOut));
end behave;