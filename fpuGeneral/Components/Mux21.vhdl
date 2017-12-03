-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: This is the code for both the 2-to-1 and 4-to-1 multiplexers
-- NOTE TO READER: 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY mux21 IS
  PORT  ( input     : IN std_logic_vector(1 downto 0);
          selector  : IN std_logic;
          output    : OUT std_logic
        );
END mux21;

ARCHITECTURE dataflow of mux21 IS
BEGIN
  WITH selector select output <=
    input(0) when '0',
    input(1) when '1',
    'Z'      when others;
    
END dataflow;