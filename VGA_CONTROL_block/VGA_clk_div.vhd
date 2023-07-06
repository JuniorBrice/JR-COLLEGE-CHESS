----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2023 07:59:18 PM
-- Design Name: 
-- Module Name: clock_div - Behavioral
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
use ieee.numeric_std.all;

entity VGA_clock_div is
    Port ( clk : in STD_LOGIC;
           div : out STD_LOGIC);
end VGA_clock_div;

architecture Behavioral of VGA_clock_div is

signal counter : std_logic_vector(26 downto 0) := (others => '0');


--This module is our VGA enable. It needs to operate at exactly 25MHz. 
--It takes in a 125MHz clock from the zybo and divides it down to a 25MHz Hz pulse signal
--that is used to update moves on a somewhat human timeframe.
begin

    process(clk)
    begin
    
        if rising_edge(clk) then
        
                if (unsigned(counter) < 4) then
                        counter <= std_logic_vector(unsigned(counter) + 1);
                    
                    else
                        counter <= (others => '0');
                    
                end if;

               if (unsigned(counter) = 4) then
                        div <= '1';
                        
                    else
                        div <= '0'; 
                        
               end if;
         
         end if;
     
    end process;

end Behavioral;
