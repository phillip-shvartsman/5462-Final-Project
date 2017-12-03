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

ENTITY cmaMultiplier IS
  PORT  ( inputL,inputR   : IN  std_logic_vector(23 downto 0);
          output          : OUT std_logic_vector(47 downto 0)
        );
END cmaMultiplier;

ARCHITECTURE dataflow OF cmaMultiplier IS
  COMPONENT cma48bits IS
    PORT  ( A,B   : IN  std_logic_vector(47 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(47 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cma48bits USE ENTITY WORK.cma48bits(dataflow);
  
  TYPE matrix IS ARRAY (inputR'HIGH+1 downto 0) OF STD_LOGIC_VECTOR(inputL'LENGTH+inputR'LENGTH-1 downto 0);
  SIGNAL product  : matrix;
  SIGNAL shiftin  : matrix;
  SIGNAL interA   : matrix;
  
BEGIN
  shiftin(0) <= (inputL'HIGH downto 0 => inputL, others => '0');
  product(0) <= (others => '0');
  
  GEN_ITERS : FOR i IN inputR'REVERSE_RANGE GENERATE
    Add : cma48bits PORT MAP
      ( product(i), shiftin(i),
        '0',
        interA(i),
        open
      );
      
    shiftin(i+1) <= shiftin(i)(inputL'LENGTH+inputR'LENGTH-2 downto 0) & '0';
    
    product(i+1) <= interA(i) when (inputR(i) = '1') else
                    product(i);
  END GENERATE GEN_ITERS;
  
  output <= product(inputR'HIGH+1);
END dataflow;