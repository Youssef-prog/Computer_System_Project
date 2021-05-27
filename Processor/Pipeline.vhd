----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:57:35 04/16/2021 
-- Design Name: 
-- Module Name:    Pipeline - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline is
	Port(			
					RST : in STD_LOGIC;
					 
					CLK : in STD_LOGIC;
					
					IP : in std_logic_vector ( 7 downto 0);
					
					--OUTPUTT : in std_logic_vector (31 downto 0);
					
					-- out
					
					sortie_reg_A   : out std_logic_vector (7 downto 0);
					
					sortie_reg_B   :	out std_logic_vector (7 downto 0);

					W_instruction : out  	STD_LOGIC; -- W spécifie si une écriture doit être réalisée. Cette entrée est active à 1.
					DATA_reg_instruction : out 		STD_LOGIC_VECTOR ( 7 downto 0 );
					Write_reg_instruction	: out 		STD_LOGIC_VECTOR ( 3 downto 0 )	
					
					
				);
end Pipeline;

architecture Behavioral of Pipeline is
component Banc_registres is
 Port (
		RST 			: in  	STD_LOGIC;	--Le signal reset RST est actif à 0 : le contenu du banc de registres est alors initialisé à 0x00
		--lire deux registres simultanément
		Read_A           : in 		STD_LOGIC_VECTOR ( 3 downto 0 );
		Read_B           : in 		STD_LOGIC_VECTOR ( 3 downto 0 );
		-- Les valeurs correspondantes ( lu par A ET B ) sont propagées vers les sorties QA et QB
		QA          : out 	STD_LOGIC_VECTOR ( 7 downto 0 );
		QB          : out		STD_LOGIC_VECTOR ( 7 downto 0 );
		-- L'écriture de données : 
		W 			   : in  	STD_LOGIC; -- W spécifie si une écriture doit être réalisée. Cette entrée est active à 1.
		DATA 			: in 		STD_LOGIC_VECTOR ( 7 downto 0 );
		Write_reg	: in 		STD_LOGIC_VECTOR ( 3 downto 0 );
		CLK 			: in  	STD_LOGIC
		);
end component;
component ALU is
    Port ( I1, I2 : in  STD_LOGIC_VECTOR (7 downto 0);
			  Ctrl_Alu : in STD_LOGIC_VECTOR(2 downto 0);
			  flag_C : out STD_LOGIC;
			  flag_O : out STD_LOGIC_VECTOR(7 downto 0);
           RES : out  STD_LOGIC_VECTOR(7 downto 0));
end component;

