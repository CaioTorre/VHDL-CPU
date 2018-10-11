library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ctrlunit is
	port (instruction: in std_logic_vector(0 to 15);
		clock: in std_logic;
		reg0in, reg0out: out std_logic;
		reg1in, reg1out: out std_logic;
		reg2in, reg2out: out std_logic;
		reg3in, reg3out: out std_logic;
		regAin: out std_logic;
		regGin, regGout: out std_logic;
		regTin, regTout: out std_logic;
		imedIn: out std_logic;
		ALUOp:  out std_logic_vector(0 to 2));
end ctrlunit;

architecture ctrl of ctrlunit is
	type states is (waiting, mov0, movi0, xchg0, xchg1, xchg2, arith0, arith1, arith2);
	signal state: states := waiting;
	signal opcode: std_logic_vector(0 to 3);
	signal r1, r2, r3: std_logic_vector(0 to 1);
begin
	opcode <= instruction(0 to 3);
	r1 <= instruction(4 to 5);
	r2 <= instruction(6 to 7);
	r3 <= instruction(8 to 9);
	process(clock)
	begin
		if (clock'event and clock = '0') then
			case state is
				when waiting =>
					reg0in <= '0';
					reg0out <= '0';
					reg1in <= '0';
					reg1out <= '0';
					reg2in <= '0';
					reg2out <= '0';
					reg3in <= '0';
					reg3out <= '0';
					regAin <= '0';
					regGin <= '0';
					regGout <= '0';
					regTin <= '0';
					regTout <= '0';
					imedIn <= '0';
					case opcode is
						when "0000" => state <= mov0;
						when "0001" => state <= movi0;
						when "0010" => state <= xchg0;
						when "0011" => state <= arith0; -- SLL
						when "0100" => state <= arith0; -- SRL
						when "0101" => state <= arith0; -- ADDI
						when "0110" => state <= arith0; -- SUBI
						when "0111" => state <= arith0; -- ANDI
						when "1000" => state <= arith0; -- ORI
						when "1001" => state <= arith0; -- ADD
						when "1010" => state <= arith0; -- SUB
						when "1011" => state <= arith0; -- AND
						when "1100" => state <= arith0; -- OR
						when others => state <= waiting;
					end case;
				when mov0 => --============= MOV Ri, Rj =============
					case r2 is
						when "00" => reg0out <= '1';
						when "01" => reg1out <= '1';
						when "10" => reg2out <= '1';
						when "11" => reg3out <= '1';
						when others => state <= waiting;
					end case;
					case r1 is
						when "00" => reg0in <= '1';
						when "01" => reg1in <= '1';
						when "10" => reg2in <= '1';
						when "11" => reg3in <= '1';
						when others => state <= waiting;
					end case;
					state <= waiting;
				when movi0 => --============= MOV Ri, Imed =============
					imedIn <= '1';
					case r1 is 
						when "00" => reg0in <= '1';
						when "01" => reg1in <= '1';
						when "10" => reg2in <= '1';
						when "11" => reg3in <= '1';
						when others => state <= waiting;
					end case;
					state <= waiting;
				when xchg0 => --============= XCHG Ri, Rj =============
					regTin <= '1'; 
					case r1 is 
						when "00" => reg0out <= '1';
						when "01" => reg1out <= '1';
						when "10" => reg2out <= '1';
						when "11" => reg3out <= '1';
						when others => state <= waiting;
					end case;
					state <= xchg1;
				when xchg1 =>
					regTin <= '0';
					reg0out <= '0';
					reg1out <= '0';
					reg2out <= '0';
					reg3out <= '0';
					case r1 is 
						when "00" => reg0in <= '1';
						when "01" => reg1in <= '1';
						when "10" => reg2in <= '1';
						when "11" => reg3in <= '1';
						when others => state <= waiting;
					end case;
					case r2 is 
						when "00" => reg0out <= '1';
						when "01" => reg1out <= '1';
						when "10" => reg2out <= '1';
						when "11" => reg3out <= '1';
						when others => state <= waiting;
					end case;
					state <= xchg2;
				when xchg2 =>
					regTout <= '1';
					case r1 is 
						when "00" => reg0in <= '0';
						when "01" => reg1in <= '0';
						when "10" => reg2in <= '0';
						when "11" => reg3in <= '0';
						when others => state <= waiting;
					end case;
					reg0out <= '0';
					reg1out <= '0';
					reg2out <= '0';
					reg3out <= '0';
					case r2 is 
						when "00" => reg0in <= '1';
						when "01" => reg1in <= '1';
						when "10" => reg2in <= '1';
						when "11" => reg3in <= '1';
						when others => state <= waiting;
					end case;
					state <= waiting;
				when arith0 => --============= ARITMETICAS =============
					regAin <= '1';
					case r2 is 
						when "00" => reg0out <= '1';
						when "01" => reg1out <= '1';
						when "10" => reg2out <= '1';
						when "11" => reg3out <= '1';
						when others => state <= waiting;
					end case;
					state <= arith1;
				when arith1 => 
					regAin <= '0';
					reg0out <= '0';
					reg1out <= '0';
					reg2out <= '0';
					reg3out <= '0';
					if (opcode > "1000") then
						case r3 is 
							when "00" => reg0out <= '1';
							when "01" => reg1out <= '1';
							when "10" => reg2out <= '1';
							when "11" => reg3out <= '1';
							when others => state <= waiting;
						end case;
					else 
						imedIn <= '1';
					end if;
					case opcode is 
						when "0011" => ALUOp <= "100";
						when "0100" => ALUOp <= "101";
						when "0101" => ALUOp <= "000";
						when "1001" => ALUOp <= "000";
						when "0110" => ALUOp <= "001";
						when "1010" => ALUOp <= "001";
						when "0111" => ALUOp <= "010";
						when "1011" => ALUOp <= "010";
						when "1000" => ALUOp <= "011";
						when "1100" => ALUOp <= "011";
						when others => ALUOp <= "UUU";
					end case;
					regGin <= '1';
					state <= arith2;
				when arith2 =>
					reg0out <= '0';
					reg1out <= '0';
					reg2out <= '0';
					reg3out <= '0';
					regGin <= '0';
					case r1 is 
						when "00" => reg0in <= '1';
						when "01" => reg1in <= '1';
						when "10" => reg2in <= '1';
						when "11" => reg3in <= '1';
						when others => state <= waiting;
					end case;
					regGout <= '1';
					state <= waiting;
				when others =>
					state <= waiting; --WORK IN PROGRESS
			end case;
		end if;
	end process;
end ctrl;