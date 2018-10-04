library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cpu is 
	port(instruction: in std_logic_vector(0 to 15);
	 clock: in std_logic;
	 reg0in, reg0out: in std_logic;
	 reg1in, reg1out: in std_logic;
	 reg2in, reg2out: in std_logic;
	 reg3in, reg3out: in std_logic;
	 regAin: in std_logic;
	 regGin, regGout: in std_logic;
	 imedIn: in std_logic;
	 busview: out std_logic_vector(0 to 15));
end cpu;

architecture behavior of cpu is
	signal mbus: std_logic_vector(0 to 15);
	--signal clock: std_logic;
	--signal reg0in, reg0out: std_logic;
	--signal reg1in, reg1out: std_logic;
	--signal reg2in, reg2out: std_logic;
	--signal reg3in, reg3out: std_logic;
	--signal regAin: std_logic;
	--signal regGin, regGout: std_logic;
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
begin
	busview <= mbus;
	imed: tristate port map ("00000000" & instruction(8 to 15), imedIn, mbus);
	reg0: triregister port map (mbus, clock, reg0in, reg0out, master_reset, mbus);
	reg1: triregister port map (mbus, clock, reg1in, reg1out, master_reset, mbus);
	reg2: triregister port map (mbus, clock, reg2in, reg2out, master_reset, mbus);
	reg3: triregister port map (mbus, clock, reg3in, reg3out, master_reset, mbus);

	regA: register_16 port map (mbus, clock, regAin, master_reset, regAtoULA);
	regG: triregister port map (ULAtoRegG, clock, regGin, regGout, master_reset, mbus);
	alu: ula port map (regAtoULA, mbus, ALUOp, ULAtoRegG);
	
end behavior;