component Memoire_donnee is
	Port ( Adresse : in STD_LOGIC_VECTOR(7 downto 0);
			 INPUT : in STD_LOGIC_VECTOR (7 downto 0);
			 RW : in STD_LOGIC;
			 RST : in STD_LOGIC;
			 CLK : in STD_LOGIC;
			 OUTPUT : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component LC_REGISTRE is
	Port(
					op_code	: in	std_logic_vector(7 downto 0);
		
					W		: out	std_logic
				);
end component;

component LC_EX is
	Port(
					op_code	: in	std_logic_vector(7 downto 0);
		
					Ctrl_Alu : out  STD_LOGIC_VECTOR(2 downto 0)
				);
end component;

component LC_MEMORY is
			Port(
					op_code	: in	std_logic_vector(7 downto 0);
		
					RW		: out	std_logic
				);
end component;

--component IP is
--	Port(  Adresse : out STD_LOGIC_VECTOR(7 downto 0);
--			 CLK : in STD_LOGIC;
--			 RST : in STD_LOGIC;
--			 ENABLE : in STD_LOGIC);
--end component;

component Memoire_instruction is
	Port ( Adresse : in STD_LOGIC_VECTOR(7 downto 0);
			 CLK : in STD_LOGIC;
			 OUTPUT : out STD_LOGIC_VECTOR(31 downto 0));
end component;

--signaux
signal sortie_QA,sortie_QB,B_MEM_RE : STD_LOGIC_VECTOR ( 7 downto 0 );
signal wrt,carry,LS,WW,EN : std_logic ;
signal A_DI_EX, OP_DI_EX, B_DI_EX, C_DI_EX : STD_LOGIC_VECTOR ( 7 downto 0 );
signal A_EX_MEM, B_EX_MEM : STD_LOGIC_VECTOR ( 7 downto 0 );
signal overflow,resultat : STD_LOGIC_VECTOR ( 7 downto 0 );
signal OP_MEM_RE,A_MEM_RE,OP_EX_MEM,DATA_MEM_RE : STD_LOGIC_VECTOR ( 7 downto 0 );
signal sng_ctrl_alu : STD_LOGIC_VECTOR ( 2 downto 0 );
signal ADR,INP,OUTP : STD_LOGIC_VECTOR ( 7 downto 0 );
signal WRITE_MEM_RE : STD_LOGIC_VECTOR ( 3 downto 0 );
signal Add : STD_LOGIC_VECTOR ( 7 downto 0 );
-- Signaux pour résoudre les problèmes de bits.
signal read_a_4, read_b_4 : STD_LOGIC_VECTOR ( 3 downto 0 );
signal A_LI_DI, B_LI_DI, OP_LI_DI, C_LI_DI : STD_LOGIC_VECTOR ( 7 downto 0 );
signal OUTPUT_inst, OUTPUTT : STD_LOGIC_VECTOR ( 31 downto 0 );


begin
-- wrt le fil qui sort de w 
mem_inst : Memoire_instruction port map(Add, CLK, OUTPUTT);

OP_LI_DI <= OUTPUTT(31 downto 24);
A_Li_Di <= OUTPUTT(23 downto 16);
B_LI_DI <= OUTPUTT(15 downto 8);
C_LI_DI <= OUTPUTT(7 downto 0);

--read_a_4 <= B_LI_Di(3 downto 0);
--read_b_4 <= C_LI_Di(3 downto 0);

reg :Banc_registres port map (RST, read_a_4, read_b_4, sortie_QA, sortie_QB, wrt,DATA_MEM_RE,WRITE_MEM_RE,clk);
mem_alu : ALU port map (B_DI_EX,C_DI_EX, sng_ctrl_alu, carry, overflow,resultat);
LC_MEM_RE: LC_REGISTRE port map ( OP_MEM_RE, WW);
LC_DI_EX : LC_EX port map ( OP_DI_EX, sng_ctrl_alu);
LC_EX_MEM : LC_MEMORY port map ( OP_EX_MEM, LS );
mem_data : Memoire_donnee port map (ADR,INP, LS, RST,CLK,OUTP);
Write_reg_instruction	<= WRITE_MEM_RE; --A MEM_RE
DATA_reg_instruction <= DATA_MEM_RE; --B MEM_RE
W_instruction <= wrt; --OP_MEM_RE
sortie_reg_B <= sortie_QB;
sortie_reg_A <= sortie_QA;

process (clk)
begin
	if rising_edge(CLK) then
	
		if RST = '0' then 
		
		A_DI_EX   <= (others => '0');
		B_DI_EX   <= (others => '0');
		C_DI_EX   <= (others => '0');
		OP_DI_EX	 <= (others => '0');
		--
		A_EX_MEM	 <= (others => '0');
		B_EX_MEM	 <= (others => '0');
		OP_EX_MEM <= (others => '0');
		--
		A_MEM_RE  <= (others => '0');
		B_MEM_RE  <= (others => '0');
		OP_MEM_RE <= (others => '0');
		--IP <= X"00";
		Add <= X"00";
		
		else
		
		Add <= IP;
		
		A_DI_EX  <=	A_LI_DI;

		A_EX_MEM <= A_DI_EX;

		A_MEM_RE <= A_EX_MEM;
		
		
		if OP_LI_DI = x"06" then  --afc
		
		B_DI_EX  <=	B_LI_DI;
		B_EX_MEM <= B_DI_EX;
		B_MEM_RE <= B_EX_MEM;
		
		
		elsif OP_LI_DI = x"05" then --COP
		
		read_a_4 <= B_LI_Di(3 downto 0);
		B_DI_EX  <=	sortie_QA;
		B_EX_MEM <= B_DI_EX;
		B_MEM_RE <= B_EX_MEM;
		
		
		elsif OP_LI_DI = x"01" or OP_LI_DI = x"02" or OP_LI_DI = x"03" then -- ADD MUL SOU 
		
		read_a_4 <= B_LI_Di(3 downto 0);
		read_b_4 <= C_LI_Di(3 downto 0);

		B_DI_EX  <=	sortie_QA;
		C_DI_EX  <= sortie_QB;

		--
		B_EX_MEM <= resultat;
		B_MEM_RE <= B_EX_MEM;
		
		elsif OP_LI_DI = x"07"  then -- LOAD 
		
		B_DI_EX  <=	B_LI_DI;
		
		--read_a_4 <= B_LI_Di(3 downto 0);
		--read_b_4 <= C_LI_Di(3 downto 0);		
		
		--B_DI_EX  <=	sortie_QA;
		--C_DI_EX  <= sortie_QB;

		--
		B_EX_MEM <= B_DI_EX;
		--B_EX_MEM <= resultat;
		--
		ADR <= B_EX_MEM;
		B_MEM_RE <= OUTP;
		

		elsif OP_LI_DI = x"08"  then -- STORE
		
		read_a_4 <= B_LI_Di(3 downto 0);
		--read_b_4 <= C_LI_Di(3 downto 0);
		
		B_DI_EX  <=	sortie_QA;
		--C_DI_EX  <= sortie_QB;
		--
		B_EX_MEM <= B_DI_EX;
		--B_EX_MEM <= resultat;
		--
		ADR <= A_EX_MEM;
		INP <= B_EX_MEM;
		--B_MEM_RE <= OUTP;
				
		end if;
		
		OP_DI_EX <= OP_LI_DI;
		OP_EX_MEM <= OP_DI_EX;
		OP_MEM_RE<= OP_EX_MEM;
		
		DATA_MEM_RE  <= B_MEM_RE;
		WRITE_MEM_RE <= A_MEM_RE(3 downto 0);
		wrt          <= WW;
		
		end if;
	end if;	
end process;
end Behavioral;

