LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Lab07 is
	PORT (
		SW : in std_logic_vector(17 downto 0);
		LEDR : out std_logic_vector(17 downto 0) := (others => '0');
		LEDG : out std_logic_vector(8 downto 0 ) := (others => '0');
		KEY : in std_logic_vector(3 downto 0);
		CLOCK_50 : in std_logic;

		I2C_SDAT : inout std_logic;
		I2C_SCLK, AUD_XCK : out std_logic;
		AUD_ADCDAT : in std_logic;
		AUD_DACDAT : out std_logic;
		AUD_ADCLRCK, AUD_DACLRCK, AUD_BCLK : in std_logic );
END Lab07;


ARCHITECTURE Structural of Lab07 is

	SIGNAL	AudioIn, AudioOut : signed(15 downto 0);
	SIGNAL	SamClk : std_logic;
	signal cleartone : std_logic;
	signal pulseout_temp : std_logic;
	
	COMPONENT AudioInterface is
	Generic ( SID : integer := 100 ); 
	Port (CLOCK_50 : in std_logic;
		init : in std_logic;

		I2C_SDAT : inout std_logic;
		I2C_SCLK, AudMclk : out std_logic;
		AUD_ADCDAT : in std_logic;
		AUD_DACDAT : out std_logic;
		AUD_ADCLRCK, AUD_DACLRCK, AUD_BCLK : in std_logic;
		
		SamClk : out std_logic;
		AudioIn : out signed(15 downto 0);
		AudioOut : in signed(15 downto 0));
	END COMPONENT;
	
	component tonegenerator is 
	port( freq : in unsigned(15 downto 0);
			clk : in std_logic;
			clear : in std_logic;
			waveout : out signed(15 downto 0)
		 );
	end component;

	component morsegenerator is
	port( pulseout : out std_logic;
			clk : in std_logic;
			output : out std_logic_vector(5 downto 0)
			);
	end component;
BEGIN

--***********************************************************************************
-- You must enter the last five digits from the student number of one group member.
-- Ex: AudioInterface generic map ( SID => xxxxx ) - where xxxxx are the last 5 digits.
--
--***********************************************************************************
			assm: AudioInterface	generic map ( SID => 27422 )
			PORT MAP( Clock_50 => CLOCK_50, AudMclk => AUD_XCK,	-- period is 80 ns ( 12.5 Mhz )
						init => KEY(0), 									-- +ve edge initiates I2C data
						I2C_Sclk => I2C_SCLK,
						I2C_Sdat => I2C_SDAT,
						AUD_BCLK => AUD_BCLK, AUD_ADCLRCK => AUD_ADCLRCK, AUD_DACLRCK => AUD_DACLRCK,
						AUD_ADCDAT => AUD_ADCDAT, AUD_DACDAT => AUD_DACDAT,
						AudioOut => AudioOut, AudioIn => AudioIn, SamClk => SamClk );

			--AudioOut <= AudioIn;
			ledg(0)<=pulseout_temp;
			
				 cleartone<= '0' when key(2) = '0' else
						 		 pulseout_temp;
			u1 : tonegenerator port map ( freq=>unsigned(SW(15 downto 0)),waveout=>AudioOut,clear=>cleartone,clk=>samclk);
			u2 : morsegenerator port map ( pulseout=>pulseout_temp, clk=>samclk, output=>ledr(5 downto 0));
END Structural;
