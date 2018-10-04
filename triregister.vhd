library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity triregister is
	port (input: in std_logic_vector(0 to 15);
			clock: in std_logic;
			enablein: in std_logic;
			enableout: in std_logic;
			reset: in std_logic;
			output: out std_logic_vector(0 to 15));
end triregister;

architecture think of triregister is
	component register_16 
		port (input: in std_logic_vector(0 to 15);
			clock: in std_logic;
			enable: in std_logic;
			reset: in std_logic;
			output: out std_logic_vector(0 to 15));
	end component;
	component tristate
		port (input: in std_logic_vector(0 to 15);
			ctrl: in std_logic;
			output: out std_logic_vector(0 to 15));
	end component;
	signal med: std_logic_vector(0 to 15);
begin
	reg: register_16 port map (input, clock, enablein, reset, med);
	tri: tristate port map (med, enableout, output);
end think;