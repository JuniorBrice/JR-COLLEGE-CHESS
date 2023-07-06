----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2023 01:17:33 PM
-- Design Name: 
-- Module Name: Pixel2Graphics - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--This module essentially monitors hcount, vcount, and the outputs of Pixel2Grid
--to produce a a 10x10 coordinate output which can be used by our pixel map to send
--appropriate RGB values.
--division is usually not recommended to be synthesized, but since we only need precision 
--up to a single integer (no decimals) it should cause us no issues here. Notice
--the inputs and outputs are integer types. 

entity Pixel2Graphics is
        port(Image_X :out integer range 0 to 11; --output x coordinate for graphics pixel map
             Image_Y :out integer range 0 to 11; --output y coordinate for graphics pixel map
			 Grid_X  :in integer range 0 to 7;  --input x grid location from pixel2grid
			 Grid_Y  :in integer range 0 to 7;  --input y grid location from pixel2grid
			 Hcount  :in integer range 0 to 640;
			 Vcount  :in integer range 0 to 480);
end Pixel2Graphics;

architecture Behavioral of Pixel2Graphics is

signal temp_X, temp_Y : signed(15 downto 0);

begin

process (Hcount, Vcount) begin
    
if(Hcount >= 86 AND Hcount <= 553 AND Vcount <= 473)then

        Case ((Hcount - 80) - (60 * Grid_X)) is 
            when 0 to 5 =>
                Image_X <= 0;
            when 6 to 9 =>
                Image_X <= 0;
            when 10 to 13 =>
                Image_X <= 1;
            when 14 to 17 =>
                Image_X <= 2;
            when 18 to 21 =>
                Image_X <= 3;
            when 22 to 25 =>
                Image_X <= 4;
            when 26 to 29 =>
                Image_X <= 5;
            when 30 to 33 =>
                Image_X <= 6;
            when 34 to 37 =>
                Image_X <= 7;
            when 38 to 41 =>
                Image_X <= 8;
            when 42 to 45 =>
                Image_X <= 9;
            when 46 to 49 =>
                Image_X <= 10;
            when 50 to 53 =>
                Image_X <= 11;
            when 54 to 59 =>
                Image_X <= 0;           
            when others =>
                Image_X <= 0;
        end case;      
                
        Case (Vcount - (60 * Grid_Y)) is 
            when 0 to 5 =>
                Image_Y <= 0;
            when 6 to 9 =>
                Image_Y <= 0;
            when 10 to 13 =>
                Image_Y <= 1;
            when 14 to 17 =>
                Image_Y <= 2;
            when 18 to 21 =>
                Image_Y <= 3;
            when 22 to 25 =>
                Image_Y <= 4;
            when 26 to 29 =>
                Image_Y <= 5;
            when 30 to 33 =>
                Image_Y <= 6;
            when 34 to 37 =>
                Image_Y <= 7;
            when 38 to 41 =>
                Image_Y <= 8;
            when 42 to 45 =>
                Image_Y <= 9;
            when 46 to 49 =>
                Image_Y <= 10;
            when 50 to 53 =>
                Image_Y <= 11;
            when 54 to 59 =>
                Image_Y <= 0;           
            when others =>
                Image_Y <= 0;
        end case; 
       

else
    Image_X <= 0;
    Image_Y <= 0;
end if;

end process;

end Behavioral;
