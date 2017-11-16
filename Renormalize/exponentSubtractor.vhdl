library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exponentSubtractor is 
	PORT(
		exponentIn : in std_logic_vector(9 downto 0);
		numLeftShifts : in std_logic_vector(5 downto 0);
		exponentSubtracted : out std_logic_vector(9 downto 0)
	);
end exponentSubtractor;

architecture behave of exponentSubtractor is
signal subtractCarry : std_logic_vector(9 downto 0);
begin
--Subtract Exponent
--   exponentIn - numLeftShifts
--
--       9   8   7  6  5  4  3  2  1  0
--
--     -'0' '0' '0' 5  4  3  2  1  0 '0'  
--
	generateSubtraction:
	for i in 0 to 9 generate
		padFront: 
		if i>6 generate
			exponentSubtracted(i) <= exponentIn(i) xnor '0' xnor subtractCarry(i-1);
			subtractCarry(i) <= ((exponentIn(i) xnor '0') and subtractCarry(i-1)) or (not( exponentIn(i) xnor '0') and not(exponentIn(i) and not('0')));
		end generate padFront;
		main:
		if i<6 and i >0 generate
			exponentSubtracted(i) <= exponentIn(i) xnor numLeftShifts(i-1) xnor subtractCarry(i-1);
			subtractCarry(i) <= ((exponentIn(i) xnor numLeftShifts(i-1)) and subtractCarry(i-1)) or (not( exponentIn(i) xnor numLeftShifts(i-1)) and not(exponentIn(i) and not(numLeftShifts(i-1))));
		end generate main;
		padBack:
		if i = 0 generate
			exponentSubtracted(i) <= exponentIn(i);
			subtractCarry(i) <= '0';
		end generate padBack;
	end generate generateSubtraction;	
end behave;