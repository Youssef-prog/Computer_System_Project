----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:14:30 05/03/2021 
-- Design Name: 
-- Module Name:    LC_EX - Behavioral 
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

entity LC_EX is
	Port(
					op_code	: in	std_logic_vector(7 downto 0);
		
					Ctrl_Alu : out  STD_LOGIC_VECTOR(2 downto 0)
				);
end LC_EX;

architecture Behavioral of LC_EX is

begin

Ctrl_Alu <= "001"	when op_code = x"01" else -- add
				"010"	when op_code = x"02" else --  mul
				"011"	when op_code = x"03" else -- sou
				"100"	when op_code = x"04" else -- div
				"111";

end Behavioral;

