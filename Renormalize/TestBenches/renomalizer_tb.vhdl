entity renormalizer_tb is
end renormalizer_tb;

architecture behave of renormalizer_tb is
begin
  signal
  
  signal A,B,C : std_logic_vector (31 downto 0);
  signal exp_res : std_logic_vector (31 downto 0);
  signal latch,drive : std_ulogic := '0';
  signal aid_sig, bid_sig, resid_sig : string(1 to 6) := "======";
  signal err_sig : bit;
  signal score : integer := 0;

component renormalizer
	PORT(
		enableIn : in std_logic;
		signIn : in std_logic;
		exponentIn : in std_logic_vector(7 downto 0);
		mantissaIn : in std_logic_vector(47 downto 0);
		aHigh : in std_logic;
		bHigh : in std_logic;
		zOut : out std_logic_vector(31 downto 0)
	);
end renormalizer;
FOR ALL : renormalizer_tb use ENTITY work.renormalizer_tb(behave);

end behave;
