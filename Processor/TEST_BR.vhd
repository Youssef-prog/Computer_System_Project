--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:29:53 04/15/2021
-- Design Name:   
-- Module Name:   C:/Users/xel-h/Desktop/proj sys info/projetsysinfo/TEST_BR.vhd
-- Project Name:  projetsysinfo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Banc_registres
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
 
ENTITY TEST_BR IS
END TEST_BR;
 
ARCHITECTURE behavior OF TEST_BR IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Banc_registres
    PORT(
         RST : IN  std_logic;
         Read_A : IN  std_logic_vector(3 downto 0);
         Read_B : IN  std_logic_vector(3 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         Write_reg : IN  std_logic_vector(3 downto 0);
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '0';
   signal Read_A : std_logic_vector(3 downto 0) := (others => '0');
   signal Read_B : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal Write_reg : std_logic_vector(3 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Banc_registres PORT MAP (
          RST => RST,
          Read_A => Read_A,
          Read_B => Read_B,
          QA => QA,
          QB => QB,
          W => W,
          DATA => DATA,
          Write_reg => Write_reg,
          CLK => CLK
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
		RST	<= '0';
      wait for 100 ns;
		
		RST	<= '1';

		-- TEST READ 
		Read_A <=	"0000";
		Read_B <=	"0001";
		W <= '0';-- aucune ecriture necessaire dans ce test 
		wait for 100 ns;
		
		-- TEST WRITE AND READ
		Read_A <=	"0000";
		Read_B <=	"0001";
		
		W  <= '1';	
		Write_reg	<= "0000";
		DATA	<= "11010000";
		wait for 100 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
