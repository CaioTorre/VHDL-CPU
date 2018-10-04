library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ula is 
	port (regA: in std_logic_vector(0 to 15);
			regB: in std_logic_vector(0 to 15);
			op:	in std_logic_vector(0 to 1);
			ula_out: out std_logic_vector(0 to 15));
end ula;

architecture alu of ula is 
begin
	process(regA, regB, op)
	begin
		case op is
			when "00" =>
				ula_out <= regA + regB;
			when "01" =>
				ula_out <= regA - regB;
			when "10" =>
				ula_out <= regA and regB;
			when "11" =>
				ula_out <= regA or regB;
		end case;
	end process;
end alu;