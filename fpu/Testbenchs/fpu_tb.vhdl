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

ENTITY fpu_tb IS
END fpu_tb;

USE WORK.fpu_test_vect.all;
ARCHITECTURE test OF fpu_tb IS
  COMPONENT fpu IS
    PORT( A,B : IN  std_logic_vector(31 downto 0);
          ASM : IN  std_logic_vector(1 downto 0);
          Z   : OUT std_logic_vector(31 downto 0)
        );
  END COMPONENT;
  
  FOR ALL : fpu USE ENTITY WORK.fpu(dataflow);
  
  SIGNAL  A,B         : std_logic_vector(31 downto 0);
  SIGNAL  ASM         : std_logic_vector(1 downto 0);
  SIGNAL  Z           : std_logic_vector(31 downto 0);
  
  SIGNAL  expected_Z  : std_logic_vector(31 downto 0);
  SIGNAL  err_sig     : std_logic;
  
BEGIN
  Unit : fpu PORT MAP
    ( A, B,
      ASM,
      Z
    );
  
  gen_vec ( A, B,
            ASM,
            Z,
            expected_Z,
            err_sig
          );
      
END test;