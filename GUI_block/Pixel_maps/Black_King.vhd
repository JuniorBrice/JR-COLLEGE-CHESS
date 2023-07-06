----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2023 01:00:07 AM
-- Design Name: 
-- Module Name: White_Bishop - Behavioral
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

entity Black_King is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end Black_King;

architecture Behavioral of Black_King is

type pix_map is array (0 to 11, 0 to 11) of std_logic_vector(15 downto 0);

constant piece_icon:pix_map :=
		(	(x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945"),
		    (x"2945",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"0000",x"0000",x"7BEF",x"7BEF",x"0000",x"0000",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"0000",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"0000",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"0000",x"0000",x"7BEF",x"7BEF",x"0000",x"0000",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"7BEF",x"0000",x"7BEF",x"7BEF",x"0000",x"7BEF",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"0000",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"0000",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"7BEF",x"0000",x"0000",x"2945"),
			(x"2945",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"2945"),
			(x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945",x"2945"));

begin

	R <= piece_icon(image_Y,image_X)(15 downto 11);
	G <= piece_icon(image_Y,image_X)(10 downto 5);
	B <= piece_icon(image_Y,image_X)(4 downto 0);

end Behavioral;
