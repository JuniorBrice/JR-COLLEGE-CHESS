----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2023 06:18:16 PM
-- Design Name: 
-- Module Name: CHESS_TOP_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity  VGA_top_tb is
--  Port ( );
end VGA_top_tb;

architecture Behavioral of VGA_top_tb is

component VGA_top is
	port(	HS           : out std_logic;
	        VS           : out std_logic;
	        Vid          : out std_logic;
			hcount       : out integer range 0 to 640;
			vcount       : out integer range 0 to 480;
			CLK          : in std_logic);			
end component;

signal CLK_tb : std_logic;
signal Vid_tb: std_logic;
signal HS_tb: std_logic;
signal VS_tb: std_logic;

signal hcount_tb : integer range 0 to 640;
signal vcount_tb : integer range 0 to 480;

begin

clk_gen_proc: process
begin

        CLK_tb <= '0';
        wait for 4 ns;
        CLK_tb <= '1';
        wait for 4 ns;

end process clk_gen_proc;

DUT: VGA_top
    port map(
    
            HS => HS_tb,
	        VS => VS_tb,
	        Vid => Vid_tb,
			hcount => hcount_tb,
			vcount => vcount_tb,
			CLK => CLK_tb
			
	);	

end Behavioral;
