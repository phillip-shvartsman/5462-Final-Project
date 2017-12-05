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

ENTITY fpu IS
  PORT( A,B : IN  std_logic_vector(31 downto 0);
        ASM : IN  std_logic_vector(1 downto 0);
        Z   : OUT std_logic_vector(31 downto 0)
      );
END fpu;

ARCHITECTURE dataflow OF fpu IS
  COMPONENT fpuPrepareStage IS
    PORT( Ain,Bin       : IN std_logic_vector(31 downto 0);
          add_sub_mult  : IN std_logic_vector(1 downto 0);
          sA, sB, EN    : OUT std_logic;
          expA, expB    : OUT std_logic_vector(7 downto 0);
  	       manA, manB    : OUT std_logic_vector(23 downto 0)
  	     );
  END COMPONENT;

  COMPONENT fpuAdderStage IS
    PORT( signA,signB : IN  std_logic;
          expA,expB   : IN  std_logic_vector(7 downto 0);
          manA,manB   : IN  std_logic_vector(23 downto 0);
          ASM         : IN  std_logic_vector(1 downto 0);
          En_in       : IN  std_logic;
          signZ       : OUT std_logic;
          expZ        : OUT std_logic_vector(7 downto 0);
          manZ        : OUT std_logic_vector(47 downto 0);
          Ahigh,Bhigh : OUT std_logic
        );
  END COMPONENT;
  
  COMPONENT fpuMultiplierStage IS
 	  PORT( S_A, S_B      : IN  STD_LOGIC;
	        EXP_A, EXP_B  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
  	       MAN_A, MAN_B  : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
  	       EN            : IN  STD_LOGIC;
  	       oper          : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
  	       S_Z           : OUT STD_LOGIC;
  	       EXP_Z         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  	       MAN_Z         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
   	      MSB_A, MSB_B  : OUT STD_LOGIC
   	    ); 
  END COMPONENT;
  
  COMPONENT renormalizer IS
    PORT( enableIn    : IN  std_logic;
  		      signIn      : IN  std_logic;
  		      exponentIn  : IN  std_logic_vector(7 downto 0);
  		      mantissaIn  : IN  std_logic_vector(47 downto 0);
  		      aHigh       : IN  std_logic;
  		      bHigh       : IN  std_logic;
  		      zOut        : OUT std_logic_vector(31 downto 0)
  	     );
  END COMPONENT;
  
  FOR ALL : fpuPrepareStage     USE ENTITY WORK.fpuPrepareStage(prep_AB);
  FOR ALL : fpuAdderStage       USE ENTITY WORK.fpuAdderStage(dataflow);
  FOR ALL : fpuMultiplierStage  USE ENTITY WORK.fpuMultiplierStage(design);
  FOR ALL : renormalizer        USE ENTITY WORK.renormalizer(behave);
  
  SIGNAL signA,signB,signZ    : std_logic;
  SIGNAL expA,expB,expZ       : std_logic_vector(7 downto 0);
  SIGNAL manA,manB            : std_logic_vector(23 downto 0);
  SIGNAL manZ                 : std_logic_vector(47 downto 0);
  
  SIGNAL En_in                : std_logic;
  SIGNAL Ahigh,Bhigh          : std_logic;
  
BEGIN
  prepare : fpuPrepareStage PORT MAP
    ( A, B,
      ASM,
      signA, signB, En_in,
      expA, expB,
      manA, manB
    );
    
  Add : fpuAdderStage PORT MAP
    ( signA, signB,
      expA, expB,
      manA, manB,
      ASM,
      En_in,
      signZ,
      expZ,
      manZ,
      Ahigh, Bhigh
    );
  
  Multiply : fpuMultiplierStage PORT MAP
    ( signA, signB,
      expA, expB,
      manA, manB,
      En_in,
      ASM,
      signZ,
      expZ,
      manZ,
      Ahigh,Bhigh
    );
    
  Renormalize : renormalizer PORT MAP
    ( En_in,
      signZ,
      expZ,
      manZ,
      Ahigh,
      Bhigh,
      Z
    );
  
END dataflow;