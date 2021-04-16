--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:17:24 04/11/2021
-- Design Name:   
-- Module Name:   /home/amari/Documents/Processor/ALU_Test.vhd
-- Project Name:  Processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_Test IS
END ALU_Test;
 
ARCHITECTURE behavior OF ALU_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         I1 : IN  std_logic_vector(7 downto 0);
         I2 : IN  std_logic_vector(7 downto 0);
         Ctrl_Alu : IN  std_logic_vector(1 downto 0);
         flag_C : OUT  std_logic;
         flag_O : OUT  std_logic_vector(7 downto 0);
         RES : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I1 : std_logic_vector(7 downto 0) := (others => '0');
   signal I2 : std_logic_vector(7 downto 0) := (others => '0');
   signal Ctrl_Alu : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal flag_C : std_logic;
   signal flag_O : std_logic_vector(7 downto 0);
   signal RES : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          I1 => I1,
          I2 => I2,
          Ctrl_Alu => Ctrl_Alu,
          flag_C => flag_C,
          flag_O => flag_O,
          RES => RES
        );



   -- Stimulus process
   stim_proc: process
   begin		
		I1 <= "00000011";
		I2 <= "00000001";
		Ctrl_Alu <= "11";

      wait;
   end process;

END;
