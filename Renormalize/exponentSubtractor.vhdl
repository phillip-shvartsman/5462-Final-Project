library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exponentSubtractor is 
	PORT(
		a : in std_logic_vector(9 downto 0);
		numLeftShifts : in std_logic_vector(5 downto 0);
		exponentSubtracted : out std_logic_vector(9 downto 0)
	);
end exponentSubtractor;

architecture behave of exponentSubtractor is
signal subtractCarry : std_logic_vector(10 downto 0);
signal p : std_logic_vector(9 downto 0);
signal k : std_logic_vector(9 downto 0);
signal b : std_logic_vector(9 downto 0);
begin
--Subtract Exponent
--   exponentIn - numLeftShifts
--
--       9   8   7   6  5  4  3  2  1   0
--
--     -'0' '0' '0' '0'  5  4  3  2  1  0 
--	
	subtractCarry(0) <= '0';
			
	b <= "0000" & numLeftShifts;

	generateP:
	for i in 0 to 9 generate
		p(i) <= a(i) xnor b(i);
	end generate generateP;

	generateK:
	for i in 0 to 9 generate
		k(i) <= a(i) and not(b(i));
	end generate generateK;

	generateSubtraction:
	for i in 0 to 9 generate
		exponentSubtracted(i) <= a(i) xnor b(i) xnor subtractCarry(i);
		subtractCarry(i+1) <= (p(i) and subtractCarry(i)) or (not(p(i)) and not(k(i)));
	end generate generateSubtraction;	

end behave;