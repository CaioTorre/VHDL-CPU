library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ula is 
	port (regA: in std_logic_vector(0 to 15);
			regB: in std_logic_vector(0 to 15);
			op:	in std_logic_vector(0 to 2);
			ula_out: out std_logic_vector(0 to 15));
end ula;

architecture alu of ula is 
begin
	process(regA, regB, op)
	begin
		case op is
			when "000" => ula_out <= regA + regB;
			when "001" => ula_out <= regA - regB;
			when "010" => ula_out <= regA and regB;
			when "011" => ula_out <= regA or regB;
			--when "100" => ula_out <= std_logic_vector(unsigned(regA) sll to_integer(unsigned(regB)));
			when "100" => ula_out <= to_stdlogicvector(to_bitvector(regA) sll to_integer(unsigned(regB)));
			when "101" => ula_out <= to_stdlogicvector(to_bitvector(regA) srl to_integer(unsigned(regB)));
			when others => ula_out <= "0000000000000000";
		end case;
	end process;
end alu;