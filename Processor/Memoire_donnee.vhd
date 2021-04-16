----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:20:04 04/15/2021 
-- Design Name: 
-- Module Name:    Memoire_donnee - Behavioral 
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

entity Memoire_donnee is
	Port ( Adresse : in STD_LOGIC_VECTOR(7 downto 0);
			 INPUT : in STD_LOGIC_VECTOR (7 downto 0);
			 RW : in STD_LOGIC;
			 RST : in STD_LOGIC;
			 CLK : in STD_LOGIC;
			 OUTPUT : out STD_LOGIC_VECTOR(7 downto 0));
end Memoire_donnee;

architecture Behavioral of Memoire_donnee is

--Déclaration d'une mémoire sous forme de tableau pour stocker les données.
-- On a un tableau de 200 cases dont chacune peut contenir un STD_LOGIC_VECTOR
-- de taille 8. C.f. cours page 22.

type memoire is array (199 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
-- On déclare un signal de type memoire.
signal memory : memoire; 

begin

process (CLK) -- On se synchronise sur la clock comme explicité dans le sujet.

begin
	
	if FALLING_EDGE (CLK) then --On se place au niveau de front descendant pour
										-- laisser le temps à la clock de démarrer.
										-- RISING_EDGE pourrait fonctionner sans doute (à tester).
		
		if(RST = '0') then --On initialise le contenu de la mémoire à 0x00.
			
			memory <= (others => (others => '0')); -- On initilise la mémoire à 0x00.

		else
			if(RW = '0') then
				memory(to_integer(unsigned(Adresse))) <= INPUT; -- On copie l'entrée
																		-- dans la memoire à Adresse.
			else
				OUTPUT <= memory(to_integer(unsigned(Adresse))); -- On lit la valeur 
																		-- située à Adresse en l'envoyant
																		-- à la sortie OUTPUT.
			end if;
		end if;
	end if;

end process;

end Behavioral;

