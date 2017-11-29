library ieee;
use ieee.std_logic_1164.all;
use STD.TEXTIO.all;
package fpm_test_vect is

constant HIGHZ : std_logic_vector (31 downto 0)
           := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

procedure gen_vec (SIGNAL aid_sig,bid_sig,resid_sig : OUT string (1 to 6);
               SIGNAL aval,bval,exp_res : OUT std_logic_vector (31 downto 0);
               SIGNAL C : IN std_logic_vector (31 downto 0);
               SIGNAL latch,drive : OUT std_ulogic;
               SIGNAL err_sig : OUT bit;
               SIGNAL score : OUT integer);

end fpm_test_vect;

package body fpm_test_vect is

procedure gen_vec (SIGNAL aid_sig,bid_sig,resid_sig : OUT string (1 to 6);
               SIGNAL aval,bval,exp_res : OUT std_logic_vector (31 downto 0);
               SIGNAL C : IN std_logic_vector (31 downto 0);
               SIGNAL latch,drive : OUT std_ulogic;
               SIGNAL err_sig : OUT bit;
               SIGNAL score : OUT integer) is
variable cur_line : LINE;
file test_data: TEXT OPEN read_mode IS "C:\Users\user\Documents\GitHub\5462-Final-Project\Renormalize\TestBenches\RepurposePS10TB\fpmvectors";
variable a_test_val, b_test_val : bit_vector (31 downto 0);
variable result_val : bit_vector (31 downto 0);
variable std_result_val : std_logic_vector (31 downto 0);
variable aid,bid,resid : string (1 to 6);
variable num_tests,num_errors : integer := 0;
Begin
  aval <= HIGHZ; bval <= HIGHZ; exp_res <= HIGHZ;
  latch <= '1'; drive <= '1';
  WHILE (NOT ENDFILE(test_data)) LOOP
    --get next input test vector and expected result
    readline(test_data,cur_line);
    read(cur_line,aid); read(cur_line,a_test_val);
    read(cur_line,bid); read(cur_line,b_test_val);
    readline(test_data,cur_line);
    read(cur_line,resid);read(cur_line,result_val);
    std_result_val := To_StdLogicVector(result_val);
    num_tests := num_tests + 1;
    -- run through bus cycle to send data to unit
    aid_sig <= "======", aid after 20 ns; 
    bid_sig <= "======", bid after 20 ns; 
    resid_sig <= "======", resid after 20 ns;
    -- drive signals on bus
    aval <= To_StdLogicVector(a_test_val) after 20 ns, HIGHZ after 80 ns;
    bval <= To_StdLogicVector(b_test_val) after 20 ns, HIGHZ after 80 ns;
    latch <= '0' after 20 ns, '1' after 70 ns;
    wait for 100 ns;
    drive <= '0' after 20 ns, '1' after 80 ns;
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

end fpm_test_vect;

