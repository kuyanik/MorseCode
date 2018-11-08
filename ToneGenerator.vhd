library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;


entity tonegenerator is 
port( freq : in unsigned(15 downto 0);
		clk : in std_logic;
		clear : in std_logic;
		waveout : out signed(15 downto 0)
		);
end tonegenerator;

architecture behaviour of tonegenerator is

signal reg : signed(21 downto 0);
begin

process(clk)
begin
	if(rising_edge(clk)) then
		if(clear = '0') then
		reg <= (others=>'0');
		elsif(clear = '1') then
		reg <= reg + signed("000000" & freq);
		end if;
	end if;
end process;

waveout <= reg(21 downto 6);

end behaviour;