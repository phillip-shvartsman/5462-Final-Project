library ieee;
use ieee.std_logic_1164.all;
use STD.TEXTIO.all;

PACKAGE fpu_test_vect IS

constant ZEROS : std_logic_vector (56 downto 0) := (others => '0');

PROCEDURE gen_vec ( SIGNAL A,B          : OUT  std_logic_vector(31 downto 0);
                    SIGNAL ASM          : OUT  std_logic_vector(1 downto 0);
                    SIGNAL Z            : IN   std_logic_vector(31 downto 0);
                    SIGNAL expected_Z   : OUT std_logic_vector(31 downto 0);
                    SIGNAL err_sig      : OUT std_logic
                  );

end fpu_test_vect;

PACKAGE BODY fpu_test_vect IS

  PROCEDURE gen_vec ( SIGNAL A,B          : OUT  std_logic_vector(31 downto 0);
                      SIGNAL ASM          : OUT  std_logic_vector(1 downto 0);
                      SIGNAL Z            : IN   std_logic_vector(31 downto 0);
                      SIGNAL expected_Z   : OUT std_logic_vector(31 downto 0);
                      SIGNAL err_sig      : OUT std_logic
                    ) IS
  
    variable cur_line : LINE;
    file test_data: TEXT OPEN read_mode IS "./fpu/Testbenchs/fpuVectors";

    variable a_test_val, b_test_val : std_logic_vector(31 downto 0);
    variable result_val             : std_logic_vector(31 downto 0);
    variable ASM_val                : std_logic_vector(1 downto 0);
    
    variable vecZ                   : std_logic_vector(31 downto 0);
    
  BEGIN
    A <= zeros(A'RANGE);
    B <= zeros(B'RANGE);
    ASM <= zeros(ASM'RANGE);
    
    err_sig <= '0';
    
    WHILE (NOT ENDFILE(test_data)) LOOP
      --get next input test vector and expected result
      readline(test_data,cur_line);
      read(cur_line,a_test_val); read(cur_line, ASM_val);
      readline(test_data,cur_line);
      read(cur_line,b_test_val);
      readline(test_data,cur_line);
      read(cur_line,result_val);
      
      --Output Signals
      A <= a_test_val after 20 ns;
      B <= b_test_val after 20 ns;
      
      
      ASM <= ASM_val after 20 ns;
      
      --Output Expected
      expected_Z  <= result_val after 20 ns;
      
      wait for 30 ns;
      --Input Result
      vecZ := Z;
      
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

END fpu_test_vect;



