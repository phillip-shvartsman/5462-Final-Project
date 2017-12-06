LIBRARY  IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fpuMultiplierStage IS
  PORT(  S_A, S_B      : IN  STD_LOGIC;
	       EXP_A, EXP_B  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
	       MAN_A, MAN_B  : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
	       EN            : IN  STD_LOGIC;
	       oper          : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
	       S_Z           : OUT STD_LOGIC;
	       EXP_Z         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	       MAN_Z         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
 	       MSB_A, MSB_B  : OUT STD_LOGIC
 	    ); 
END fpuMultiplierStage;

ARCHITECTURE design OF fpuMultiplierStage IS
	-- 8-BIT ADDER COMPONENT
	COMPONENT rippleadder
		  PORT  ( A,B   : IN  std_logic_vector (7 downto 0);
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector (7 downto 0);
          cout  : OUT std_logic
        );
	END COMPONENT;

	
	--Booth multiplier component
	COMPONENT cmaMultiplier
	  PORT( inputL,inputR   : IN  std_logic_vector(23 downto 0);
          output          : OUT std_logic_vector(47 downto 0));
	 
	END COMPONENT;

	-- COMPONENT CONFIGURATIONS
	FOR ALL: rippleadder USE ENTITY WORK.rippleadder(dataflow);
	FOR ALL: cmaMultiplier USE ENTITY WORK.cmaMultiplier(dataflow);
	
	-- Internal Signals
	SIGNAL C_OUT : STD_LOGIC := '0';
	SIGNAL expAtemp : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL expZtemp : STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL manZtemp : STD_LOGIC_VECTOR (47 downto 0);
	
BEGIN
-- Handle sign bit
		S_Z <= S_A when EN='0' else
			   (S_A XOR S_B) when (oper(1)='1') else
			   'Z';
		
-- Handle A'High and B'High
		MSB_A <= EXP_A(7); 
		MSB_B <= EXP_B(7);


	  -- Handle exponent 
	  expAtemp <= (not EXP_A(7)) & EXP_A(6 downto 0);
	  ADD_EXP: rippleadder PORT MAP(expAtemp, EXP_B, '1', expZtemp, C_OUT);
		EXP_Z <= EXP_A when EN='0' else
		          expZtemp when oper(1)='1' else
		          (others => 'Z');
	 

	  -- MAN_Z:
	  ADD_MAN: cmaMultiplier PORT MAP(MAN_A, MAN_B, manZtemp);
		MAN_Z<= MAN_A&"000000000000000000000000" when EN='0' else
		        manZtemp when oper(1)='1' else
		        (others => 'Z');
	
	
END design;