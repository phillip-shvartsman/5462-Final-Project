-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: 
-- NOTE TO READER: dataflow is not a barrel shifter. It's a linear shifter, however for ease of use this was easier
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY barrelShifter IS
  PORT  ( input   : IN  std_logic_vector;
          shift   : IN  std_logic_vector;
          output  : OUT std_logic_vector
        );
END barrelShifter;

ARCHITECTURE dataflow OF barrelShifter IS
  TYPE shifterArrayType IS ARRAY(integer range <>) of std_logic_vector(input'RANGE);
  SIGNAL shifterArray : shifterArrayType(shift'HIGH+1 downto shift'LOW);
  SIGNAL zeros        : std_logic_vector((2**shift'LENGTH)-1 downto 0) := (others => '0');
  
BEGIN
  shifterArray(shift'LOW) <= input;
  
  GEN_SHIFTERS : FOR i IN shift'REVERSE_RANGE GENERATE
    WITH shift(i) SELECT shifterArray(i+1) <=
      zeros((2**(i-shift'LOW))-1 downto 0) & shifterArray(i)(input'HIGH downto input'LOW+2**(i-shift'LOW))  when '1',
      shifterArray(i)                                                                                       when '0',
      (others => 'Z')                                                                                       when others;
  END GENERATE GEN_SHIFTERS;
  
  output <= shifterArray(shift'HIGH+1);
END dataflow;