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

ENTITY fpuAdderStage IS
  PORT  ( signA,signB : IN  std_logic;
          expA,expB   : IN  std_logic_vector(7 downto 0);
          manA,manB   : IN  std_logic_vector(23 downto 0);
          ASM         : IN  std_logic_vector(1 downto 0);
          En_in       : IN  std_logic;
          signZ       : OUT std_logic;
          expZ        : OUT std_logic_vector(7 downto 0);
          manZ        : OUT std_logic_vector(47 downto 0);
          Ahigh,Bhigh : OUT std_logic
        );
END fpuAdderStage;

ARCHITECTURE dataflow OF fpuAdderStage IS
  COMPONENT cma25bits IS
    PORT  ( A,B   : IN  std_logic_vector(24 downto 0);
            cin   : IN  std_logic;
            sum   : OUT std_logic_vector(24 downto 0);
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT comparator25bit IS
    PORT  ( left,right  : IN  std_logic_vector(24 downto 0);
            lmr,rml     : OUT std_logic_vector(24 downto 0);
            gt,eq,lt    : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT comparator8bit IS
    PORT  ( left,right  : IN  std_logic_vector(7 downto 0);
            lmr,rml     : OUT std_logic_vector(7 downto 0);
            gt,eq,lt    : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT barrelShifter IS
    PORT  ( input   : IN  std_logic_vector;
            shift   : IN  std_logic_vector;
            output  : OUT std_logic_vector
          );
  END COMPONENT;
  
  FOR ALL : cma25bits       USE ENTITY  WORK.cma25bits(dataflow);
  FOR ALL : comparator25bit USE ENTITY  WORK.comparator25bit(dataflow);
  FOR ALL : comparator8bit  USE ENTITY  WORK.comparator8bit(dataflow);
  FOR ALL : barrelShifter   USE ENTITY  WORK.barrelShifter(dataflow);
  
  SIGNAL  expgt,expeq,explt     : std_logic;
  SIGNAL  mangt,maneq,manlt     : std_logic;
  
  SIGNAL  sd1                   : std_logic_vector(expA'RANGE);
  SIGNAL  sdc                   : std_logic;
  SIGNAL  shift_dist            : std_logic_vector(4 downto 0);
  
  SIGNAL  expAmB,expBmA         : std_logic_vector(expA'RANGE);
  
  SIGNAL  swap                  : std_logic;
  SIGNAL  xbar_l,xbar_r         : std_logic_vector(manA'RANGE);
  
  SIGNAL  shifted_r             : std_logic_vector(manA'RANGE);
  
  SIGNAL  subArgs               : std_logic;
  SIGNAL  l_adder_in,r_adder_in : std_logic_vector(manA'HIGH+1 downto manA'LOW);
  SIGNAL  addSum                : std_logic_vector(manA'HIGH+1 downto manA'LOW);
  
  SIGNAL  signBCorrect          : std_logic;
  
  SIGNAL  signZtemp             : std_logic;
  SIGNAL  expZtemp              : std_logic_vector(expA'RANGE);
  SIGNAL  manZtemp              : std_logic_vector(manZ'RANGE);
  
  SIGNAL  manApadded            : std_logic_vector(manZ'RANGE);
  
  SIGNAL  oper                  : std_logic;
  
BEGIN
  --If doing subtraction, filp the sign of B.
  signBCorrect <= NOT signB     when (ASM(0) = '1') else  --Subtraction
                  signB;  --Addition
  
  --Compare the exponents
  compareExp : comparator8bit PORT MAP
    ( expA, expB,
      expAmB, expBmA,
      expgt, expeq, explt
    );
    
  --Compare the mantissas  
  compareMan : comparator25bit PORT MAP
    ( '0' & manA, '0' & manB,
      open, open,
      mangt, maneq, manlt
    );
    
  --Logic for deciding Z's sign
  signZtemp   <=  signA         when ((expgt OR (expeq AND mangt)) = '1') else
                  signBCorrect  when ((explt OR (expeq AND manlt)) = '1') else
                  signA AND signBCorrect;
                  
  --Logic for deciding Z's exponent                
  expZtemp    <=  expA  when (expgt = '1') else expB;
  
  --Find the correct shift distance
  sd1         <=  expBmA when (explt = '1') else expAmB;
  sdc         <=  sd1(7) OR sd1(6) OR sd1(5);
  shift_dist  <=  sd1(4 downto 0) when (sdc = '0') else "11111";
   
  --Cross bar logic               
  swap        <=  explt OR (expeq AND manlt);
  xbar_l      <=  manB  when (swap = '1') else manA;
  xbar_r      <=  manA  when (swap = '1') else manB;
  
  --Larger value is on the left side of the xbar
  --Shift the right side to have the same exponent as left side
  Shifter : barrelShifter PORT MAP
    ( xbar_r,
      shift_dist,
      shifted_r
    );
  
  --Logic for the adder inputs
  subArgs     <=  signA xor signBCorrect;
  l_adder_in  <=  '0' & xbar_l;
  r_adder_in  <=  '1' & NOT shifted_r when (subArgs = '1') else '0' & shifted_r;
  
  --add two arguments together: The Core Adder
  Adder : cma25bits PORT MAP
    ( l_adder_in, r_adder_in,
      subArgs,
      addSum,
      open
    );
    
  --Padding
  manApadded  <=  manA & x"000000";
  manZtemp    <=  addSum & "000" & x"00000";
  
  --Selection signals
  oper        <=  (NOT ASM(1));
  
  --Selection for signZ
  signZ       <=  signA       when (En_in = '0') else
                  signZtemp   when (oper = '1') else
                  'Z';
  
  --Selection for expZ
  expZ        <=  expA        when (En_in = '0') else
                  expZtemp    when (oper = '1') else
                  (others => 'Z');
  --Selection for manZ
  manZ        <=  manApadded  when (En_in = '1') else
                  manZtemp    when (oper = '1') else
                  (others => 'Z');
                  
  --Output Ahigh and Bhigh
  Ahigh       <=  expA(expA'HIGH);
  Bhigh       <=  expB(expB'HIGH);
  
END dataflow;
