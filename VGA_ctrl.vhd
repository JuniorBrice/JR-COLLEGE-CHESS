----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2023 08:27:40 PM
-- Design Name: 
-- Module Name: vga_ctrl - Behavioral
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

entity VGA_ctrl is
    Port ( CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           hcount : out INTEGER range 0 to 640;
           vcount : out INTEGER range 0 to 480;
           vid : out STD_LOGIC;
           hs : out STD_LOGIC;
           vs : out STD_LOGIC);
end VGA_ctrl;

architecture Behavioral of VGA_ctrl is

signal hcount_reg: STD_LOGIC_VECTOR (9 downto 0):= (others => '0');
signal vcount_reg: STD_LOGIC_VECTOR (9 downto 0):= (others => '0');

begin

--main process block that only activates on rising clk edge and enable
process(CLK) begin
    if (rising_edge(CLK) AND EN = '1') then 

--Hcount and Vcount control, Hcount counts to 799 then resets to 0,
--Vcount counts to 524 then resets to 0. but only when hcount has reset
        if (unsigned(hcount_reg) = 799) then
        
            hcount_reg <= (others => '0');
            
        else
            
            hcount_reg <= std_logic_vector(unsigned(hcount_reg) + 1);
            
        end if;
        
        if (unsigned(hcount_reg) = 798) then
            
            if (unsigned(vcount_reg) = 524) then
            
                vcount_reg <= (others => '0');

            else
            
                vcount_reg <= std_logic_vector(unsigned(vcount_reg) + 1);               
                               
            end if;
            
        end if;
        
    end if;
   
--HS control, monitors Hcount     
    if (rising_edge(CLK) AND EN = '1') then 

        if (unsigned(hcount_reg) >= 656 AND unsigned(hcount_reg) <= 751) then
        
            HS <= '0';
        
        else
            
            HS <= '1';
            
        end if;
        
--VS control, monitors Vcount
        if (unsigned(vcount_reg) >= 490 AND unsigned(vcount_reg) <= 491) then
        
            VS <= '0';
        
        else
            
            VS <= '1';
            
        end if;
        
--Display Vid signal Control
        if ( (unsigned(hcount_reg) = 799 OR unsigned(hcount_reg) <= 639)
                AND (unsigned(vcount_reg) = 524 OR unsigned(vcount_reg) <= 479)
                ) then    
            vid <= '1';     
        else
            vid <= '0';
        end if;    
        
       if ((unsigned(hcount_reg) > 639)
                ) then  
              hcount <= 640;
       else
              hcount <= to_integer(unsigned(hcount_reg));
       end if;
       
       if ((unsigned(vcount_reg) > 479)
                ) then  
              vcount <= 480;
       else
              vcount <= to_integer(unsigned(vcount_reg));
       end if;
        
    end if;

end process;

end Behavioral;
