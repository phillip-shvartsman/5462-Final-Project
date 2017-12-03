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

ENTITY rippleadder IS
  PORT  ( A,B   : IN  std_logic_vector;
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector;
          cout  : OUT std_logic
        );
END rippleadder;

ARCHITECTURE dataflow OF rippleadder IS
  SIGNAL carry    : std_logic_vector(A'HIGH+1 downto A'LOW);
  
BEGIN
  carry(carry'LOW) <= cin;
  
  GEN_FAs : FOR i IN A'REVERSE_RANGE GENERATE
    sum(i)  <=  A(i) xor B(i) xor carry(i);
    carry(i+1)  <=  (A(i) and B(i)) or (A(i) and carry(i)) or (B(i) and carry(i));
  END GENERATE GEN_FAs;
  
  cout  <=  carry(carry'HIGH);
  
END dataflow;