-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: Can be generalized if the code for the cma is generalized
-- NOTE TO READER: 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY comparator8bit IS
  PORT  ( left,right  : IN  std_logic_vector(7 downto 0);
          lmr,rml     : OUT std_logic_vector(7 downto 0);
          gt,eq,lt    : OUT std_logic
        );
END comparator8bit;

ARCHITECTURE dataflow OF comparator8bit IS
  COMPONENT cma8bits IS
    PORT  ( A,B   : IN  std_logic_vector(7 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(7 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma8bits USE ENTITY WORK.cma8bits(dataflow);
  
  SIGNAL lmrc,rmlc  : std_logic;
  
BEGIN
  lmrcomp : cma8bits PORT MAP
    ( left, not right,
      '1',
      lmr,
      lmrc
    );
    
  rmlcomp : cma8bits PORT MAP
    ( right, not left,
      '1',
      rml,
      rmlc
    );
    
  gt  <=  lmrc and (not rmlc);
  eq  <=  lmrc and rmlc;
  lt  <=  (not lmrc) and rmlc;
END dataflow;