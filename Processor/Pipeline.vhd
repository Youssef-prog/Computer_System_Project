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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline is
	Port(			
					RST : in STD_LOGIC;
					 
					CLK : in STD_LOGIC;
					
					OP_LI_DI	: in	std_logic_vector (7 downto 0);
		
					A_LI_DI : in STD_LOGIC_VECTOR (7 downto 0);
					
					B_LI_DI : in	STD_LOGIC_VECTOR (7 downto 0);
					
					C_LI_DI : in STD_LOGIC_VECTOR (7 downto 0);
					
					
					-- out
					
					sortie_reg_A   : out std_logic_vector (7 downto 0);
					
					sortie_reg_B   :	out std_logic_vector (7 downto 0);
					
					
				);
end Pipeline;

architecture Behavioral of Pipeline is
component Banc_registres is
 Port (
		RST 			: in  	STD_LOGIC;	--Le signal reset RST est actif � 0 : le contenu du banc de registres est alors initialis� � 0x00
		--lire deux registres simultan�ment
		Read_A           : in 		STD_LOGIC_VECTOR ( 3 downto 0 );
		Read_B           : in 		STD_LOGIC_VECTOR ( 3 downto 0 );
		-- Les valeurs correspondantes ( lu par A ET B ) sont propag�es vers les sorties QA et QB
		QA          : out 	STD_LOGIC_VECTOR ( 7 downto 0 );
		QB          : out		STD_LOGIC_VECTOR ( 7 downto 0 );
		-- L'�criture de donn�es : 
		W 			   : in  	STD_LOGIC; -- W sp�cifie si une �criture doit �tre r�alis�e. Cette entr�e est active � 1.
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
--signaux
signal sortie_QA,sortie_QB,B_MEM_RE,A_MEM_RE : STD_LOGIC_VECTOR ( 7 downto 0 );
signal wrt : std_logic ;
signal A_DI_EX, OP_DI_EX, B_DI_EX, C_DI_EX : STD_LOGIC_VECTOR ( 7 downto 0 );
signal A_EX_MEM, OP_EX_MEM, B_EX_MEM : STD_LOGIC_VECTOR ( 7 downto 0 );
signal sng_ctrl_alu,carry,overflow,resultat : STD_LOGIC_VECTOR ( 7 downto 0 );
signal OP_MEM_RE,A_MEM_RE,B_MEM_RE : STD_LOGIC_VECTOR ( 7 downto 0 );
begin
-- wrt le fil qui sort de w 
reg :Banc_registres port map (RST, B_LI_DI, C_LI_DI, sortie_QA, sortie_QB, wrt,DATA_MEM_RE,WRITE_MEM_RE,clk);
mem_alu : ALU port map (B_DI_EX,C_DI_EX, sng_ctrl_alu, carry, overflow,resultat);
LC_MEM_RE: LC_REGISTRE port map ( OP_MEM_RE, WW);
LC_DI_EX : LC_EX port map ( OP_DI_EX, sng_ctrl_alu);
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
		C_EX_MEM	 <= (others => '0');
		OP_EX_MEM <= (others => '0');
		--
		A_MEM_RE  <= (others => '0');
		B_MEM_RE  <= (others => '0');
		OP_MEM_RE <= (others => '0');
		
		else
		
		if OP_LI_DI = x"06" then  --afc
		A_DI_EX  <=	A_LI_DI;
		B_DI_EX  <=	B_LI_DI;
		C_DI_EX  <= C_LI_DI;
		OP_DI_EX <= OP_LI_DI;
		--
		A_EX_MEM <= A_DI_EX;
		B_EX_MEM <= B_DI_EX;
		OP_EX_MEM <= OP_DI_EX;
		
		--
		A_MEM_RE <= A_EX_MEM;
		B_MEM_RE <= B_EX_MEM;
		OP_MEM_RE<= OP_EX_MEM;
		
		--
		 DATA_MEM_RE  <= B_MEM_RE;
		 WRITE_MEM_RE <= A_MEM_RE;
		 wrt          <= WW;
		
		elsif OP_LI_DI = x"05" then --COP
		A_DI_EX  <=	A_LI_DI;
		B_DI_EX  <=	sortie_QA;
		C_DI_EX  <= C_LI_DI;
		OP_DI_EX <= OP_LI_DI;
		--
		A_EX_MEM <= A_DI_EX;
		B_EX_MEM <= B_DI_EX;
		OP_EX_MEM <= OP_DI_EX;
		--
		A_MEM_RE <= A_EX_MEM;
		B_MEM_RE <= B_EX_MEM;
		OP_MEM_RE<= OP_EX_MEM;
		
		--
		 DATA_MEM_RE  <= B_MEM_RE;
		 WRITE_MEM_RE <= A_MEM_RE;
		 wrt     		 <= WW;
		
		elsif OP_LI_DI = x"01" or x"02" or x"03" or x"04" -- ADD MUL SOU DIV
		A_DI_EX  <=	A_LI_DI;
		B_DI_EX  <=	B_LI_DI;
		C_DI_EX  <= C_LI_DI;
		OP_DI_EX <= OP_LI_DI;
		--
		A_EX_MEM <= A_DI_EX;
		B_EX_MEM <= B_DI_EX;
		OP_EX_MEM <= OP_DI_EX;
		
		--
		A_MEM_RE <= A_EX_MEM;
		B_MEM_RE <= B_EX_MEM;
		OP_MEM_RE<= OP_EX_MEM;
		end if;
	end if;	
end process;
end Behavioral;

