-------------------------------------------------------------------------------
--  Test Bench Entity for the Renormalization
-------------------------------------------------------------------------------
entity renormalizer_tb is
end renormalizer_tb;

-------------------------------------------------------------------------------
--  Architecture for the Renormalization Test Bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.all;
USE work.renorm_test_vect.all;	
	
architecture behavioral of renormalizer_tb is
begin
  signal
  
  signal A,B,C : std_logic_vector (31 downto 0);
  signal exp_res : std_logic_vector (31 downto 0);
  signal latch,drive : std_ulogic := '0';
  signal aid_sig, bid_sig, resid_sig : string(1 to 6) := "======";
  signal err_sig : bit;
  signal score : integer := 0;

component renormalizer
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
FOR ALL : renormalizer_tb use ENTITY work.renormalizer_tb(behavioral);
	
BEGIN -- test architecture
	
renorm0:  fpm PORT MAP(enIn,signIn,expIn,manIn,AH,BH,C);
	
gen_vec(aid_sig,bid_sig,resid_sig,A,B,exp_res,C,latch,drive,err_sig,score);

nm<= mname'VAL(0);
	
END behavioral;

-------------------------------------------------------------------------------
--  How the Package Test_Vect works
-------------------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.all;
package renorm_test_vect is

constant HIGHZ : std_logic_vector (31 downto 0)
           := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

procedure gen_vec (SIGNAL aid_sig,bid_sig,resid_sig : OUT string (1 to 6);
               SIGNAL aval,bval,exp_res : OUT std_logic_vector (31 downto 0);
               SIGNAL C : IN std_logic_vector (31 downto 0);
               SIGNAL latch,drive : OUT std_ulogic;
               SIGNAL err_sig : OUT bit;
               SIGNAL score : OUT integer);

end renorm_test_vect;

package body renorm_test_vect is

procedure gen_vec (SIGNAL iid_sig,resid_sig : OUT string (1 to 6);
               SIGNAL ival : std_logic_vector (59 downto 0);
	       SIGNAL exp_res : std_logic_vector (31 downto 0);
               SIGNAL C : IN std_logic_vector (31 downto 0);
               SIGNAL err_sig : OUT bit;
               SIGNAL score : OUT integer) is
variable cur_line : LINE;
file test_data: TEXT OPEN read_mode IS "renormalizer_testvect";
variable in_test_val : bit_vector (59 downto 0);
variable result_val : bit_vector (31 downto 0);
variable std_result_val : std_logic_vector (31 downto 0);
variable aid,bid,resid : string (1 to 6);
variable num_tests,num_errors : integer := 0;
Begin
  aval <= HIGHZ; bval <= HIGHZ; exp_res <= HIGHZ;
  WHILE (NOT ENDFILE(test_data)) LOOP
    --get next input test vector and expected result
    readline(test_data,cur_line);
    read(cur_line,iid); read(cur_line,in_test_val);
    readline(test_data,cur_line);
    read(cur_line,resid);read(cur_line,result_val);
    std_result_val := To_StdLogicVector(result_val);
    num_tests := num_tests + 1;
    -- run through bus cycle to send data to unit
    iid_sig <= "======", aiid after 20 ns; 
    resid_sig <= "======", resid after 20 ns;
    -- drive signals on bus
    ival <= To_StdLogicVector(in_test_val) after 20 ns, HIGHZ after 80 ns;
    wait for 100 ns;
    exp_res <= std_result_val after 20 ns, HIGHZ after 80 ns;
    wait for 50 ns;
    ASSERT (C = std_result_val)
       REPORT "result does not agree with expected result"
       SEVERITY WARNING;
    IF (C /= std_result_val) THEN
       num_errors := num_errors + 1; 
       err_sig <= '1', '0' after 10 ns;
    END IF;
    wait for 50 ns;
  END LOOP;
  score <= ((num_tests - num_errors)* 100)/num_tests;
  wait for 100 ns;
  wait;
END gen_vec;
end renorm_test_vect;	
	
