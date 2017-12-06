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

ENTITY cma64bits_tb IS
END cma64bits_tb;

USE WORK.cma64bits_test_vect.all;
ARCHITECTURE test OF cma64bits_tb IS
COMPONENT cma64bits IS
  PORT  ( A,B   : IN  std_logic_vector(63 downto 0);
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector(63 downto 0);
          cout  : OUT std_logic
        );
END COMPONENT;
  
  FOR ALL : cma64bits USE ENTITY  WORK.cma64bits(dataflow);
  
  SIGNAL A,B   : std_logic_vector(63 downto 0);
  SIGNAL cin   : std_logic;
  SIGNAL sum   : std_logic_vector(63 downto 0);
  SIGNAL cout  : std_logic;
  
  SIGNAL  expectedSum   : std_logic_vector(63 downto 0);
  SIGNAL  expectedCout  : std_logic;
  SIGNAL  err_sig       : std_logic;
  
BEGIN
  add : cma64bits PORT MAP
    ( A,B,
      cin,
      sum,
      cout
    );
  
  gen_vec ( A,B,
            cin,
            sum,
            cout,
            expectedSum,
            expectedCout,
            err_sig
          );
      
END test;
