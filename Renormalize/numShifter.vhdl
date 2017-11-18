--Not really a barrel shifter but I think this is just as fast.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity numShifter is
	PORT(
		mantissaIn : in std_logic_vector(47 downto 0);
		numShifts : in std_logic_vector(5 downto 0);
		mantissaShifted : out std_logic_vector(47 downto 0)
	);
end numShifter;

architecture behave of numShifter is
type shifterArrayType is array(5 downto 0) of std_logic_vector(47 downto 0);
signal shifterArray : shifterArrayType;
begin
	with numShifts(0) select shifterArray(0) <=
		mantissaIn(46 downto 0) & '0' when '1',
		mantissaIn when '0',
		(others => 'Z') when others;
	with numShifts(1) select shifterArray(1) <=
		shifterArray(0)(45 downto 0) & "00" when '1',
		shifterArray(0) when '0',
		(others => 'Z') when others;
	with numShifts(2) select shifterArray(2) <=
		shifterArray(1)(43 downto 0) & "0000" when '1',
		shifterArray(1) when '0',
		(others => 'Z') when others;
	with numShifts(3) select shifterArray(3) <=
		shifterArray(2)(39 downto 0) & "00000000" when '1',
		shifterArray(2) when '0',
		(others => 'Z') when others;
	with numShifts(4) select shifterArray(4) <=
		shifterArray(3)(31 downto 0) & "0000000000000000" when '1',
		shifterArray(3) when '0',
		(others => 'Z') when others;
	with numShifts(5) select shifterArray(5) <=
		shifterArray(4)(15 downto 0) & "00000000000000000000000000000000" when '1',
		shifterArray(4) when '0',
		(others => 'Z') when others;
	mantissaShifted <= shifterArray(5);
end behave;