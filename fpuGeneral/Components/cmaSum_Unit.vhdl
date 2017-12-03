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

ENTITY cmaSum_unit IS
  PORT  ( AxorB,AxnorB  : IN  std_logic;
          cin           : IN  std_logic;
          sum           : OUT std_logic
        );
END cmaSum_unit;

ARCHITECTURE dataflow OF cmaSum_unit IS
  COMPONENT mux21 IS
    PORT  ( input     : IN  std_logic_vector(1 downto 0);
            selector  : IN  std_logic;
            output    : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : mux21 USE ENTITY WORK.mux21(dataflow);
  
BEGIN
  mux : mux21 PORT MAP
    (AxnorB & AxorB, cin, sum);
    
END dataflow;