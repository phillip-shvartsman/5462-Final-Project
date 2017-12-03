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
          output          : OUT std_logic_vector(47 downto 0)
        );
END boothMultiplier;

ARCHITECTURE dataflow OF boothMultiplier IS
  COMPONENT cma24bits IS
    PORT  ( A,B   : IN  std_logic_vector(23 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(23 downto 0);
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
  
  FOR ALL : cma24bits USE ENTITY WORK.cma24bits(dataflow);
  FOR ALL : boothPPGenerator USE ENTITY WORK.boothPPGenerator(dataflow);
  
  TYPE matrix1 IS ARRAY (inputR'LENGTH/2-1 downto 0) OF STD_LOGIC_VECTOR(inputL'LENGTH+inputR'LENGTH downto 0);
  SIGNAL product         : matrix1;

  TYPE matrix2 IS ARRAY (inputR'LENGTH/2-1 downto 0) OF STD_LOGIC_VECTOR(inputL'RANGE);
  SIGNAL shiftin         : matrix2;
  SIGNAL partialProduct  : matrix2;
  SIGNAL outputtemp      : std_logic_vector(output'RANGE);

  SIGNAL negatives       : std_logic_vector(inputR'LENGTH/2-1 downto 0);
  
  SIGNAL zeros           : std_logic_vector(inputL'RANGE) := (others => '0');

BEGIN
  product(0) <= zeros & inputR & '0';

  GEN_ITERS : FOR i IN 0 TO inputR'LENGTH/2-1 GENERATE
    PP_GEN : boothPPGenerator PORT MAP
      ( inputL,
        product(i)(2 downto 0),
        partialProduct(i),
        negatives(i)
      );

    ADDER : cma24bits PORT MAP
      ( product(i)(inputL'LENGTH+inputR'LENGTH downto inputL'LENGTH+1), partialProduct(i),
        negatives(i),
        shiftin(i),
        open
      );

    PROD : IF i < inputR'LENGTH/2-1 GENERATE
      product(i+1) <= shiftin(i)(inputL'HIGH) & shiftin(i)(inputL'HIGH) & shiftin(i) & product(i)(inputL'LENGTH downto 2);
    END GENERATE PROD;

    OUTPUT : IF i = inputR'LENGTH/2-1 GENERATE
      outputtemp <= shiftin(i)(inputL'HIGH) & shiftin(i)(inputL'HIGH) & shiftin(i) & product(i)(inputL'LENGTH downto 3);
    END GENERATE OUTPUT;
  END GENERATE GEN_ITERS;

  output <= outputtemp;
END dataflow;