library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_16 is
	port (input: in std_logic_vector(0 to 15);
			clock: in std_logic;
			enable: in std_logic;
			reset: in std_logic;
			output: out std_logic_vector(0 to 15));
end register_16;

architecture reg of register_16 is
begin
	process(clock, reset)
	begin
		if (clock'event and clock = '1' and enable = '1') then
			output <= input;
		end if;
		if (reset = '1') then 
			output <= "0000000000000000";
		end if;
	end process;
end;