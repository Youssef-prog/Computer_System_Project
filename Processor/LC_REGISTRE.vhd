----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:02:44 05/03/2021 
-- Design Name: 
-- Module Name:    LC_REGISTRE - Behavioral 
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

entity LC_REGISTRE is
	Port(
					op_code	: in	std_logic_vector(7 downto 0);
		
					W		: out	std_logic
				);
end LC_REGISTRE;

architecture Behavioral of LC_REGISTRE is

begin

W	<= 	'0' when (op_code = x"08" or op_code = x"00") else
		   '1';
end Behavioral;

