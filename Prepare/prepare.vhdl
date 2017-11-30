library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY prepare IS
  PORT( Ain,Bin 			: IN std_logic_vector(31 downto 0);
        add_sub_mult 			: IN std_logic_vector(1 downto 0);
        sA, sB, EN			: OUT std_logic;
        expA, expB 			: OUT std_logic_vector(7 downto 0);
	manA, manB   			: OUT std_logic_vector(23 downto 0));
END prepare;



ARCHITECTURE prep_AB OF prepare IS

    SIGNAL add_sZ, mult_sZ, sA_in, sB_in, sR_in			: std_logic;
    SIGNAL add_expZ, mult_expZ, expA_in, expB_in, expR_in  	: std_logic_vector(7 downto 0);
    SIGNAL add_fracZ, mult_fracZ, fracA_in, fracB_in, fracR_in	: std_logic_vector(22 downto 0); 
     
  BEGIN

	-- If add_sub_mult = 00 then ADD, if add_sub_mult = 01 then SUBTRACT, if add_sub_mult = 10 then MULTIPLY


    sA_in <= Ain(31); expA_in <= Ain(30 downto 23); fracA_in <= Ain(22 downto 0);
    sB_in <= Bin(31); expB_in <= Bin(30 downto 23); fracB_in <= Bin(22 downto 0);

    sB <= Bin(31); expB <= Bin(30 downto 23);


 -- Handle Multiplication Special Cases
    mult_sZ <= '0'			when 	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
     						(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
       						((expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"00" AND fracB_in = x"00000"&"000")) OR
       						((expA_in = x"00" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) else


	sA_in XOR sB_in;

    mult_expZ <= x"FF"   		when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
   			   			((expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"00" AND fracB_in = x"00000"&"000")) 	OR
       			   			((expA_in = x"00" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) 	OR	
						((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))	else

       (others => '0')    		when 	((expA_in = x"00" AND fracA_in = x"00000"&"000") OR (expB_in = x"00" AND fracB_in = x"00000"&"000"))	else
	
	expA_in;


    mult_fracZ <= x"00000"&"001"   	when	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
      						(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
    						((expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"00" AND fracB_in = x"00000"&"000")) 	OR
       						((expA_in = x"00" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000"))	else

        (others => '0')       		when    ((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))   	OR 
 						((expA_in = x"00" AND fracA_in = x"00000"&"000") OR (expB_in = x"00" AND fracB_in = x"00000"&"000"))	else
	
	fracA_in;


    -- Handle Addition Special Cases
    add_expZ <= x"FF"   		when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
						((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))  else

	expA_in		    		when 	(expB_in = x"00" AND fracB_in = x"00000"&"000") else
	
	expB_in				when	(expA_in = x"00" AND fracA_in = x"00000"&"000") else
	
	expA_in;


    add_fracZ <= x"00000"&"001"   	when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
   			   			((sA_in /= sB_in) AND (expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) 	else

        (others => '0')       		when    ((expA_in = x"FF" AND fracA_in = x"00000"&"000") OR (expB_in = x"FF" AND fracB_in = x"00000"&"000"))   	else 

        fracA_in		   	when 	(expB_in = x"00" AND fracB_in = x"00000"&"000")  else

	fracB_in			when 	(expA_in = x"00" AND fracA_in = x"00000"&"000")  else 

	fracA_in;

    add_sZ <= '1'  			when   	(expA_in = x"FF" AND fracA_in /= x"00000"&"000") OR 
       			   			(expB_in = x"FF" AND fracB_in /= x"00000"&"000") OR
   			   			((sA_in /= sB_in) AND (expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) 	else

        '0'      			when    ((sA_in = sB_in) AND (expA_in = x"FF" AND fracA_in = x"00000"&"000") AND (expB_in = x"FF" AND fracB_in = x"00000"&"000")) 	else

        sA_in		   		when 	(expA_in = x"FF" AND fracA_in = x"00000"&"000") OR
						(expB_in = x"00" AND fracB_in = x"00000"&"000") else

	sB_in				when 	(expB_in = x"FF" AND fracB_in = x"00000"&"000") OR
						(expA_in = x"00" AND fracA_in = x"00000"&"000") else

	sA_in;


    
    -- Handle Output for Add or Multiply 
   sA <= mult_sZ		when (add_sub_mult = "10") else

	add_sZ;
	
   expA <= mult_expZ		when (add_sub_mult = "10") else
	
	add_expZ;

   manA <= '0'&add_fracZ	when (add_sub_mult = "00" AND expA_in = x"00") 	else
		
	'1'&add_fracZ		when (add_sub_mult = "00" AND expA_in /= x"00") else

	'0'&add_fracZ		when (add_sub_mult = "01" AND expA_in = x"00") 	else

	'1'&add_fracZ		when (add_sub_mult = "01" AND expA_in /= x"00") else

	'0'&mult_fracZ		when (add_sub_mult = "10" AND expA_in = x"00") 	else
	
	'1'&mult_fracZ		when (add_sub_mult = "10" AND expA_in /= x"00"); 

   manB <= '0'&fracB_in		when (expB_in = x"00") else
	
	'1'&fracB_in;


   -- Enable bit if A and B are not special cases
   en <= '1'			when (sA_in&expA_in&fracA_in = Ain) else

	'0';

END prep_AB;
