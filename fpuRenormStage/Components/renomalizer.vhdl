library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity renormalizer is
	PORT(
		enableIn : in std_logic;
		signIn : in std_logic;
		exponentIn : in std_logic_vector(7 downto 0);
		mantissaIn : in std_logic_vector(47 downto 0);
		aHigh : in std_logic;
		bHigh : in std_logic;
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
component numShifter is
	PORT(
		mantissaIn : in std_logic_vector(47 downto 0);
		numShifts : in std_logic_vector(5 downto 0);
		mantissaShifted : out std_logic_vector(47 downto 0)
	);
end component;
component exponentSubtractor is 
	PORT(
		a : in std_logic_vector(9 downto 0);
		numLeftShifts : in std_logic_vector(5 downto 0);
		exponentSubtracted : out std_logic_vector(9 downto 0)
	);
end component;
component exponentIncrementor is
	PORT(
		a : in std_logic_vector(9 downto 0);
		c : out std_logic_vector(9 downto 0)
	);
end component;
component underFlowUnit is
	PORT(
		exponentIn : in std_logic_vector(9 downto 0);
		mantissaIn : in std_logic_vector(47 downto 0);
		mantissaOut : out std_logic_vector(47 downto 0)
	);
end component;
for all : underFlowUnit use ENTITY work.underFlowUnit(behave);
for all : shiftCalculator use ENTITY work.shiftCalculator(behave);
for all : numShifter use ENTITY work.numShifter(behave);
for all : exponentSubtractor use ENTITY work.exponentSubtractor(behave);
for all : exponentIncrementor use ENTITY work.exponentIncrementor(behave);

--Convert aHigh and bHigh to overflow/underflow
	signal underFlowOverFlow : std_logic_vector(2 downto 0);
	signal convertedInput : std_logic_vector(9 downto 0);
	signal topTwoBits : std_logic_vector(1 downto 0);

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

--Values after the First Step
	signal mantissaStep : std_logic_vector(47 downto 0);
	signal exponentStep : std_logic_vector(9 downto 0);

--Underflow Output Signals
	signal exponentStepInverted : std_logic_vector(9 downto 0);
	signal mantissaStepInverted : std_logic_vector(47 downto 0);
	signal exponentUnderflow : std_logic_vector(9 downto 0);
	signal numRightShifts : std_logic_vector(9 downto 0);
	signal mantissaRightShiftedInverted : std_logic_vector(47 downto 0);
	signal mantissaCorrectForDenorm : std_logic_vector(47 downto 0);
	
--Overflow Output Signals
	signal exponentOverflow : std_logic_vector(9 downto 0);
	signal mantissaOverflow : std_logic_vector(47 downto 0);

--Decide Overflow or Underflow Signals
	signal exponentStepHead : std_logic_vector(1 downto 0);

--Check if you passing through a denormalizer number
	signal checkDenorm : std_logic;
	signal exponentStepHeadPlusDenorm : std_logic_vector(3 downto 0);
--Check if your passing inf
	signal checkInf : std_logic;
begin
--Overflow Underflow Calculation
	underFlowOverFlow(0) <= exponentIn(7);
	underFlowOverFlow(1) <= aHigh;
	underFlowOverFlow(2) <= bHigh;
	
	with underFlowOverFlow select topTwoBits <=
		"11" when "001",
		"01" when "110",
		"00" when others;
		
	convertedInput <= topTwoBits & exponentIn;

--Mantissa Head
	mantissaHead <= mantissaIn(47 downto 46);
	
--Set Up First Stage Components
	--Output Number of Shifts Needed
	shiftCalculatorUnit: shiftCalculator port map(mantissaIn,numLeftShifts);
	--Output's Mantissa Left Shifted
	leftShifterUnit: numShifter port map(mantissaIn,numLeftShifts,mantissaLeftShifted);
	--Subtracts based on number of left shifts
	exponentSubtractorUnit : exponentSubtractor port map(convertedInput,numLeftShifts,exponentSubtracted);
	--Increments an exponent, represents a single right shift.	
	exponentIncrementorUnit : exponentIncrementor port map(convertedInput,exponentAdded);

--Right Shift
	mantissaRightShifted <= '0' & mantissaIn(47 downto 1);

--Select Correct Components Based on Head of Mantissa
 	with mantissaHead select mantissaStep <= 
		mantissaIn when "01",
		mantissaLeftShifted when "00",
		mantissaRightShifted when "11" | "10",
		(others => 'Z') when others;

	with mantissaHead select exponentStep <=
		convertedInput when "01",
		exponentAdded when "11" | "10",
		exponentSubtracted when "00",
		(others => 'Z') when others;

--Underflow 
	exponentUnderflow <= (others=> '0');
	underFlowUnitUnit : underFlowUnit port map(exponentStep, mantissaStep, mantissaCorrectForDenorm); 

--Overflow Output
	exponentOverflow <= (others => '1');
	mantissaOverflow <= (others => '0');

--Select Correct Behavior Based on exponentStep
--11 | 10 represents underflow
--01 represents overflow
--00 represents just right, aka just passthrough the mantissa step without any correction.
--If exponentStep is a Denorm
	checkInf <= exponentStep(0) and exponentStep(1) and exponentStep(2)and exponentStep(3) and exponentStep(4) and exponentStep(5) and exponentStep(6) and exponentStep(7);
	checkDenorm <= not(exponentStep(0)) and not(exponentStep(1)) and not(exponentStep(2)) and not(exponentStep(3)) and not(exponentStep(4)) and not(exponentStep(5)) and not(exponentStep(6)) and not(exponentStep(7)) and not(exponentStep(8)) and not(exponentStep(9));
	exponentStepHead <= exponentStep(9 downto 8);
	exponentStepHeadPlusDenorm <= exponentStep(9 downto 8) & checkDenorm & checkInf;
	with exponentStepHead select exponentRenorm <=
		exponentUnderflow when "11" | "10",
		exponentOverflow when "01",
		exponentStep when "00",
		(others => 'Z') when others;
	with exponentStepHeadPlusDenorm select mantissaRenorm <= 
		mantissaCorrectForDenorm when "1100" | "1000" | "1101",
		mantissaOverflow when "0100" | "0001",
		mantissaStep when "0000",
		'0' & mantissaStep(47 downto 1) when "0010",
		(others => 'Z') when others;
		
--Enable Bit
	with enableIn select zOut <=
		signIn & exponentIn(7 downto 0) & mantissaIn(46 downto 24) when '0',
		signIn & exponentRenorm(7 downto 0) & mantissaRenorm(45 downto 23) when '1',
		(others=>'Z') when others; 

end behave;