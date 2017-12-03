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

ENTITY comparator25bit IS
  PORT  ( left,right  : IN  std_logic_vector(24 downto 0);
          lmr,rml     : OUT std_logic_vector(24 downto 0);
          gt,eq,lt    : OUT std_logic
        );
END comparator25bit;

ARCHITECTURE dataflow OF comparator25bit IS
  COMPONENT cma25bits IS
    PORT  ( A,B   : IN  std_logic_vector(24 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(24 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma25bits USE ENTITY WORK.cma25bits(dataflow);
  
  SIGNAL lmrc,rmlc  : std_logic;
  
BEGIN
  lmrcomp : cma25bits PORT MAP
    ( left, not right,
      '1',
      lmr,
      lmrc
    );
    
  rmlcomp : cma25bits PORT MAP
    ( right, not left,
      '1',
      rml,
      rmlc
    );
    
  gt  <=  lmrc and (not rmlc);
  eq  <=  lmrc and rmlc;
  lt  <=  (not lmrc) and rmlc;
END dataflow;