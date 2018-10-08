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
		imedIn: out std_logic);
end ctrlunit;

architecture ctrl of ctrlunit is
	type states is (waiting, mov0, movi0, xchg0, xchg1, xchg2, add0, addi0, sub0, subi0, and0, andi0, or0, ori0, shl0, shr0);
	signal state: states;
	signal opcode: std_logic_vector(0 to 3);
	signal r1, r2, r3: std_logic_vector(0 to 1);
begin
	opcode <= instruction(0 to 3);
	r1 <= instruction(4 to 5);
	r2 <= instruction(6 to 7);
	r3 <= instruction(8 to 9);
	process(clock)
	begin
		if (clock'event and clock = '1') then
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
						when "0000" =>
							state <= mov0;
						when "0001" =>
							state <= movi0;
						when "0010" =>
							state <= xchg0;
						when "0011" => 
							state <= add0;
						when "0100" =>
							state <= addi0;
						when "0101" =>
							state <= sub0;
						when "0110" =>
							state <= subi0;
						when "0111" =>
							state <= and0;
						when "1000" =>
							state <= andi0;
						when "1001" =>
							state <= or0;
						when "1010" =>
							state <= ori0;
						when "1011" =>
							state <= shl0;
						when "1100" =>
							state <= shr0;
						when others =>
							state <= waiting;
					end case;
				when mov0 => --============= MOV Ri, Rj =============
					case r2 is
						when "00" =>
							reg0out <= '1';
						when "01" =>
							reg1out <= '1';
						when "10" =>
							reg2out <= '1';
						when "11" =>
							reg3out <= '1';
						when others =>
							state <= waiting;
					end case;
					case r1 is
						when "00" =>
							reg0in <= '1';
						when "01" =>
							reg1in <= '1';
						when "10" =>
							reg2in <= '1';
						when "11" =>
							reg3in <= '1';
						when others =>
							state <= waiting;
					end case;
					state <= waiting;
				when movi0 => --============= MOV Ri, Imed =============
					imedIn <= '1';
					case r1 is 
						when "00" =>
							reg0in <= '1';
						when "01" =>
							reg1in <= '1';
						when "10" =>
							reg2in <= '1';
						when "11" =>
							reg3in <= '1';
						when others =>
							state <= waiting;
					end case;
					state <= waiting;
				when xchg0 => --============= XCHG Ri, Rj =============
					regTin <= '1'; 
					case r1 is 
						when "00" =>
							reg0out <= '1';
						when "01" =>
							reg1out <= '1';
						when "10" =>
							reg2out <= '1';
						when "11" =>
							reg3out <= '1';
						when others =>
							state <= waiting;
					end case;
					state <= xchg1;
				when xchg1 =>
					regTin <= '0';
					case r1 is 
						when "00" =>
							reg0out <= '0';
							reg0in <= '1';
						when "01" =>
							reg1out <= '0';
							reg1in <= '1';
						when "10" =>
							reg2out <= '0';
							reg2in <= '1';
						when "11" =>
							reg3out <= '0';
							reg3in <= '1';
						when others =>
							state <= waiting;
					end case;
					case r2 is 
						when "00" =>
							reg0out <= '1';
						when "01" =>
							reg1out <= '1';
						when "10" =>
							reg2out <= '1';
						when "11" =>
							reg3out <= '1';
						when others =>
							state <= waiting;
					end case;
					state <= xchg2;
				when xchg2 =>
					regTout <= '1';
					case r2 is 
						when "00" =>
							reg0out <= '0';
							reg0in <= '1';
						when "01" =>
							reg1out <= '0';
							reg1in <= '1';
						when "10" =>
							reg2out <= '0';
							reg2in <= '1';
						when "11" =>
							reg3out <= '0';
							reg3in <= '1';
						when others =>
							state <= waiting;
					end case;
					state <= waiting;
				when others =>
					state <= waiting; --WORK IN PROGRESS
			end case;
		end if;
	end process;
end ctrl;