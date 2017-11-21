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
signal carry : std_logic_vector(10 downto 0);
signal b : std_logic_vector(9 downto 0) := "0000000001";
begin
	carry(0) <= '0';
	generateAddition:
	for i in 0 to 9 generate
		c(i) <= a(i) xor b(i) xor carry(i);
		--carry(i+1) <= a(i) and b(i) or(carry(i) and (a(i) xor b(i)));
		carry(i+1) <= (a(i) and b(i)) or (carry(i) and(a(i) xor b(i)));
	end generate generateAddition;
end behave;