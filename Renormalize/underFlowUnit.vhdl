library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity underFlowUnit is 
	PORT(
		exponentIn : in std_logic_vector(9 downto 0);
		mantissaIn : in std_logic_vector(47 downto 0);
		mantissaOut : out std_logic_vector(47 downto 0)
	);
end underFlowUnit;

architecture behave of underFlowUnit is
type shifterArrayType is array(5 downto 0) of std_logic_vector(47 downto 0);
signal shifterArray : shifterArrayType;
signal exponentInverted : std_logic_vector(9 downto 0);
signal exponentTwosComp : std_logic_vector(9 downto 0);
signal automaticZeroMantissa : std_logic;
signal mantissaShifted : std_logic_vector(47 downto 0);
component exponentIncrementor is
	PORT(
		a : in std_logic_vector(9 downto 0);
		c : out std_logic_vector(9 downto 0)
	);
end component;
for all :exponentIncrementor use ENTITY work.exponentIncrementor(behave);
begin
	exponentInverted <= not(exponentIn);
	underFlowShiftIncrementorUnit: exponentIncrementor port map(exponentInverted,exponentTwosComp);
	automaticZeroMantissa <= exponentInverted(8) or exponentInverted(7) or exponentInverted(6) or exponentInverted(9);
	
	with exponentTwosComp(0) select shifterArray(0) <=
		'0' & mantissaIn(47 downto 1) when '1',
		mantissaIn when '0',
		(others => 'Z') when others; 
	with exponentTwosComp(1) select shifterArray(1) <=
		"00" & shifterArray(0)(47 downto 2) when '1',
		shifterArray(0) when '0',
		(others=> 'Z') when others;
	with exponentTwosComp(2) select shifterArray(2) <=
		"0000" & shifterArray(1)(47 downto 4) when '1',
		shifterArray(1) when '0',
		(others => 'Z') when others;
	with exponentTwosComp(3) select shifterArray(3) <=
		"00000000" & shifterArray(2)(47 downto 8) when '1',
		shifterArray(2) when '0',
		(others => 'Z') when others;
	with exponentTwosComp(4) select shifterArray(4) <=
		"0000000000000000" & shifterArray(3)(47 downto 16) when '1',
		shifterArray(3) when '0',
		(others => 'Z') when others;
	with exponentTwosComp(5) select shifterArray(5) <=
		"00000000000000000000000000000000" & shifterArray(4)(47 downto 32) when '1',
		shifterArray(4) when '0',
		(others => 'Z') when others;
	
	with automaticZeroMantissa select mantissaShifted <=
		(others=>'0') when '1',
		shifterArray(5) when '0',
		(others=>'Z') when others;

	mantissaOut <= '0' & mantissaShifted(46 downto 0);

end behave;