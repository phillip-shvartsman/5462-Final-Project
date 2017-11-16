library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity renormalizer is
	PORT(
		enableIn : in std_logic;
		signIn : in std_logic;
		exponentIn : in std_logic_vector(9 downto 0);
		mantissaIn : in std_logic_vector(47 downto 0);
		zOut : out std_logic_vector(31 downto 0)
	);
end renormalizer;

architecture behave of renormalizer IS
component shiftCalculator is
	PORT(
		mantissaIn : in std_logic_vector(47 downto 0);
		shiftsOut : out std_logic_vector(5 downto 0)
	);
end component;
component barrelShifter is
	PORT(
		mantissaIn : in std_logic_vector(47 downto 0);
		numShifts : in std_logic_vector(5 downto 0);
		mantissaShifted : out std_logic_vector(47 downto 0)
	);
end component;
component exponentSubtractor is 
	PORT(
		exponentIn : in std_logic_vector(9 downto 0);
		numLeftShifts : in std_logic_vector(5 downto 0);
		exponentSubtracted : out std_logic_vector(9 downto 0)
	);
end component;
component exponentIncrementor is
	PORT(
		exponentIn : in std_logic_vector(9 downto 0);
		exponentAdded : out std_logic_vector(9 downto 0)
	);
end component;
for all : shiftCalculator use ENTITY work.shiftCalculator(behave);
for all : barrelShifter use ENTITY work.barrelShifter(behave);
for all : exponentSubtractor use ENTITY work.exponentSubtractor(behave);
for all :exponentIncrementor use ENTITY work.exponentIncrementor(behave);

--Number of Times to Left Shift
	signal numLeftShifts : std_logic_vector(5 downto 0);

--The Exponents with Value Added or Subtracted
	signal exponentSubtracted : std_logic_vector(9 downto 0);
	signal exponentAdded : std_logic_vector(9 downto 0);

--The Left Shifted and Right Shifted Mantissa
	signal mantissaLeftShifted : std_logic_vector(47 downto 0);
	signal mantissaRightShifted : std_logic_vector(47 downto 0);

--Renormed Values
	signal mantissaRenorm : std_logic_vector(47 downto 0);
	signal exponentRenorm : std_logic_vector(9 downto 0);

--First Two Bits of the Mantissa
	signal mantissaHead : std_logic_vector(1 downto 0);
begin
--Mantissa Head
	mantissaHead <= mantissaIn(47 downto 46);
	
--Set Up Components
	shiftCalculatorUnit: shiftCalculator port map(mantissaIn,numLeftShifts);
	barrelShifterUnit: barrelShifter port map(mantissaIn,numLeftShifts,mantissaLeftShifted);
	exponentSubtractorUnit : exponentSubtractor port map(exponentIn,numLeftShifts,exponentSubtracted);
	exponentIncrementorUnit : exponentIncrementor port map(exponentIn,exponentAdded);

--Right Shift
	mantissaRightShifted <= '0' & mantissaIn(47 downto 1);

--Select Correct Components Based on Head of Mantissa
 	with mantissaHead select mantissaRenorm <= 
		mantissaIn when "01",
		mantissaLeftShifted when "00",
		mantissaRightShifted when "11" | "10",
		(others => 'Z') when others;
	with mantissaHead select exponentRenorm <=
		exponentIn when "01",
		exponentAdded when "11" | "10",
		exponentSubtracted when "00",
		(others => 'Z') when others;

--Enable Bit
	with enableIn select zOut <=
		signIn & exponentIn(8 downto 1) & mantissaIn(45 downto 23) when '0',
		(others => 'Z') when others;
end behave;