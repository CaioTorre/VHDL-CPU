library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tristate is
	port (input: in std_logic_vector(0 to 15);
			ctrl: in std_logic;
			output: out std_logic_vector(0 to 15));
end tristate;

architecture buf of tristate is
begin
	process(ctrl, input)
	begin
		if (ctrl = '1') then
			output <= input;
		else
			output <= "ZZZZZZZZZZZZZZZZ";
		end if;
	end process;
end buf;