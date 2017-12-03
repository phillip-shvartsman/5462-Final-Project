library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity incrementorTb is
end entity;
architecture behave of incrementorTb is
component exponentIncrementor is
	PORT(
		a : in std_logic_vector(9 downto 0);
		c : out std_logic_vector(9 downto 0)
	);
end component;
FOR ALL : exponentIncrementor use ENTITY work.exponentIncrementor(behave);
signal rand_num : integer;
signal a : std_logic_vector(9 downto 0);
signal c : std_logic_vector(9 downto 0);
signal cExpected : integer;
signal correct : boolean;
begin
correct <= (cExpected = to_integer(unsigned(c)));
uut: exponentIncrementor port map(a,c);
applyTests: process(rand_num)
begin
	a <= std_logic_vector(to_unsigned(rand_num,10));
	cExpected <= rand_num + 1;
end process;
generateRandom: process
	variable seed1, seed2: positive;               -- seed values for random generator
    	variable rand: real;   -- random real-number value in range 0 to 1.0  
    	variable range_of_rand : real := 512.0;
begin
uniform(seed1, seed2, rand);
rand_num <= integer(rand*range_of_rand);
wait for 20 ns;
end process;
end behave;