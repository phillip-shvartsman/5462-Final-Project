-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: This is the code for the xor unit
-- NOTE TO READER: This is not strictly neccesary as xor and xnor are implemented in vhdl
--                  but we are following the design scheme of the CMA patent
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY cmaXor_unit IS
  PORT  ( A,B             : IN  std_logic;
          xorout,xnorout  : OUT std_logic
        );
END cmaXor_unit;

ARCHITECTURE dataflow OF cmaXor_unit IS
BEGIN
  xorout <= A xor B;
  xnorout <= A xnor B;
  
END dataflow;