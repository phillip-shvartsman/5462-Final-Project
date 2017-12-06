library ieee;
use ieee.std_logic_1164.all;
use STD.TEXTIO.all;

PACKAGE cma64bits_test_vect IS

constant ZEROS : std_logic_vector (63 downto 0) := (others => '0');

PROCEDURE gen_vec ( SIGNAL A,B             : OUT std_logic_vector(63 downto 0);
                    SIGNAL cin             : OUT std_logic;
                    SIGNAL sum             : IN  std_logic_vector(63 downto 0);
                    SIGNAL cout            : IN  std_logic;
                    SIGNAL expectedSum     : OUT std_logic_vector(63 downto 0);
                    SIGNAL expectedCout    : OUT std_logic;
                    SIGNAL err_sig         : OUT std_logic
                  );

end cma64bits_test_vect;

PACKAGE BODY cma64bits_test_vect IS

  PROCEDURE gen_vec ( SIGNAL A,B             : OUT std_logic_vector(63 downto 0);
                    SIGNAL cin             : OUT std_logic;
                    SIGNAL sum             : IN  std_logic_vector(63 downto 0);
                    SIGNAL cout            : IN  std_logic;
                    SIGNAL expectedSum     : OUT std_logic_vector(63 downto 0);
                    SIGNAL expectedCout    : OUT std_logic;
                    SIGNAL err_sig         : OUT std_logic
                  ) IS
  
    variable cur_line : LINE;
    file test_data: TEXT OPEN read_mode IS "./fpuGeneral/Testbenchs/cma64bitsVectors";

    variable a_test_val, b_test_val : std_logic_vector(63 downto 0);
    variable cinSig                 : std_logic_vector(0 downto 0);
    variable result_val             : std_logic_vector(63 downto 0);
    variable result_cout            : std_logic;
    
    variable vecZ                 : std_logic_vector(63 downto 0);
    
  BEGIN
    A <= ZEROS(A'RANGE);
    B <= ZEROS(b'RANGE);
    cin <= '0';
    
    expectedSum <= ZEROS(sum'RANGE);
    expectedCout <= '0';
    
    err_sig <= '0';
    
    WHILE (NOT ENDFILE(test_data)) LOOP
      --get next input test vector and expected result
      readline(test_data,cur_line);
      read(cur_line,a_test_val); --read(cur_line,cinSig);
      readline(test_data,cur_line);
      read(cur_line,b_test_val);
      readline(test_data,cur_line);
      read(cur_line,result_val); --read(cur_line,result_cout);
      
      --Output Signals
      A <= a_test_val after 20 ns;
      B <= b_test_val after 20 ns;
      
      --cin <= cinSig(0);
      
      --Output Expected
      expectedSum  <= result_val after 20 ns;
      --expectedCout <= result_cout;
      
      wait for 30 ns;
      
      vecZ := sum;
      
      ASSERT (vecZ = result_val)
         REPORT "result does not agree with expected result"
         SEVERITY WARNING;
      IF (vecZ /= result_val) THEN
         err_sig <= '1', '0' after 10 ns;
      END IF;
      wait for 40 ns;
    END LOOP;
    
    wait for 100 ns;
    wait;
  END gen_vec;

END cma64bits_test_vect;



