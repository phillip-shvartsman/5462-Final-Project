library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exponentIncrementor is
	PORT(
		a : in std_logic_vector(9 downto 0);
		c : out std_logic_vector(9 downto 0)
	);
end exponentIncrementor;

architecture behave of exponentIncrementor is
signal carry : std_logic_vector(9 downto 0);
signal b : std_logic_vector(9 downto 0) := "0000000001";
signal presumeZero,presumeOne,presumeOneCarry, presumeZeroCarry : std_logic_vector(9 downto 0);
begin


	
	generatePresumeZero:
	for i in 0 to 9 generate
		presumeZero(i) <= a(i) xor b(i) xor '0';
		presumeZeroCarry(i) <= (a(i) and b(i)) or ('0' and(a(i) xor b(i)));
	end generate generatePresumeZero;

	generatePresumeOne:
	for i in 0 to 9 generate
		presumeOne(i) <= a(i) xor b(i) xor '1';
		presumeOneCarry(i) <= (a(i) and b(i)) or ('1' and(a(i) xor b(i))); 
	end generate generatePresumeOne;
	
	c(0) <= presumeZero(0);
	carry(0) <= presumeZeroCarry(0);
	generateAddition:
	for i in 1 to 9 generate
		with carry(i-1) select carry(i) <=
			presumeZeroCarry(i) when '0',
			presumeOneCarry(i) when '1',
			'Z' when others;
		with carry(i-1) select c(i) <=
			presumeZero(i) when '0',
			presumeOne(i) when '1',
			'Z' when others;
	end generate generateAddition;
end behave;