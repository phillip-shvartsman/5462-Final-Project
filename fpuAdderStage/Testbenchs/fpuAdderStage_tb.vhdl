-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: 
-- NOTE TO READER: 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY fpuAdderStage_tb IS
END fpuAdderStage_tb;

USE WORK.fpuAdderStage_test_vect.all;
ARCHITECTURE test OF fpuAdderStage_tb IS
  COMPONENT fpuAdderStage IS
    PORT  ( signA,signB : IN  std_logic;
            expA,expB   : IN  std_logic_vector(7 downto 0);
            manA,manB   : IN  std_logic_vector(23 downto 0);
            ASM         : IN  std_logic_vector(1 downto 0);
            En_in       : IN  std_logic;
            signZ       : OUT std_logic;
            expZ        : OUT std_logic_vector(7 downto 0);
            manZ        : OUT std_logic_vector(47 downto 0);
            Ahigh,Bhigh : OUT std_logic;
            En_out      : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : fpuAdderStage USE ENTITY  WORK.fpuAdderStage(dataflow);
  
  SIGNAL  signA,signB : std_logic := '0';
  SIGNAL  expA,expB   : std_logic_vector(7 downto 0)  := (others => '0');
  SIGNAL  manA,manB   : std_logic_vector(23 downto 0) := (others => '0');
  SIGNAL  ASM         : std_logic_vector(1 downto 0) := (others => '0');
  SIGNAL  En_in       : std_logic := '0';
  SIGNAL  signZ       : std_logic;
  SIGNAL  expZ        : std_logic_vector(7 downto 0);
  SIGNAL  manZ        : std_logic_vector(47 downto 0);
  SIGNAL  Ahigh,Bhigh : std_logic;
  SIGNAL  En_out      : std_logic;
  
  SIGNAL  expected_signZ  : std_logic;
  SIGNAL  expected_expZ   : std_logic_vector(7 downto 0);
  SIGNAL  expected_manZ   : std_logic_vector(47 downto 0);
  SIGNAL  err_sig         : std_logic;
  
BEGIN
  adderStage : fpuAdderStage PORT MAP
    ( signA, signB,
      expA, expB,
      manA, manB,
      ASM,
      En_in,
      signZ,
      expZ,
      manZ,
      Ahigh,Bhigh,
      En_out
    );
  
  gen_vec ( signA, signB,
            expA, expB,
            manA, manB,
            ASM,
            En_in,
            signZ,
            expZ,
            manZ,
            expected_signZ,
            expected_expZ,
            expected_manZ,
            err_sig
          );
      
END test;