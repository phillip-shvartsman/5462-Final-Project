library ieee;
use ieee.std_logic_1164.all;
use STD.TEXTIO.all;

package fpuPrepareStage_test is

constant ZEROS : std_logic_vector (32 downto 0) := (others => '0');

procedure prepare_vect (SIGNAL aid_sig, bid_sig 	: OUT string (1 to 6);
			SIGNAL aval, bval 		: OUT std_logic_vector (31 downto 0);
			SIGNAL ASMval 			: OUT std_logic_vector(1 downto 0);
  			SIGNAL s_A, s_B, ENABLE 	: IN std_logic;
			SIGNAL exp_A, exp_B 		: IN std_logic_vector(7 downto 0);
			SIGNAL man_A, man_B 		: IN std_logic_vector(23 downto 0);
			SIGNAL sAerr, sBerr, ENerr 	: OUT bit;
  			SIGNAL expAerr, expBerr		: OUT bit;
  			SIGNAL manAerr, manBerr		: OUT bit;
			SIGNAL EX_expA_val, EX_expB_val	: OUT std_logic_vector (7 downto 0);
		 	SIGNAL EX_manA_val, EX_manB_val : OUT std_logic_vector(23 downto 0);
  			SIGNAL EX_sA_val, EX_sB_val	: OUT std_logic;
			SIGNAL EX_enable_val		: OUT std_logic
			);
end fpuPrepareStage_test 

package body fpuPrepareStage_test is

