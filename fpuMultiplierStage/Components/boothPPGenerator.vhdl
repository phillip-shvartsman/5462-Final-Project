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

ENTITY boothPPGenerator IS
  PORT  ( input           : IN  std_logic_vector;
          multiBits       : IN  std_logic_vector(2 downto 0);
          output          : OUT std_logic_vector;
          negative        : OUT std_logic
        );
END boothPPGenerator;

ARCHITECTURE dataflow OF boothPPGenerator IS
  COMPONENT boothRecoder IS
    PORT  ( multiBits        : IN  std_logic_vector(2 downto 0);
            neg,zero,shift  : OUT std_logic
          );
  END COMPONENT;

  FOR ALL : boothRecoder USE ENTITY WORK.boothRecoder(dataflow);

  SIGNAL shifted,notShifted : std_logic_vector(input'RANGE);
  SIGNAL neg,zero,shift     : std_logic;
  
  SIGNAL zeros              : std_logic_vector(input'RANGE) := (others => '0');
BEGIN
  notShifted <= input;
  shifted <= input(input'HIGH-1 downto input'LOW) & '0';

  recode : boothRecoder PORT MAP
    ( multiBits,
      neg,zero,shift
    );

  output <= zeros           WHEN (zero = '1') else
            notShifted      WHEN ((NOT neg AND NOT shift) = '1') else
            shifted         WHEN ((NOT neg AND shift) = '1') else
            NOT notShifted  WHEN ((neg AND NOT shift) = '1') else
            NOT shifted;

  negative <= neg;

END dataflow;