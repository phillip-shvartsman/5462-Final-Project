library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity subtracterTb is
end subtracterTb;

architecture behave of subtracterTb is
component exponentSubtractor is 
	PORT(
		a : in std_logic_vector(9 downto 0);
		numLeftShifts : in std_logic_vector(5 downto 0);
		exponentSubtracted : out std_logic_vector(9 downto 0)
	);
end component;
for all : exponentSubtractor use ENTITY work.exponentSubtractor(behave);
signal aint,bint,zint : integer;
signal a : std_logic_vector(9 downto 0);
signal b : std_logic_vector(5 downto 0);
signal z : std_logic_vector(9 downto 0);
signal zexpected : integer;
signal correct : boolean;
begin
aint <= to_integer(unsigned(a));
bint <= to_integer(unsigned(b));
zint <= to_integer(unsigned(z));
zexpected <= to_integer(signed(a))-to_integer(signed(b));
correct <= zexpected = zint;
uut: exponentSubtractor port map(a,b,z);
applyTests: process
	begin
		a <= std_logic_vector(to_unsigned(255,10));
		for i in 0 to 47 loop
			b <= std_logic_vector(to_unsigned(i,6));
			wait for 20 ns;
		end loop;
		a <= std_logic_vector(to_unsigned(0,10));
		for i in 0 to 47 loop
			b <= std_logic_vector(to_unsigned(i,6));
			wait for 20 ns;
		end  loop;
		for i in 0 to 15 loop
			a <= std_logic_vector(to_unsigned((47-i)*4,10));
			b <= std_logic_vector(to_unsigned(i-1,6));
		wait for 50 ns;
		end loop;
		for i in 0 to 30 loop
			a <= std_logic_vector(to_unsigned((47-i),10));
			b <= std_logic_vector(to_unsigned(i-1,6));
		wait for 50 ns;
		end loop;
	end process;
end behave;