library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity numShifterTb is
end entity numShifterTb;

architecture behave of numShifterTb is
component numShifter is
	PORT(
		mantissaIn : in std_logic_vector(47 downto 0);
		numShifts : in std_logic_vector(5 downto 0);
		mantissaShifted : out std_logic_vector(47 downto 0)
	);
end component;
FOR ALL: numShifter use ENTITY work.numShifter(behave);
signal rand_to_be_shifted : integer;
signal rand_num_shifts : integer := 1;
signal mantissaIn, mantissaShifted, mantissaExpected : std_logic_vector(47 downto 0);
signal zeroMantissa : std_logic_vector(47 downto 0) := (others => '0');
signal correct : boolean;
signal numShifts : std_logic_vector(5 downto 0);
begin
uut: numShifter port map(mantissaIn,numShifts,mantissaShifted);
correct <= mantissaShifted = mantissaExpected;
mantissaExpected <= mantissaIn(47-rand_num_shifts downto 0) & zeroMantissa((rand_num_shifts-1) downto 0);
applyTest:process(rand_num_shifts)
begin
	mantissaIn <= std_logic_vector(to_unsigned(rand_to_be_shifted,48));
	numShifts <= std_logic_vector(to_unsigned(rand_num_shifts,6));
	end process;
generateRandom: process
	variable seed1,seed2: positive;
	variable seed3,seed4: positive;
	variable rand2: real;
	variable range_of_rand2 : real :=  3000.0;
	variable rand: real;
	variable range_of_rand : real := 46.0;
begin
uniform(seed1,seed2,rand);
uniform(seed3,seed4,rand2);
rand_num_shifts <= integer(rand*range_of_rand);
rand_to_be_shifted <= integer(rand2*range_of_rand2)*rand_num_shifts;
wait for 20 ns;
end process;
end behave;