library ieee;
use ieee.std_logic_1164.all;

ENTITY fpuMultiplierStage_tb IS
END fpuMultiplierStage_tb;

USE WORK.fpuMultiplierStage_test_vect.all;
ARCHITECTURE test OF fpuMultiplierStage_tb IS
  COMPONENT fpuMultiplierStage IS
    PORT(S_A, S_B      : IN  STD_LOGIC;
	       EXP_A, EXP_B  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
	       MAN_A, MAN_B  : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
	       EN            : IN  STD_LOGIC;
	       oper          : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
	       S_Z           : OUT STD_LOGIC;
	       EXP_Z         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	       MAN_Z         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
 	       MSB_A, MSB_B  : OUT STD_LOGIC
 	      );
  END COMPONENT;
  
  FOR ALL : fpuMultiplierStage USE ENTITY  WORK.fpuMultiplierStage(design);
  
  SIGNAL  S_A,S_B : std_logic := '0';
  SIGNAL  EXP_A,EXP_B   : std_logic_vector(7 downto 0)  := (others => '0');
  SIGNAL  MAN_A,MAN_B   : std_logic_vector(23 downto 0) := (others => '0');
  SIGNAL  oper         : std_logic_vector(1 downto 0) := (others => '0');
  SIGNAL  EN       : std_logic := '0';
  SIGNAL  S_Z       : std_logic;
  SIGNAL  EXP_Z        : std_logic_vector(7 downto 0);
  SIGNAL  MAN_Z        : std_logic_vector(47 downto 0);
  SIGNAL  MSB_A,MSB_B : std_logic;
  --SIGNAL  En_out      : std_logic;
  
  SIGNAL  expected_S_Z  : std_logic;
  SIGNAL  expected_EXP_Z   : std_logic_vector(7 downto 0);
  SIGNAL  expected_MAN_Z   : std_logic_vector(47 downto 0);
  SIGNAL  err_sig         : std_logic;
  
BEGIN
  multiplier : fpuMultiplierStage PORT MAP
    ( S_A, S_B,
      EXP_A, EXP_B,
      MAN_A, MAN_B,
      EN,
      oper,
      S_Z,
      EXP_Z,
      MAN_Z,
      MSB_A,MSB_B
    );
  
  gen_vec ( S_A, S_B,
            EXP_A, EXP_B,
            MAN_A, MAN_B,
            oper,
            EN,
            S_Z,
            EXP_Z,
            MAN_Z,
            expected_S_Z,
            expected_EXP_Z,
            expected_MAN_Z,
            err_sig
          );
      
END test;
