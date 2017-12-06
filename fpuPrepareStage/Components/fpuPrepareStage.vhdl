library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY fpuPrepareStage IS
  PORT( Ain,Bin 			: IN std_logic_vector;
        add_sub_mult 			: IN std_logic_vector;
        sA, sB, EN			: OUT std_logic;
        expA, expB, manA, manB   	: OUT std_logic_vector);
END fpuPrepareStage; 



ARCHITECTURE prepare_vectors OF fpuPrepareStage IS

    SIGNAL sA_in, sB_in, sR_in		: std_logic;
    SIGNAL expA_in, expB_in, expR_in  	: std_logic_vector(7 downto 0);
    SIGNAL fracA_in, fracB_in		: std_logic_vector(22 downto 0); 
    SIGNAL add_sZ, mult_sZ		: std_logic_vector(1 downto 0); --last bit is enable flag
    SIGNAL add_expZ, mult_expZ 		: std_logic_vector(8 downto 0); --last bit is enable flag
    SIGNAL add_fracZ, mult_fracZ	: std_logic_vector(23 downto 0); --last bit is enable flag
     
  BEGIN

	-- If add_sub_mult = 00 then ADD, if add_sub_mult = 01 then SUBTRACT, if add_sub_mult = 10 then MULTIPLY


    sA_in <= Ain(31); expA_in <= Ain(30 downto 23); fracA_in <= Ain(22 downto 0);
    sB_in <= Bin(31); expB_in <= Bin(30 downto 23); fracB_in <= Bin(22 downto 0);

    sB <= Bin(31); expB <= Bin(30 downto 23);


 -- Handle Multiplication Special Cases
    mult_sZ <= "00"			when 	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
     						(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
       						((expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"00" AND fracB_in = x"00000"&"000")) OR
       						((expA_in = x"00" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) else


	sA_in&'1';

    mult_expZ <= x"FF"&'0'   		when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
   			   			((expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"00" AND fracB_in = x"00000"&"000")) 	OR
       			   			((expA_in = x"00" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) 	OR	
						((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))	else

       (others => '0')    		when 	((expA_in = x"00" AND fracA_in = x"00000"&"000") OR (expB_in = x"00" AND fracB_in = x"00000"&"000"))	else
	
	expA_in&'1';


    mult_fracZ <= x"00000"&"0010"   	when	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
      						(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
    						((expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"00" AND fracB_in = x"00000"&"000")) 	OR
       						((expA_in = x"00" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000"))	else

        (others => '0')       		when    ((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))   	OR 
 						((expA_in = x"00" AND fracA_in = x"00000"&"000") OR (expB_in = x"00" AND fracB_in = x"00000"&"000"))	else
	
	fracA_in&'1';


    -- Handle Addition Special Cases
    add_sZ <= "00"  			when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
   			   			((sA_in /= sB_in) AND (expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) 	else

        sA_in&'0'	   		when 	((sA_in = sB_in) AND (expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) OR
						(expA_in = x"FF" AND fracA_in = x"00000"&"000") OR
						(expB_in = x"00" AND fracB_in = x"00000"&"000") else

	sB_in&'0'			when 	(expB_in = x"FF" AND fracB_in = x"00000"&"000") OR
						(expA_in = x"00" AND fracA_in = x"00000"&"000") else

	sA_in&'1';


    add_expZ <= x"FF"&'0'   		when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
						((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))  else

	expA_in&'0'		    	when 	(expB_in = x"00" AND fracB_in = x"00000"&"000") else
	
	expB_in&'0'			when	(expA_in = x"00" AND fracA_in = x"00000"&"000") else
	
	expA_in&'1';


    add_fracZ <= x"00000"&"0010"   	when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
   			   			((sA_in /= sB_in) AND (expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) 	else

        (others => '0')       		when    ((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))   	else 

        fracA_in&'0'		   	when 	(expB_in = x"00" AND fracB_in = x"00000"&"000")  else

	fracB_in&'0'			when 	(expA_in = x"00" AND fracA_in = x"00000"&"000")  else 

	fracA_in&'1';
    


   -- Checks enable flag to see if it has been toggled
   en <= '0'			when (add_sub_mult(1) = '0' AND (mult_sZ(0) = '0' OR mult_expZ(0) = '0' OR mult_fracZ(0) = '0')) else

	'0'			when (add_sub_mult(0) = '0' AND (add_sZ(0) = '0' OR add_expZ(0) = '0' OR add_fracZ(0) = '0'))	else

	'1';


    -- Handle Output for Add or Multiply 
   sA <= mult_sZ(1)				when (add_sub_mult(1) = '1') else

	add_sZ(1);
	
   expA <= mult_expZ(8 downto 1)		when (add_sub_mult(1) = '1') else
	
	add_expZ(8 downto 1);

   manA <= '0'&add_fracZ(23 downto 1)		when (add_sub_mult(1) = '0' AND en = '0') 	else

	'0'&mult_fracZ(23 downto 1)		when (add_sub_mult(1) = '1' AND en = '0')	else

	'0'&add_fracZ(23 downto 1)		when (add_sub_mult(1) = '0' AND expA_in = x"00") else

	'1'&add_fracZ(23 downto 1)		when (add_sub_mult(1) = '0' AND expA_in /= x"00") else

	'0'&mult_fracZ(23 downto 1)		when (add_sub_mult(1) = '1' AND expA_in = x"00") else
	
	'1'&mult_fracZ(23 downto 1)		when (add_sub_mult(1) = '1' AND expA_in /= x"00");

   manB <= '0'&fracB_in		when(en = '0') else

	'0'&fracB_in		when (expB_in = x"00") else
	
	'1'&fracB_in		when (expB_in /= x"00");


END prepare_vectors;