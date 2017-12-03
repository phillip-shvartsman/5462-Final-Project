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

ENTITY cmaCarry_unit IS
  PORT  ( cin,B   : IN  std_logic;
          AxorB   : IN  std_logic;
          cout    : OUT std_logic
        );
END cmaCarry_unit;

ARCHITECTURE dataflow OF cmaCarry_unit IS
  COMPONENT mux21 IS
    PORT  ( input     : IN  std_logic_vector(1 downto 0);
            selector  : IN  std_logic;
            output    : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : mux21 USE ENTITY WORK.mux21(dataflow);
  
BEGIN
  mux : mux21 PORT MAP
    (cin & B, AxorB, cout);
    
END dataflow;