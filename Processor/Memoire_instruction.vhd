----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:26:56 04/16/2021 
-- Design Name: 
-- Module Name:    Memoire_instruction - Behavioral 
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

entity Memoire_instruction is
	Port ( Adresse : in STD_LOGIC_VECTOR(7 downto 0);
			 CLK : in STD_LOGIC;
			 OUTPUT : out STD_LOGIC_VECTOR(31 downto 0));
end Memoire_instruction;

architecture Behavioral of Memoire_instruction is

-- On a une mémoire d'instruction de type tableau contenant 500 cases.

type memoire_instr is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);

constant instruction_memory : memoire_instr:= (x"06000500", x"06010A00",
																x"06020800", x"05030000",
																x"01040002", others=> x"00000000");

-- On initialise la ROM 

begin


process (CLK)

	begin
		if RISING_EDGE(CLK) then
			OUTPUT <= instruction_memory(to_integer(unsigned(Adresse)));
		end if;
			
	end process;


end Behavioral;

