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
signal p : std_logic_vector(9 downto 0);
signal k : std_logic_vector(9 downto 0);
signal b : std_logic_vector(9 downto 0);
signal presumeZero : std_logic_vector(9 downto 0);
signal presumeOne : std_logic_vector(9 downto 0);
signal presumeZerocarry : std_logic_vector(9 downto 0);
signal presumeOnecarry : std_logic_vector(9 downto 0);
signal subtractCarry : std_logic_vector(9 downto 0);
begin
--Subtract Exponent
--   exponentIn - numLeftShifts
--
--       9   8   7   6  5  4  3  2  1   0
--
--     -'0' '0' '0' '0'  5  4  3  2  1  0 
--	
			
	b <= "0000" & numLeftShifts;

	generateP:
	for i in 0 to 9 generate
		p(i) <= a(i) xnor b(i);
	end generate generateP;

	generateK:
	for i in 0 to 9 generate
		k(i) <= a(i) and not(b(i));
	end generate generateK;

	generatePresumeZero:
	for i in 0 to 9 generate
		presumeZero(i) <= a(i) xnor b(i) xnor '0';
		presumeZerocarry(i) <= (p(i) and '0') or (not(p(i)) and not(k(i)));
	end generate generatePresumeZero;	
	
	generatePresumeOne:
	for i in 0 to 9 generate
		presumeOne(i) <= (a(i) xnor b(i) xnor '1');
		presumeOnecarry(i) <= (p(i) and '1') or (not(p(i)) and not(k(i)));
	end generate generatePresumeOne;	

	exponentSubtracted(0) <= presumeZero(0);
	subtractCarry(0) <= presumeZerocarry(0);
	generateOutput:
	for i in 1 to 9 generate
		with subtractCarry(i-1) select subtractCarry(i) <=
			presumeZerocarry(i) when '0',
			presumeOnecarry(i) when '1',
			'Z' when others;
		with subtractCarry(i-1) select exponentSubtracted(i) <=
			presumeZero(i) when '0',
			presumeOne(i) when '1',
			'Z' when others;
	end generate generateOutput;

end behave;