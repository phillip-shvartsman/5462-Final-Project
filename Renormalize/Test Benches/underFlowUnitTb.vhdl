library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity underFlowUnitTb is
end entity underFlowUnitTb;

architecture behave of underFlowUnitTb is
component underFlowUnit is 
	PORT(
		exponentIn : in std_logic_vector(9 downto 0);
		mantissaIn : in std_logic_vector(47 downto 0);
		mantissaOut : out std_logic_vector(47 downto 0)
	);
end component;
FOR ALL: underFlowUnit use ENTITY work.underFlowUnit(behave);
signal exponentIn : std_logic_vector(9 downto 0);
signal mantissaIn, mantissaShifted : std_logic_vector(47 downto 0);
signal rand_num_shifts : integer;
signal rand_to_be_shifted : integer;
signal mantissaExpected : std_logic_vector(47 downto 0);
signal correct : boolean;
begin
uut: underFlowUnit port map(exponentIn,mantissaIn,mantissaShifted);
mantissaExpected <= to_stdlogicvector(to_bitvector(mantissaIn) srl abs(rand_num_shifts));
correct <= mantissaExpected = mantissaShifted;
applyTest:process(rand_num_shifts)
begin
	exponentIn <= std_logic_vector(to_signed(rand_num_shifts,10));
	mantissaIn <= std_logic_vector(to_unsigned(rand_to_be_shifted,48));
end process;
generateRandom: process
	variable seed1,seed2: positive;
	variable seed3,seed4: positive;
	variable rand2: real;
	variable range_of_rand2 : real :=  3000.0;
	variable rand: real;
	variable range_of_rand : real := 50.0;
begin
uniform(seed1,seed2,rand);
uniform(seed3,seed4,rand2);
rand_num_shifts <= -1*integer(rand*range_of_rand);
rand_to_be_shifted <= integer(rand2*range_of_rand2)*abs(rand_num_shifts);
wait for 20 ns;
end process;
end behave;