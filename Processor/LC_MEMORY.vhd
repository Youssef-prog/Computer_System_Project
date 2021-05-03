----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:37:49 05/02/2021 
-- Design Name: 
-- Module Name:    LC_MEMORY - Behavioral 
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

entity LC_MEMORY is
			Port(
					op_code	: in	std_logic_vector(7 downto 0);
		
					RW		: out	std_logic
				);
end LC_MEMORY;

architecture Behavioral of LC_MEMORY is

begin

RW	<= 	'0' when op_code = x"08"  else '1';
-- store :x'08' et else c'est pour load x'07'
end Behavioral;

