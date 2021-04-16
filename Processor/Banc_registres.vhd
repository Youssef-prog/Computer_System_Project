----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:32:53 04/15/2021 
-- Design Name: 
-- Module Name:    Banc_registres - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Banc_registres is
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
end Banc_registres;

architecture Behavioral of Banc_registres is

type reg_type is array(0 to 15) of std_logic_vector(7 downto 0);
signal REGISTRES : reg_type;

begin

process (clk) 
	begin
		if falling_edge(clk) then
			if RST = '0' then
				REGISTRES <= (others => (others => '0'));
				
			else 
				if W = '1' then
					REGISTRES(to_integer(unsigned(Write_reg))) <= DATA;
				end if;
			end if;
		end if;	
	end process;
--  L’unité d’envoi : si on a une lecture et ecriture : QX <- data

	QA <= DATA when ((W='1') and (Read_A = Write_reg)) else
		   REGISTRES(to_integer(unsigned(Read_A)));
			
	QB <= DATA when ((W='1') and (Read_B = Write_reg)) else
	      REGISTRES(to_integer(unsigned(Read_B)));



end Behavioral;

