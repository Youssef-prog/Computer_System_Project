--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:15:37 05/14/2021
-- Design Name:   
-- Module Name:   /home/amari/Documents/Git_Processor/Computer_System_Project_Microprocessor/Processor/Pipeline_test.vhd
-- Project Name:  Processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Pipeline
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
 
ENTITY Pipeline_test IS
END Pipeline_test;
 
ARCHITECTURE behavior OF Pipeline_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Pipeline
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
         IP : IN  std_logic_vector(7 downto 0);
         sortie_reg_A : OUT  std_logic_vector(7 downto 0);
         sortie_reg_B : OUT  std_logic_vector(7 downto 0);
         W_instruction : OUT  std_logic;
         DATA_reg_instruction : OUT  std_logic_vector(7 downto 0);
         Write_reg_instruction : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';
   signal IP : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal sortie_reg_A : std_logic_vector(7 downto 0);
   signal sortie_reg_B : std_logic_vector(7 downto 0);
   signal W_instruction : std_logic;
   signal DATA_reg_instruction : std_logic_vector(7 downto 0);
   signal Write_reg_instruction : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Pipeline PORT MAP (
          RST => RST,
          CLK => CLK,
          IP => IP,
          sortie_reg_A => sortie_reg_A,
          sortie_reg_B => sortie_reg_B,
          W_instruction => W_instruction,
          DATA_reg_instruction => DATA_reg_instruction,
          Write_reg_instruction => Write_reg_instruction
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

      RST <= '1';

		
		wait for 100 ns;

		IP <= X"01";

		wait for 100 ns;
		
		IP <= X"02";
		
		wait for 100 ns;
		
		IP <= X"03";
		
		wait for 100 ns;
		
		IP <= X"04";
		
		
		--wait for 100 ns;
      -- insert stimulus here 
		

      wait;
   end process;

END;