procedure prepare_vect (SIGNAL aid_sig, bid_sig 	: OUT string (1 to 6);
			SIGNAL aval, bval 		: OUT std_logic_vector (31 downto 0);
			SIGNAL ASMval 			: OUT std_logic_vector(1 downto 0);
  			SIGNAL s_A, s_B, ENABLE 	: IN std_logic;
			SIGNAL exp_A, exp_B 		: IN std_logic_vector(7 downto 0);
			SIGNAL man_A, man_B 		: IN std_logic_vector(23 downto 0);
			SIGNAL sAerr, sBerr, ENerr 	: OUT bit;
  			SIGNAL expAerr, expBerr		: OUT bit;
  			SIGNAL manAerr, manBerr		: OUT bit;
			SIGNAL EX_expA_val, EX_expB_val	: OUT std_logic_vector (7 downto 0);
		 	SIGNAL EX_manA_val, EX_manB_val : OUT std_logic_vector(23 downto 0);
  			SIGNAL EX_sA_val, EX_sB_val	: OUT std_logic;
			SIGNAL EX_enable_val		: OUT std_logic
			) is

	VARIABLE cur_line : LINE;
	FILE test_data: TEXT OPEN read_mode IS "fpmprepare_vectors";

	VARIABLE a_test_val, b_test_val 	: std_logic_vector (31 downto 0);
	VARIABLE sA_val, sB_val			: std_logic;
	VARIABLE ASM_val 			: std_logic_vector(1 downto 0);
	VARIABLE expA_val, expB_val 		: std_logic_vector (7 downto 0);
	VARIABLE manA_val, manB_val 		: std_logic_vector(23 downto 0);
	VARIABLE enable_val 			: std_logic;
	
	VARIABLE aid, bid, ASMid, sAid, expAid, manAid, sBid, expBid, manBid, ENid : string(1 to 6);

	BEGIN

	aval <= ZEROS(aval'RANGE);
	bval <= ZEROS(bval'RANGE);
	ASMval <= ZEROS(ASMval'RANGE);

	-- Expected Output
	EX_sA_val <= '0';
	EX_expA_val <= ZEROS(EX_expA_val'RANGE);
	EX_manA_val <= ZEROS(EX_manA_val'RANGE);

	EX_sB_val <= '0';
	EX_expB_val <= ZEROS(EX_expB_val'RANGE);
	EX_manB_val <= ZEROS(EX_manB_val'RANGE);

	EX_enable_val <= '0';

	-- error signals
	sAerr <= '0';
	expAerr <= '0';
	manAerr <= '0';

	sBerr <= '0';
	expBerr <= '0';
	manBerr <= '0';

	ENerr <= '0';
	
	--- read values from text file
 	WHILE (NOT ENDFILE(test_data)) LOOP
	
    	readline(test_data,cur_line);
    	read(cur_line,aid); 	read(cur_line,a_test_val); --read A value
    	read(cur_line,bid); 	read(cur_line,b_test_val); --read B value
    	read(cur_line,ASMid); 	read(cur_line,ASM_val);  --read Add/Sub/Mult (2 bits)
    	readline(test_data,cur_line);
    	
    	read(cur_line,sAid); 	read(cur_line,sA_val);    --read expected sign of A result
    	read(cur_line,expAid); 	read(cur_line,expA_val);--read expected exponent A result
    	read(cur_line,manAid); 	read(cur_line,manA_val);--read expected mantissa A result
    	readline(test_data,cur_line);
	
    	read(cur_line,sBid); 	read(cur_line,sB_val);    --read expected sign of B result
    	read(cur_line,expBid); 	read(cur_line,expB_val);--read expected exponent B result
    	read(cur_line,manBid); 	read(cur_line,manB_val);--read expected mantissa B result
    	readline(test_data,cur_line);
	
    	read(cur_line,ENid); 	read(cur_line,enable_val);--read expected EN result

	-- Output signals

	aid_sig <= "======", aid after 20 ns; 
	bid_sig <= "======", bid after 20 ns; 

	aval <= a_test_val after 20 ns;
	bval <= b_test_val after 20 ns;

	ASMval <= ASM_val after 20 ns;

	EX_sA_val <= sA_val after 20 ns;
	EX_expA_val <= expA_val after 20 ns;
	EX_manA_val <= manA_val after 20 ns;

	EX_sB_val <= sB_val after 20 ns;
	EX_expB_val <= expB_val after 20 ns;
	EX_manB_val <= manB_val after 20 ns;

	EX_enable_val <= enable_val after 20 ns;

	wait for 30 ns;
	
	   --check results with expected from file
    IF(EX_sA_val /= s_A) THEN sAerr <= '1', '0' AFTER 10 ns; END IF;
    IF(EX_expA_val /= exp_A) THEN expAerr <= '1', '0' AFTER 10 ns; END IF;
    IF(EX_manA_val /= man_A) THEN manAerr <= '1', '0' AFTER 10 ns; END IF;

    IF(EX_sB_val /= s_B) THEN sBerr <= '1', '0' AFTER 10 ns; END IF;
    IF(EX_expB_val /= exp_B) THEN expBerr <= '1', '0' AFTER 10 ns; END IF;
    IF(EX_manB_val /= man_B) THEN manBerr <= '1', '0' AFTER 10 ns; END IF;

    IF(EX_enable_val /= ENABLE) THEN ENerr <= '1', '0' AFTER 10 ns; END IF;

	wait for 40 ns;
	END LOOP;

	wait for 100 ns;
	wait;
END prepare_vect;
END fpuPrepareStage_test 
	


-------------------------------------------------------------------------------
--  Test Bench Entity for the Prepare stage
-------------------------------------------------------------------------------
ENTITY prep_tb is
END prep_tb;

-------------------------------------------------------------------------------
--  Test Bench Architecture for the Prepare stage
-------------------------------------------------------------------------------

LIBRARY  IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE STD.TEXTIO.all;
USE work.prepare_test.all;

ARCHITECTURE my_test of prep_tb is


-- Place your component declaration and configuration here
	COMPONENT fpuPrepareStage 
  		PORT( 	Ain,Bin 			: IN std_logic_vector;
       			add_sub_mult 			: IN std_logic_vector;
        		sA, sB, EN			: OUT std_logic;
        		expA, expB, manA, manB   	: OUT std_logic_vector);
	END COMPONENT;

	FOR ALL : fpuPrepareStage USE ENTITY WORK.fpuPrepareStage(prepare_vectors);

  SIGNAL 	A,B 			: std_logic_vector (31 downto 0);
  SIGNAL 	AddSubMult 		: std_logic_vector(1 downto 0);
  SIGNAL 	s_A, s_B, ENABLE 	: std_logic;
  SIGNAL 	exp_A, exp_B 		: std_logic_vector(7 downto 0);
  SIGNAL 	man_A, man_B 		: std_logic_vector(23 downto 0);
  SIGNAL 	aid_sig, bid_sig	: string(1 to 6) := "======";
  SIGNAL 	sAerr, sBerr, ENerr	: bit := '0';
  SIGNAL	expAerr, expBerr	: bit := '0';
  SIGNAL	manAerr, manBerr	: bit := '0';
  SIGNAL 	EX_expA_val, EX_expB_val : std_logic_vector (7 downto 0);
  SIGNAL 	EX_manA_val, EX_manB_val : std_logic_vector(23 downto 0);
  SIGNAL 	EX_sA_val, EX_sB_val, EX_enable_val : std_logic;


BEGIN -- test architecture
	
-- Instantiate your component here
	prep0:  prepare PORT MAP
	      ( A, B, 
		AddSubMult, 
		s_A, s_B, ENABLE, 
		exp_A, exp_B, man_A, man_B
		);

	prepare_vect  ( aid_sig, bid_sig, 
			A, B, 
			AddSubMult, 
			s_A, s_B, ENABLE, 
			exp_A, exp_B, 
			man_A, man_B, 
			sAerr, sBerr, ENerr, 
			expAerr, expBerr, 
			manAerr, manBerr, 
			EX_expA_val, EX_expB_val, 
			EX_manA_val, EX_manB_val,
			EX_sA_val, EX_sB_val, 
			EX_enable_val
			);

END my_test;
	

