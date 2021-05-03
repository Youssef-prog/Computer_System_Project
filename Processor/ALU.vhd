----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:48:27 04/09/2021 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( I1, I2 : in  STD_LOGIC_VECTOR (7 downto 0);
			  Ctrl_Alu : in STD_LOGIC_VECTOR(2 downto 0);
			  flag_C : out STD_LOGIC;
			  flag_O : out STD_LOGIC_VECTOR(7 downto 0);
           RES : out  STD_LOGIC_VECTOR(7 downto 0));
end ALU;

architecture Behavioral of ALU is

signal temp: STD_LOGIC_VECTOR(15 downto 0);
signal RES_temp: STD_LOGIC_VECTOR (7 downto 0);

begin

	temp <= ("00000000"&I1) + ("00000000"&I2) when Ctrl_Alu = "001" else
	("00000000"&I1) - ("00000000"&I2) when Ctrl_Alu = "011" else
	std_logic_vector(to_unsigned((to_integer(unsigned("00000000"&I1)) * to_integer(unsigned("00000000"&I2))),16)) ;

RES_temp <= temp(7 downto 0);
flag_C <= temp(8);
flag_O <= temp(15 downto 8);
RES <= RES_temp;
end Behavioral;



