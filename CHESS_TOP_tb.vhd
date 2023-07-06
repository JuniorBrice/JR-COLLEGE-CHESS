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

entity CHESS_TOP_tb is
--  Port ( );
end CHESS_TOP_tb;

architecture Behavioral of CHESS_TOP_tb is

component CHESS_TOP is
    Port ( VGA_R : out STD_LOGIC_VECTOR (4 downto 0);
           VGA_G : out STD_LOGIC_VECTOR (5 downto 0);
           VGA_B : out STD_LOGIC_VECTOR (4 downto 0);
           VGA_HS : out STD_LOGIC;
           VGA_VS : out STD_LOGIC;
           CLK : in STD_LOGIC;
           Reset : in STD_LOGIC;
           sclk : BUFFER STD_LOGIC;
           cs_n : OUT STD_LOGIC;
           mosi : OUT STD_LOGIC;
           miso : in STD_LOGIC;
           Sel : in STD_LOGIC);
end component;

signal CLK_tb : std_logic;
signal Reset_tb : STD_LOGIC;
signal Sel_tb : STD_LOGIC;

signal VGA_R_tb: STD_LOGIC_VECTOR (4 downto 0);
signal VGA_G_tb: STD_LOGIC_VECTOR (5 downto 0);
signal VGA_B_tb: STD_LOGIC_VECTOR (4 downto 0);
signal VGA_HS_tb: std_logic;
signal VGA_VS_tb: std_logic;

signal sclk_tb :  STD_LOGIC;
signal cs_n_tb :  STD_LOGIC;
signal mosi_tb :  STD_LOGIC;
signal miso_tb :  STD_LOGIC;

begin

clk_gen_proc: process
begin

        CLK_tb <= '0';
        wait for 4 ns;
        CLK_tb <= '1';
        wait for 4 ns;

end process clk_gen_proc;




main_proc: process
begin

Reset_tb <= '1';
wait for 30 ms;

Reset_tb <= '0';
wait for 5 ms;


end process;

DUT: CHESS_TOP
    port map(
    
           VGA_R => VGA_R_tb, 
           VGA_G => VGA_G_tb,
           VGA_B => VGA_B_tb,
           VGA_HS => VGA_HS_tb,
           VGA_VS => VGA_VS_tb,
           CLK => CLK_tb,
           Reset => Reset_tb,
           sclk => sclk_tb,
           cs_n => cs_n_tb,
           mosi => mosi_tb,
           miso => miso_tb,
           Sel => Sel_tb
     );

end Behavioral;
