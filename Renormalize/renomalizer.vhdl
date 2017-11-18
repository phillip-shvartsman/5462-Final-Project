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
		exponentIn : in std_logic_vector(9 downto 0);
		exponentAdded : out std_logic_vector(9 downto 0)
	);
end component;
for all : shiftCalculator use ENTITY work.shiftCalculator(behave);
for all : numShifter use ENTITY work.numShifter(behave);
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
begin
--Mantissa Head
	mantissaHead <= mantissaIn(47 downto 46);
	
--Set Up First Stage Components
	--Output Number of Shifts Needed
	shiftCalculatorUnit: shiftCalculator port map(mantissaIn,numLeftShifts);
	--Output's Mantissa Left Shifted
	leftShifterUnit: numShifter port map(mantissaIn,numLeftShifts,mantissaLeftShifted);
	--Subtracts based on number of left shifts
	exponentSubtractorUnit : exponentSubtractor port map(exponentIn,numLeftShifts,exponentSubtracted);
	--Increments an exponent, represents a single right shift.	
	exponentIncrementorUnit : exponentIncrementor port map(exponentIn,exponentAdded);

--Right Shift
	mantissaRightShifted <= '0' & mantissaIn(47 downto 1);

--Select Correct Components Based on Head of Mantissa
 	with mantissaHead select mantissaStep <= 
		mantissaIn when "01",
		mantissaLeftShifted when "00",
		mantissaRightShifted when "11" | "10",
		(others => 'Z') when others;

	with mantissaHead select exponentStep <=
		exponentIn when "01",
		exponentAdded when "11" | "10",
		exponentSubtracted when "00",
		(others => 'Z') when others;

--Underflow Should move to its own component for easier verification------
--Implements the following behavioral code:
--elsif(exponentResult < 0 ) then			
--	result := result srl abs(exponentResult);
--	Cinternal(30 downto 23) := "00000000";
--	Cinternal(22 downto 0) := to_stdlogicVector(result(46 downto 24));
--------------------------------------------------------------------------
	exponentUnderflow <= (others=> '0');
	exponentStepInverted <= not(exponentStep);
	mantissaStepInverted <= not(mantissaStep);
	--Adds 1 to the inverted exponent to get 2's compliment	
	underFlowShiftIncrementorUnit: exponentIncrementor port map(exponentStepInverted,numRightShifts);
	--Uses this to shift the inverted mantissa left, aka right shift	
	shiftRightUnit: numShifter port map(mantissaStepInverted,numRightShifts(5 downto 0),mantissaRightShifted);
	--Invert it back and shift again to account for denorm
	mantissaRightShiftedInverted <= not(mantissaRightShifted);
	mantissaCorrectForDenorm <= mantissaRightShiftedInverted(46 downto 0) & '0' ;

--Overflow Output
	exponentOverflow <= (others => '1');
	mantissaOverflow <= (others => '0');

--Select Correct Behavior Based on exponentStep
--11 | 10 represents underflow
--01 represents overflow
--00 represents just right, aka just passthrough the mantissa step without any correction.
	exponentStepHead <= exponentStep(9 downto 8);
	with exponentStepHead select exponentRenorm <=
		exponentUnderflow when "11" | "10",
		exponentOverflow when "01",
		exponentStep when "00",
		(others => 'Z') when others;
	with exponentStepHead select mantissaRenorm <= 
		mantissaCorrectForDenorm when "11" | "10",
		mantissaOverflow when "01",
		mantissaStep when "00",
		(others => 'Z') when others;
		
--Enable Bit
	with enableIn select zOut <=
		signIn & exponentIn(7 downto 0) & mantissaIn(45 downto 23) when '0',
		signIn & exponentRenorm(7 downto 0) & mantissaRenorm(45 downto 23) when '1',
		(others=>'Z') when others; 

end behave;