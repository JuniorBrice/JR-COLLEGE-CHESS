----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2023 01:08:23 PM
-- Design Name: 
-- Module Name: Pixel2Grid - Behavioral
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


--This module essentially monitors hcount and vcount and translates the current pixel
--to be renders into coordinates that our 8x8 grid can use to determine which icons go where.
--division is usually not recommended to be synthesized, but since we only need precision 
--up to a single integer (no decimals) it should cause us no issues here. Notice
--the inputs and outputs are integer types. 

entity Pixel2Grid is
        port(Grid_X :out integer range 0 to 7; 
             Grid_Y :out integer range 0 to 7;
			 Hcount :in integer range 0 to 640;
			 Vcount :in integer range 0 to 480);
end Pixel2Grid;

architecture Behavioral of Pixel2Grid is

begin

process (Hcount, Vcount) begin
    
    if(Hcount >= 80 AND Hcount <= 559 AND Vcount < 480)then
        
        Case (Hcount - 80) is 
            when 0 to 59 =>
                Grid_X <= 0;
            when 60 to 119 =>
                Grid_X <= 1;
            when 120 to 179 =>
                Grid_X <= 2;
            when 180 to 239 =>
                Grid_X <= 3;
            when 240 to 299 =>
                Grid_X <= 4;
            when 300 to 359 =>
                Grid_X <= 5;
            when 360 to 419 =>
                Grid_X <= 6;
            when 420 to 479 =>
                Grid_X <= 7; 
            when others =>
                Grid_X <= 0;
        end case;      
                
        Case (Vcount) is 
            when 0 to 59 =>
                Grid_Y <= 0;
            when 60 to 119 =>
                Grid_Y <= 1;
            when 120 to 179 =>
                Grid_Y <= 2;
            when 180 to 239 =>
                Grid_Y <= 3;
            when 240 to 299 =>
                Grid_Y <= 4;
            when 300 to 359 =>
                Grid_Y <= 5;
            when 360 to 419 =>
                Grid_Y <= 6;
            when 420 to 479 =>
                Grid_Y <= 7; 
            when others =>
                Grid_Y <= 0;
        end case;

    else
        Grid_X <= 0;
        Grid_Y <= 0;
    end if;
    
end process;

end Behavioral;
