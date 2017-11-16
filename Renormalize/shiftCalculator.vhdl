library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity shiftCalculator is
	PORT(
		mantissaIn : in std_logic_vector(47 downto 0);
		shiftsOut : out std_logic_vector(5 downto 0)
	);
end shiftCalculator;

architecture behave of shiftCalculator is
--Diagram of Solution--------------------
--http://simulator.io/board/07pAZ5szSK/2
-----------------------------------------
signal oneHot1 : std_logic_vector(46 downto 0);
signal oneHot2 : std_logic_vector(46 downto 0);
signal orLayerLSB : std_logic_vector(11 downto 0);
signal orLayerBit1 : std_logic_vector(11 downto 0);
signal orLayerBit2 : std_logic_vector(11 downto 0);
signal orLayerBit3 : std_logic_vector(11 downto 0);
signal orLayerBit4 : std_logic_vector(7 downto 0);
signal orLayerBit5 : std_logic_vector(7 downto 0);
begin
--Generate One Hot
	oneHot1(46) <= mantissaIn(46); 
	oneHot2(46) <= oneHot1(46);
	generateOneHot:
	for i in 45 downto 0 generate
		oneHot1(i) <= oneHot1(i+1) or mantissaIn(i);
		oneHot2(i) <= not(oneHot1(i+1)) and oneHot1(i);
	end generate generateOneHot;
	
--Generate LSB Or Gates
	orLayerLSB(11)<= oneHot2(46-45);
	generateOrLayerLSB:
	for i in 10 downto 0 generate
		orLayerLSB(i) <= oneHot2(46-(i*4+1)) or oneHot2(46-(i*4+3)); 
	end generate generateOrLayerLSB;

--Generate 1st Bit Or Gates
	generateOrLayerBit1:
	for i in 0 to 10 generate
		orLayerBit1(i) <= oneHot2(46-(i*4+2)) or oneHot2(46-(i*4+3));
	end generate generateOrLayerBit1;
	orLayerBit1(11) <= oneHot2(46-(11*4+2));
	
--Generate 2nd Bit Or Gates
	generateOrLayerBit2:
	for i in 0 to 4 generate
		orLayerBit2(i) <= oneHot2(46-(i*8+4)) or oneHot2(46-(i*8+5));
		orLayerBit2(i + 6) <= oneHot2(46-(i*8+6)) or oneHot2(46-(i*8+7));
	end generate generateOrLayerBit2;
	orLayerBit2(5) <= oneHot2(46-(5*8+4)) or oneHot2(46-(5*8+5));
	orLayerBit2(11) <= oneHot2(46-(5*8+6));

--Generate 3rd Bit Or Gates
	generateOrLayerBit3:
	for i in 0 to 2 generate
		first2: if i < 2 generate
			orLayerBit3(i) <= oneHot2(46-(i*16+8)) or oneHot2(46-(i*16+9));
			orLayerBit3(i+3) <= oneHot2(46-(i*16+10)) or oneHot2(46-(i*16+11));
			orLayerBit3(i+6) <= oneHot2(46-(i*16+12)) or oneHot2(46-(i*16+13));
			orLayerBit3(i+9) <= oneHot2(46-(i*16+14)) or oneHot2(46-(i*16+15));
		end generate first2;
		last1: if i = 2 generate
			orLayerBit3(i) <= oneHot2(46-(i*16+8)) or oneHot2(46-(i*16+9));
			orLayerBit3(i+3) <= oneHot2(46-(i*16+10)) or oneHot2(46-(i*16+11));
			orLayerBit3(i+6) <= oneHot2(46-(i*16+12)) or oneHot2(46-(i*16+13));
			orLayerBit3(i+9) <= oneHot2(46-(i*16+14));
		end generate last1;
	end generate generateOrLayerBit3;

--Generate 4th Bit Or Gates
	generateOrLayerBit4:
	for i in 0 to 7 generate
		orLayerBit4(i) <= oneHot2(46-(i+16)) or oneHot2(46-(i+24));
	end generate generateOrLayerBit4;
	
--Generate 5th Bit Or Gates
	generateOrLayerBit5:
	for i in 0 to 6 generate
		orLayerBit5(i) <= oneHot2(46-(32 + i)) or oneHot2(46-(40 + i));
	end generate generateOrLayerBit5;
	orLayerBit5(7) <= oneHot2(46-(32 + 7));

--Generate Output
	shiftsOut(0) <= orLayerLSB(0) or orLayerLSB(1) or orLayerLSB(2) or orLayerLSB(3) or orLayerLSB(4) or orLayerLSB(5) or orLayerLSB(6) or orLayerLSB(7) or orLayerLSB(8) or orLayerLSB(9) or orLayerLSB(10) or orLayerLSB(11);
	shiftsOut(1) <= orLayerBit1(0) or orLayerBit1(1) or orLayerBit1(2) or orLayerBit1(3) or orLayerBit1(4) or orLayerBit1(5) or orLayerBit1(6) or orLayerBit1(7) or orLayerBit1(8) or orLayerBit1(9) or orLayerBit1(10) or orLayerBit1(11);
	shiftsOut(2) <= orLayerBit2(0) or orLayerBit2(1) or orLayerBit2(2) or orLayerBit2(3) or orLayerBit2(4) or orLayerBit2(5) or orLayerBit2(6) or orLayerBit2(7) or orLayerBit2(8) or orLayerBit2(9) or orLayerBit2(10) or orLayerBit2(11);
	shiftsOut(3) <= orLayerBit3(0) or orLayerBit3(1) or orLayerBit3(2) or orLayerBit3(3) or orLayerBit3(4) or orLayerBit3(5) or orLayerBit3(6) or orLayerBit3(7) or orLayerBit3(8) or orLayerBit3(9) or orLayerBit3(10) or orLayerBit3(11);
	shiftsOut(4) <= orLayerBit4(0) or orLayerBit4(1) or orLayerBit4(2) or orLayerBit4(3) or orLayerBit4(4) or orLayerBit4(5) or orLayerBit4(6) or orLayerBit4(7);
	shiftsOut(5) <= orLayerBit5(0) or orLayerBit5(1) or orLayerBit5(2) or orLayerBit5(3) or orLayerBit5(4) or orLayerBit5(5) or orLayerBit5(6) or orLayerBit5(7);
	
end behave;