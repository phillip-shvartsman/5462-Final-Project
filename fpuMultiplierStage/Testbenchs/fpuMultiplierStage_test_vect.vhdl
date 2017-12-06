library ieee;
use ieee.std_logic_1164.all;
use STD.TEXTIO.all;

PACKAGE fpuMultiplierStage_test_vect IS

constant ZEROS : std_logic_vector (56 downto 0) := (others => '0');

PROCEDURE gen_vec ( SIGNAL S_A,S_B     : OUT std_logic;
                    SIGNAL EXP_A,EXP_B       : OUT std_logic_vector(7 downto 0);
                    SIGNAL MAN_A,MAN_B       : OUT std_logic_vector(23 downto 0);
                    SIGNAL oper             : OUT std_logic_vector(1 downto 0);
                    SIGNAL En           : OUT std_logic;
                    SIGNAL S_Z           : IN  std_logic;
                    SIGNAL EXP_Z            : IN  std_logic_vector(7 downto 0);
                    SIGNAL MAN_Z            : IN  std_logic_vector(47 downto 0);
                    SIGNAL expected_S_Z  : OUT std_logic;
                    SIGNAL expected_EXP_Z   : OUT std_logic_vector(7 downto 0);
                    SIGNAL expected_MAN_Z   : OUT std_logic_vector(47 downto 0);
                    SIGNAL err_sig         : OUT std_logic
                  );

end fpuMultiplierStage_test_vect;

PACKAGE BODY fpuMultiplierStage_test_vect IS

  PROCEDURE gen_vec ( SIGNAL S_A,S_B     : OUT std_logic;
                    SIGNAL EXP_A,EXP_B       : OUT std_logic_vector(7 downto 0);
                    SIGNAL MAN_A,MAN_B       : OUT std_logic_vector(23 downto 0);
                    SIGNAL oper             : OUT std_logic_vector(1 downto 0);
                    SIGNAL En           : OUT std_logic;
                    SIGNAL S_Z           : IN  std_logic;
                    SIGNAL EXP_Z            : IN  std_logic_vector(7 downto 0);
                    SIGNAL MAN_Z            : IN  std_logic_vector(47 downto 0);
                    SIGNAL expected_S_Z  : OUT std_logic;
                    SIGNAL expected_EXP_Z   : OUT std_logic_vector(7 downto 0);
                    SIGNAL expected_MAN_Z   : OUT std_logic_vector(47 downto 0);
                    SIGNAL err_sig         : OUT std_logic
                    ) IS
  
    variable cur_line : LINE;
    file test_data: TEXT OPEN read_mode IS "./Modelsim/Testbenchs/Multiplication_Test_Vectors";

    variable a_test_val, b_test_val : std_logic_vector(32 downto 0);
    variable result_val             : std_logic_vector(56 downto 0);
    variable oper_val                : std_logic_vector(1 downto 0);
    
    variable vecZ                   : std_logic_vector(56 downto 0);
    variable Entemp                 : std_logic_vector(0 downto 0);
    
  BEGIN
    S_A <= '0';
    S_B <= '0';
    
    EXP_A <= ZEROS(EXP_A'RANGE);
    EXP_B <= ZEROS(EXP_B'RANGE);
    
    MAN_A <= ZEROS(MAN_A'RANGE);
    MAN_B <= ZEROS(MAN_B'RANGE);
    
    expected_S_Z  <= '0';
    expected_EXP_Z   <= ZEROS(EXP_Z'RANGE);
    expected_MAN_Z   <= ZEROS(MAN_Z'RANGE);
    
    err_sig <= '0';
    
    WHILE (NOT ENDFILE(test_data)) LOOP
      --get next input test vector and expected result
      readline(test_data,cur_line);
      read(cur_line,a_test_val); read(cur_line, oper_val); read(cur_line,Entemp);
      readline(test_data,cur_line);
      read(cur_line,b_test_val);
      readline(test_data,cur_line);
      read(cur_line,result_val);
      
      --Output Signals
      S_A <= a_test_val(32) after 20 ns;
      S_B <= b_test_val(32) after 20 ns;
      
      EXP_A <= a_test_val(31 downto 24) after 20 ns;
      EXP_B <= b_test_val(31 downto 24) after 20 ns;
      
      MAN_A <= a_test_val(23 downto 0) after 20 ns;
      MAN_B <= b_test_val(23 downto 0) after 20 ns;
      
      oper <= oper_val after 20 ns;
      En <= Entemp(0) after 20 ns;
      
      --Output Expected
      expected_S_Z  <= result_val(56) after 20 ns;
      expected_EXP_Z   <= result_val(55 downto 48) after 20 ns;
      expected_MAN_Z   <= result_val(47 downto 0) after 20 ns;
      
      wait for 30 ns;
      --Input Result
      vecZ := S_Z & EXP_Z & MAN_Z;
      
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

END fpuMultiplierStage_test_vect;
