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

ENTITY boothMultiplier IS
  PORT  ( inputL,inputR   : IN  std_logic_vector(23 downto 0);
          output          : OUT std_logic_vector(51 downto 0)
        );
END boothMultiplier;

ARCHITECTURE dataflow OF boothMultiplier IS
  COMPONENT cma26bits IS
    PORT  ( A,B   : IN  std_logic_vector(25 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(25 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;

  COMPONENT boothPPGenerator IS
    PORT  ( input           : IN  std_logic_vector;
            multiBits       : IN  std_logic_vector(2 downto 0);
            output          : OUT std_logic_vector;
            negative        : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma26bits USE ENTITY WORK.cma26bits(dataflow);
  FOR ALL : boothPPGenerator USE ENTITY WORK.boothPPGenerator(dataflow);
  
  SIGNAL padInputL,padInputR : std_logic_vector(inputL'HIGH+2 downto 0);
  
  TYPE matrix1 IS ARRAY (padInputR'LENGTH/2 downto 0) OF STD_LOGIC_VECTOR(padInputL'LENGTH+padInputR'LENGTH downto 0);
  SIGNAL product         : matrix1;

  TYPE matrix2 IS ARRAY (padInputR'LENGTH/2-1 downto 0) OF STD_LOGIC_VECTOR(padInputL'RANGE);
  SIGNAL shiftin         : matrix2;
  SIGNAL partialProduct  : matrix2;
  SIGNAL outputtemp      : std_logic_vector(output'RANGE);

  SIGNAL negatives       : std_logic_vector(padInputR'LENGTH/2-1 downto 0);
  
  SIGNAL zeros           : std_logic_vector(padInputL'RANGE) := (others => '0');
  

BEGIN
  padInputL <= "00" & inputL;
  padInputR <= "00" & inputR;
  product(0) <= zeros & padInputR & '0';

  GEN_ITERS : FOR i IN negatives'REVERSE_RANGE GENERATE
    PP_GEN : boothPPGenerator PORT MAP
      ( padInputL,
        product(i)(2 downto 0),
        partialProduct(i),
        negatives(i)
      );

    ADDER : cma26bits PORT MAP
      ( product(i)(padInputL'LENGTH+padInputR'LENGTH downto padInputL'LENGTH+1), partialProduct(i),
        negatives(i),
        shiftin(i),
        open
      );

    product(i+1) <= shiftin(i)(padInputL'HIGH) & shiftin(i)(padInputL'HIGH) & shiftin(i) & product(i)(padInputL'LENGTH downto 2);

  END GENERATE GEN_ITERS;

  output <= product(padInputR'LENGTH/2)(padInputL'LENGTH+padInputR'LENGTH downto 1);
END dataflow;