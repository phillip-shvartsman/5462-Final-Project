-- YOU MUST run >qvmap  /rcc4/faculty/degroat/ee762_assign/assign
-- BEFORE TRYING TO COMPILE THIS TESTBENCH

library ieee, assign;
use ieee.std_logic_1164.all;
use ASSIGN.fpm_test_vect.all;
use STD.TEXTIO.all;
use WORK.package_ps6.ALL;
USE ieee.numeric_std.ALL;
entity stealfpm IS
	PORT(A,B : IN std_logic_vector(31 downto 0);
	latch,drive : IN std_ulogic;
	C : OUT std_logic_vector(31 downto 0)
	);
END stealfpm;

architecture behavioral of stealfpm IS
	signal enable : std_logic;
	signal Ahigh : std_logic;
	signal Bhigh : std_logic;
	signal exponentIn : std_logic_vector(7 downto 0);
	signal mantissaIn : std_logic_vector(47 downto 0);
	signal signIn : std_logic;
	signal zOut : std_logic_vector(31 downto 0);
	signal Awon : boolean;
	signal Bwon : boolean;
	component renormalizer is
	PORT(
		enableIn : in std_logic;
		signIn : in std_logic;
		exponentIn : in std_logic_vector(7 downto 0);
		mantissaIn : in std_logic_vector(47 downto 0);
		aHigh : in std_logic;
		bHigh : in std_logic;
		zOut : out std_logic_vector(31 downto 0)
	);
	end component;
	FOR ALL: renormalizer use ENTITY work.renormalizer(behave);
	
	begin
	uut: renormalizer port map(enable,signIn,exponentIn,mantissaIn,Ahigh,Bhigh,zOut);
	process(latch,drive)
	variable Ain,Bin : std_logic_vector(31 downto 0);
	variable Cinternal : std_logic_vector(31 downto 0);
	variable oneExponent : std_logic_vector(7 downto 0) := (others => '1');
	variable zeroExponent : std_logic_vector(7 downto 0) := (others => '0');
	variable zeroFraction : std_logic_vector(22 downto 0) := (others => '0');
	variable allZ : std_logic_vector(31 downto 0) := (others => 'Z');		
	variable prod_term : bit_vector(47 downto 0) := (others => '0');
	variable mantisA : std_logic_vector(23 downto 0);
	variable mantisB : std_logic_vector(23 downto 0);
	variable result : bit_vector(47 downto 0) := (others => '0');
	variable zeroResult : bit_vector(47 downto 0) := (others => '0');
	variable garbageCout : bit;
	variable subshifts : integer;
	variable exponentA : integer;
	variable exponentB : integer;
	variable exponentResult : integer;
	variable shifts : integer;
	variable signResult : std_ulogic;
	variable Ainf : boolean;
	variable Binf: boolean;
	variable Azero : boolean;
	variable Bzero : boolean;
	variable Anan : boolean;
	variable Bnan : boolean;
	variable Adenorm : boolean;
	variable Bdenorm : boolean;
	variable Aone : boolean;
	variable Bone : boolean;
	begin
		--Drive the results
		if(drive'event and drive = '0') then
			if(enable = '1') then
				C <= zOut;
			else	
				C <= Cinternal;
			end if;
		--Stop driving after the drive period
		elsif(drive'event and drive = '1') then
			C <= allZ;
		elsif(latch'event and latch = '0') then
			Ain:=A;
			Bin:=B;
			Ainf := A(30 downto 23) = oneExponent and A(22 downto 0) = zeroFraction;
			Binf := B(30 downto 23) = oneExponent and B(22 downto 0) = zeroFraction;
			Anan := A(30 downto 23) = oneExponent and not(A(22 downto 0) = zeroFraction);
			Bnan := B(30 downto 23) = oneExponent and not(B(22 downto 0) = zeroFraction);
			Azero := A(30 downto 23) = zeroExponent and A(22 downto 0) = zeroFraction;
			Bzero := B(30 downto 23) = zeroExponent and B(22 downto 0) = zeroFraction;
			Adenorm := A(30 downto 23) = zeroExponent and not(A(22 downto 0) = zeroFraction);
			Bdenorm := B(30 downto 23) = zeroExponent and not(B(22 downto 0) = zeroFraction);
			Aone := A(30 downto 23) = "01111111" and B(22 downto 0) = zeroFraction;
			Bone := B(30 downto 23) = "01111111" and B(22 downto 0) = zeroFraction;
			Awon <= Aone;
			Bwon <= Bone;
			--Check if NaN
			if(Anan or Bnan) then
				Cinternal(Cinternal'high) := '0';
				Cinternal(30 downto 23) := oneExponent;
				Cinternal(22 downto 0) := zeroFraction;
				Cinternal(0) := '1';
				enable <= '0';
			elsif(Ainf and Binf) then
				Cinternal(Cinternal'high) := Ain(Ain'high) xor Bin(Bin'high);
				Cinternal(30 downto 23) := oneExponent;
				Cinternal(22 downto 0) := zeroFraction;
				enable <= '0';
			elsif(Ainf or Binf) then
				if(Azero or Bzero) then
					Cinternal(Cinternal'high) := '0';
					Cinternal(30 downto 23) := oneExponent;
					Cinternal(22 downto 0) := zeroFraction;
					Cinternal(0) := '1';
				else
					Cinternal(Cinternal'high) := Ain(Ain'high) xor Bin(Bin'high);
					Cinternal(30 downto 23) := oneExponent;
					Cinternal(22 downto 0) := zeroFraction;
				end if;
				enable <= '0';
			elsif(Azero or Bzero) then
				enable <= '0';
				Cinternal(Cinternal'high) := Ain(Ain'high) xor Bin(Bin'high);
				Cinternal(30 downto 23) := zeroExponent;
				Cinternal(22 downto 0) := zeroFraction;
			elsif(Adenorm and Bdenorm) then
				enable <= '0';
				Cinternal(Cinternal'high) := Ain(Ain'high) xor Bin(Bin'high);
				Cinternal(30 downto 23) := zeroExponent;
				Cinternal(22 downto 0) := zeroFraction;
			elsif(Aone or Bone) then
				enable <= '0';
				if(Aone) then
					Cinternal(Cinternal'high) := Ain(Ain'high) xor Bin(Bin'high);
					Cinternal(30 downto 23) := Bin(30 downto 23);
					Cinternal(22 downto 0) := Bin(22 downto 0);
				elsif(Bone) then
					Cinternal(Cinternal'high) := Ain(Ain'high) xor Bin(Bin'high);
					Cinternal(30 downto 23) := Ain(30 downto 23);
					Cinternal(22 downto 0) := Ain(22 downto 0);
				end if;
			else
				enable <= '1';
				mantisA(22 downto 0) := Ain(22 downto 0);
				mantisA(mantisA'high) := '1';
				if(Adenorm) then
					mantisA(mantisA'high) := '0';
				end if;
				mantisB(22 downto 0) := Bin(22 downto 0);
				mantisB(mantisB'high) := '1';
				if(Bdenorm) then
					mantisB(mantisB'high) := '0';				
				end if;								
				
				
				exponentA := to_integer(unsigned(Ain(30 downto 23)))-127;
				exponentB := to_integer(unsigned(Bin(30 downto 23)))-127;
				if(Adenorm) then
					exponentA := -126;
				end if;
				if(Bdenorm) then
					exponentB := -126;
				end if;				
				
				exponentResult := (exponentA + exponentB)+127;
				
				Ahigh <= Ain(30);
				Bhigh <= Bin(30);
				exponentIn <= std_logic_vector(to_signed(exponentResult,8));
				
				prod_term:= zeroResult;
				result:=zeroResult;
				--Load the Mantissa in to the prod_term
				prod_term(mantisA'range) := to_BitVector(mantisA);
				for i in mantisB'reverse_range loop
					if(mantisB(i) = '1')then
						binadd(result,prod_term,'0',result,garbageCout);
					end if;
					prod_term := prod_term sll 1;
				end loop;
				signIn <= Bin(Bin'high) xor Ain(Ain'high);
				mantissaIn <= to_stdlogicvector(result);
			end if;
		end if;	
	end process;
end behavioral;
--use ASSIGN.fpm_test_vect.all;

library ieee, assign;
use ieee.std_logic_1164.all;
use work.fpm_test_vect.all;
use STD.TEXTIO.all;

entity stealfpmtb is
end stealfpmtb;

architecture my_test of stealfpmtb is
  signal A,B,C : std_logic_vector (31 downto 0);
  signal exp_res : std_logic_vector (31 downto 0);
  signal latch,drive : std_ulogic := '0';
  signal aid_sig, bid_sig, resid_sig : string(1 to 6) := "======";
  signal err_sig : bit;
  signal score : integer := 0;


-- Place your component declaration and configuration here
component stealfpm 
  PORT (A,B : IN std_logic_vector (31 downto 0);
        latch, drive: IN std_ulogic;
        C : OUT std_logic_vector (31 downto 0));
end component;
for all : stealfpm use ENTITY work.stealfpm(behavioral);

--Enter your name in the (  )
  TYPE mname IS (Phillip_Shvartsman);
  SIGNAL nm : mname := mname'VAL(0);

BEGIN -- test architecture

-- Instantiate your component here
fpm0:  stealfpm PORT MAP(A,B,latch,drive,C);

gen_vec(aid_sig,bid_sig,resid_sig,A,B,exp_res,C,latch,drive,err_sig,score);

nm<= mname'VAL(0);

end my_test;