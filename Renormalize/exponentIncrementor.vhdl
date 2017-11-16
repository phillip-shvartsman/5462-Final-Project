library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exponentIncrementor is
	PORT(
		exponentIn : in std_logic_vector(9 downto 0);
		exponentAdded : out std_logic_vector(9 downto 0)
	);
end exponentIncrementor;

architecture behave of exponentIncrementor is
signal additionCarry : std_logic_vector(9 downto 0);
begin
	generateAddition:
	for i in 0 to 9 generate
		addingZero: 
		if i>1 generate
			exponentAdded(i) <= exponentIn(i) xor '0' xor additionCarry(i-1);
			additionCarry(i) <= (exponentIn(i) and additionCarry(i-1)) or ('0' and additionCarry(i-1)) or (exponentIn(i) and '0');	
		end generate addingZero;
		addingOne:
		if i=1 generate
			exponentAdded(i) <= exponentIn(i) xor '1' xor additionCarry(i-1);
			additionCarry(i) <= (exponentIn(i) and additionCarry(i-1)) or ('1' and additionCarry(i-1)) or (exponentIn(i) and '1');	
		end generate addingOne;
		lsb:
		if i=0 generate
			exponentAdded(i) <= exponentIn(i);
			additionCarry(i) <= '0';
		end generate lsb;
	end generate generateAddition;
end behave;