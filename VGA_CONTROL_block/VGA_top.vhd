----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2023 06:35:44 PM
-- Design Name: 
-- Module Name: VGA_clk - Behavioral
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

entity VGA_top is
	port(	HS           : out std_logic;
	        VS           : out std_logic;
	        Vid          : out std_logic;
			hcount       : out integer range 0 to 640;
			vcount       : out integer range 0 to 480;
			CLK          : in std_logic);
			
	end VGA_top;

architecture Behavioral of VGA_top is

Component VGA_ctrl is

	Port ( CLK  : in STD_LOGIC;
           EN   : in STD_LOGIC;
           hcount   : out INTEGER range 0 to 640;
           vcount   : out INTEGER range 0 to 480;
           vid      : out STD_LOGIC;
           hs : out STD_LOGIC;
           vs : out STD_LOGIC);
           
end component;
	
Component VGA_clock_div is

	Port ( clk : in STD_LOGIC;
           div : out STD_LOGIC);
           
end component;

signal div: std_logic;

begin

U0: VGA_clock_div port map( 
        clk => CLK,
        div => div);
    
U1: VGA_ctrl port map( 
        CLK  => CLK,
        EN   => div,
        hcount  => hcount, 
        vcount  => vcount,
        vid     => vid,
        hs => HS,
        vs => VS);
        
end Behavioral;
