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

ENTITY boothRecoder IS
  PORT  ( multiBits        : IN  std_logic_vector(2 downto 0);
          neg,zero,shift  : OUT std_logic
        );
END boothRecoder;

ARCHITECTURE dataflow OF boothRecoder IS
BEGIN
  neg <= multiBits(2) AND (multiBits(1) NAND multiBits(0));

  zero <= (multiBits(2) AND multiBits(1) AND multiBits(0)) OR
          (NOT multiBits(2) AND NOT multiBits(1) AND NOT multiBits(0));

  shift <= (NOT multiBits(2) AND multiBits(1) AND multiBits(0)) OR
           (multiBits(2) AND NOT multiBits(1) AND NOT multiBits(0));
END dataflow;
