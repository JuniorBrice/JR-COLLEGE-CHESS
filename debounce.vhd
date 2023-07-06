----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2023 05:29:04 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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
use IEEE.numeric_std.ALL;

entity debounce is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is

signal shift_reg : std_logic_vector(1 downto 0) := (others => '0');
signal counter : std_logic_vector(22 downto 0) := (others => '0');

begin
   
    process(clk)
    begin
    
        if rising_edge(clk) then
        
            shift_reg(1) <= shift_reg(0);
            shift_reg(0) <= btn;
            
                if (unsigned(counter) = 2500000 AND shift_reg(1) = '1') then
                        
                        counter <= counter;
                    
                    elsif (shift_reg(1) = '1') then
                    
                        counter <= std_logic_vector(unsigned(counter) + 1);
                    
                    else
                        
                        counter <= (others => '0');                     
                    
                end if;
                
                if (unsigned(counter) = 2500000) then
                
                        dbnc <= '1';
                    
                    else 
                
                        dbnc <= '0';
                        
                end if;
         
         end if;
     
    end process;

end Behavioral;
