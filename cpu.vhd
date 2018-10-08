library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cpu is 
	port(instruction: in std_logic_vector(0 to 15);
	 clock: in std_logic;
	 --reg0in, reg0out: in std_logic;
	 --reg1in, reg1out: in std_logic;
	 --reg2in, reg2out: in std_logic;
	 --reg3in, reg3out: in std_logic;
	 --regAin: in std_logic;
	 --regGin, regGout: in std_logic;
	 --regTin, regTout: in std_logic;
	 --imedIn: in std_logic;
	 busview: out std_logic_vector(0 to 15);
	 rg0view: out std_logic_vector(0 to 15);
	 rg1view: out std_logic_vector(0 to 15);
	 rg2view: out std_logic_vector(0 to 15);
	 rg3view: out std_logic_vector(0 to 15));
end cpu;

architecture behavior of cpu is
	signal mbus: std_logic_vector(0 to 15);
	
	--signal clock: std_logic;
	signal reg0in, reg0out: std_logic;
	signal reg1in, reg1out: std_logic;
	signal reg2in, reg2out: std_logic;
	signal reg3in, reg3out: std_logic;
	signal regAin: std_logic;
	signal regGin, regGout: std_logic;
	signal regTin, regTout: std_logic;
	
	signal imedIn: std_logic;
	signal immedi: std_logic_vector(0 to 15);
	
	signal r0insid: std_logic_vector(0 to 15);
	signal r1insid: std_logic_vector(0 to 15);
	signal r2insid: std_logic_vector(0 to 15);
	signal r3insid: std_logic_vector(0 to 15);
	 
	signal regAtoULA: std_logic_vector(0 to 15);
	signal ULAtoRegG: std_logic_vector(0 to 15);
	signal ALUOp: std_logic_vector(0 to 1);
	signal master_reset: std_logic;
	
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
	
	component triregister
		port (input: in std_logic_vector(0 to 15);
			clock: in std_logic;
			enablein: in std_logic;
			enableout: in std_logic;
			reset: in std_logic;
			output: out std_logic_vector(0 to 15));
	end component;
	
	component ula
		port (regA: in std_logic_vector(0 to 15);
			regB: in std_logic_vector(0 to 15);
			op:	in std_logic_vector(0 to 1);
			ula_out: out std_logic_vector(0 to 15));
	end component;
	
	component ctrlunit
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
	end component;
begin
	busview <= mbus;
	rg0view <= r0insid;
	rg1view <= r1insid;
	rg2view <= r2insid;
	rg3view <= r3insid;
	
	immedi <= "00000000" & instruction(8 to 15);
	imed: tristate port map (immedi, imedIn, mbus);
	
	reg0: register_16 port map (mbus, clock, reg0in, master_reset, r0insid);
	tri0: tristate port map (r0insid, reg0out, mbus);
	reg1: register_16 port map (mbus, clock, reg1in, master_reset, r1insid);
	tri1: tristate port map (r1insid, reg1out, mbus);
	reg2: register_16 port map (mbus, clock, reg2in, master_reset, r2insid);
	tri2: tristate port map (r2insid, reg2out, mbus);
	reg3: register_16 port map (mbus, clock, reg3in, master_reset, r3insid);
	tri3: tristate port map (r3insid, reg3out, mbus);
	
--	reg0: triregister port map (mbus, clock, reg0in, reg0out, master_reset, mbus);
--	reg1: triregister port map (mbus, clock, reg1in, reg1out, master_reset, mbus);
--	reg2: triregister port map (mbus, clock, reg2in, reg2out, master_reset, mbus);
--	reg3: triregister port map (mbus, clock, reg3in, reg3out, master_reset, mbus);

	regA: register_16 port map (mbus, clock, regAin, master_reset, regAtoULA);
	regG: triregister port map (ULAtoRegG, clock, regGin, regGout, master_reset, mbus);
	regT: triregister port map (mbus, clock, regTin, regTout, master_reset, mbus);
	alu: ula port map (regAtoULA, mbus, ALUOp, ULAtoRegG);
	
	unit: ctrlunit port map (instruction, clock, reg0in, reg0out, reg1in, reg1out, reg2in, reg2out, reg3in, reg3out, regAin, regGin, regGout, regTin, regTout, imedIn);
end behavior;
