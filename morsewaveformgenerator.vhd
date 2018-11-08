library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity morsegenerator is
	port( pulseout : out std_logic;
			clk : in std_logic;
			output : out std_logic_vector(5 downto 0)
			);
	end morsegenerator;
	
architecture behaviour of morsegenerator is

		signal slowclock : signed(13 downto 0) := (others=>'0');
		signal reg : unsigned (5 downto 0) := "100001";
		signal current_state: std_logic :=  '1';
		--signal dec : std_logic_vector(32 downto 0);
begin

	--dec(unsigned(reg)) = 

	process(reg)
	begin
	
	case to_integer(reg) is
		when 33 | 31 | 29 | 23 to 25 | 19 to 21 | 15 to 17 | 11 | 9 | 7 =>
			current_state <= '1';
		when others =>
			current_state <= '0';
	end case;
	end process;
	
process(clk)
	begin
		if rising_edge(clk) then
			slowclock <= slowclock + 1;
		end if;
end process;
	
	process(slowclock(13))
	begin
		if(rising_edge(slowclock(13))) then
			if(reg = 0) then
				reg <= "100001";
			else
				reg <= reg - 1;
			end if;
		end if;
	end process;
	
	output<= std_logic_vector(reg);
	pulseout <= current_state;
end behaviour;