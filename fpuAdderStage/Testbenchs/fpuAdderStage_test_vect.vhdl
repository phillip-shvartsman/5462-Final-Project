library ieee;
use ieee.std_logic_1164.all;
use STD.TEXTIO.all;

PACKAGE fpuAdderStage_test_vect IS

constant ZEROS : std_logic_vector (56 downto 0) := (others => '0');

PROCEDURE gen_vec ( SIGNAL signA,signB     : OUT std_logic;
                    SIGNAL expA,expB       : OUT std_logic_vector(7 downto 0);
                    SIGNAL manA,manB       : OUT std_logic_vector(23 downto 0);
                    SIGNAL ASM             : OUT std_logic_vector(1 downto 0);
                    SIGNAL En_in           : OUT std_logic;
                    SIGNAL signZ           : IN  std_logic;
                    SIGNAL expZ            : IN  std_logic_vector(7 downto 0);
                    SIGNAL manZ            : IN  std_logic_vector(47 downto 0);
                    SIGNAL expected_signZ  : OUT std_logic;
                    SIGNAL expected_expZ   : OUT std_logic_vector(7 downto 0);
                    SIGNAL expected_manZ   : OUT std_logic_vector(47 downto 0);
                    SIGNAL err_sig         : OUT std_logic
                  );

end fpuAdderStage_test_vect;

PACKAGE BODY fpuAdderStage_test_vect IS

  PROCEDURE gen_vec ( SIGNAL signA,signB     : OUT std_logic;
                      SIGNAL expA,expB       : OUT std_logic_vector(7 downto 0);
                      SIGNAL manA,manB       : OUT std_logic_vector(23 downto 0);
                      SIGNAL ASM             : OUT std_logic_vector(1 downto 0);
                      SIGNAL En_in           : OUT std_logic;
                      SIGNAL signZ           : IN  std_logic;
                      SIGNAL expZ            : IN  std_logic_vector(7 downto 0);
                      SIGNAL manZ            : IN  std_logic_vector(47 downto 0);
                      SIGNAL expected_signZ  : OUT std_logic;
                      SIGNAL expected_expZ   : OUT std_logic_vector(7 downto 0);
                      SIGNAL expected_manZ   : OUT std_logic_vector(47 downto 0);
                      SIGNAL err_sig         : OUT std_logic
                    ) IS
  
    variable cur_line : LINE;
    file test_data: TEXT OPEN read_mode IS "./fpuAdderStage/Testbenchs/fpuAdderStageVectors";

    variable a_test_val, b_test_val : std_logic_vector(32 downto 0);
    variable result_val             : std_logic_vector(56 downto 0);
    variable ASM_val                : std_logic_vector(1 downto 0);
    
    variable vecZ                   : std_logic_vector(56 downto 0);
    variable Entemp                 : std_logic_vector(0 downto 0);
    
  BEGIN
    signA <= '0';
    signB <= '0';
    
    expA <= ZEROS(expA'RANGE);
    expB <= ZEROS(expB'RANGE);
    
    manA <= ZEROS(manA'RANGE);
    manB <= ZEROS(manB'RANGE);
    
    expected_signZ  <= '0';
    expected_expZ   <= ZEROS(expZ'RANGE);
    expected_manZ   <= ZEROS(manZ'RANGE);
    
    err_sig <= '0';
    
    WHILE (NOT ENDFILE(test_data)) LOOP
      --get next input test vector and expected result
      readline(test_data,cur_line);
      read(cur_line,a_test_val); read(cur_line, ASM_val); read(cur_line,Entemp);
      readline(test_data,cur_line);
      read(cur_line,b_test_val);
      readline(test_data,cur_line);
      read(cur_line,result_val);
      
      --Output Signals
      signA <= a_test_val(32) after 20 ns;
      signB <= b_test_val(32) after 20 ns;
      
      expA <= a_test_val(31 downto 24) after 20 ns;
      expB <= b_test_val(31 downto 24) after 20 ns;
      
      manA <= a_test_val(23 downto 0) after 20 ns;
      manB <= b_test_val(23 downto 0) after 20 ns;
      
      ASM <= ASM_val after 20 ns;
      En_in <= Entemp(0) after 20 ns;
      
      --Output Expected
      expected_signZ  <= result_val(56) after 20 ns;
      expected_expZ   <= result_val(55 downto 48) after 20 ns;
      expected_manZ   <= result_val(47 downto 0) after 20 ns;
      
      wait for 30 ns;
      --Input Result
      vecZ := signZ & expZ & manZ;
      
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

END fpuAdderStage_test_vect;


