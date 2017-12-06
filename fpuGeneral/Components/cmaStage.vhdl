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
use ieee.math_real.all;

ENTITY cmaStage IS
  GENERIC ( Init  : Integer
          );
  PORT  ( A,B   : IN  std_logic_vector;
          cin   : IN  std_logic;
          sum   : OUT std_logic_vector;
          cout  : OUT std_logic
        );
END cmaStage;

ARCHITECTURE dataflow of cmaStage IS
  COMPONENT cmaSubstage_Level2 IS
    PORT  ( A,B                 : IN  std_logic_vector;
            muxCtrlin           : IN  std_logic;
            sum                 : OUT std_logic_vector;
            cout,coutP0,coutP1  : OUT std_logic;
            muxCtrlout          : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT cmaSubstage_Level3 IS
    PORT  ( A,B                                   : IN  std_logic_vector;
            cin                                   : IN  std_logic;
            muxCtrlin,muxCtrlP0in,muxCtrlP1in     : IN  std_logic;
            sum                                   : OUT std_logic_vector;
            cout,coutP0,coutP1                    : OUT std_logic;
            muxCtrlout,muxCtrlP0out,muxCtrlP1out  : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : cmaSubstage_Level2  USE ENTITY  WORK.cmaSubstage_Level2(dataflow);
  FOR ALL : cmaSubstage_Level3  USE ENTITY  WORK.cmaSubstage_Level3(dataflow);
  
  SIGNAL carry,carryP0,carryP1        : std_logic_vector(((1-2*Init+Integer(Sqrt(Real((2*Init-1)**2+8*A'LENGTH))))/2)-1 downto 0) := (others => '0');
  SIGNAL muxCtrl,muxCtrlP0,muxCtrlP1  : std_logic_vector(((1-2*Init+Integer(Sqrt(Real((2*Init-1)**2+8*A'LENGTH))))/2)-1 downto 0) := (others => '0');
  
BEGIN
  GEN_SUBSTAGES : FOR i IN carry'REVERSE_RANGE GENERATE
    Substage_Level2 : IF i = carry'LOW GENERATE
      Substage0 : cmaSubstage_Level2 PORT MAP
        ( A(Init-1+A'LOW downto A'LOW), B(Init-1+B'LOW downto B'LOW),
          cin,
          sum(Init-1+sum'LOW downto sum'LOW),
          carry(i), muxCtrlP0(i), muxCtrlP1(i),
          muxCtrl(i)
        );
    END GENERATE Substage_Level2;
    
    Substages_Level3 : IF i > carry'LOW GENERATE
      SubstageX : cmaSubstage_Level3 PORT MAP
        ( A((i+1)*Init+(i+1)*i/2-1+A'LOW downto i*Init+(i-1)*i/2+A'LOW), B((i+1)*Init+(i+1)*i/2-1+B'LOW downto i*Init+(i-1)*i/2+B'LOW), 
          carry(i-1),
          muxCtrl(i-1), muxCtrlP0(i-1), muxCtrlP1(i-1),
          sum((i+1)*Init+(i+1)*i/2-1+sum'LOW downto i*Init+(i-1)*i/2+sum'LOW),
          carry(i), carryP0(i), carryP1(i),
          muxCtrl(i), muxCtrlP0(i), muxCtrlP1(i)
        );
    END GENERATE Substages_Level3;
  END GENERATE GEN_SUBSTAGES;
  
  cout  <=  carry(carry'HIGH);
  
END dataflow;