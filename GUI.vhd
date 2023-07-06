----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2023 01:30:00 PM
-- Design Name: 
-- Module Name: GUI - Behavioral
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

entity GUI is
	port(R     : out STD_LOGIC_VECTOR(4 downto 0);
	     G     : out STD_LOGIC_VECTOR(5 downto 0);
	     B     : out STD_LOGIC_VECTOR(4 downto 0);
	     Grid_X: out INTEGER range 0 to 7;
	     Grid_Y: out INTEGER range 0 to 7;
	     Hcount: in INTEGER range 0 to 640;
	     Vcount: in INTEGER range 0 to 480;
	     Vid   : in STD_LOGIC;
	     Piece_Selected : in STD_LOGIC;
	     Sel_X : in INTEGER range 0 to 7;
	     Sel_Y : in INTEGER range 0 to 7;
	     Prev_X: in INTEGER range 0 to 7;
	     Prev_Y: in INTEGER range 0 to 7;
	     Piece : in INTEGER range -6 to 6);
end entity;

architecture Behavioral of GUI is

component Graphic_Icons is
    Port ( Piece : in INTEGER range -6 to 6;
           Image_Y : in INTEGER range 0 to 9;
           Image_X : in INTEGER range 0 to 9;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component Pixel2Grid is
    port(Grid_X : out integer range 0 to 7; 
         Grid_Y : out integer range 0 to 7;
         Hcount : in integer range 0 to 640;
         Vcount : in integer range 0 to 480);
end component;

component Pixel2Graphics is
    port(Image_X : out integer range 0 to 9; 
         Image_Y : out integer range 0 to 9; 
         Grid_X  : in integer range 0 to 7; 
         Grid_Y  : in integer range 0 to 7; 
         Hcount  : in integer range 0 to 640;
         Vcount  : in integer range 0 to 480);
end component;
	
signal Grid_X_reg   : integer range 0 to 7;
signal Grid_Y_reg   : integer range 0 to 7;
signal R_reg        : std_logic_vector(4 downto 0);
signal G_reg        : std_logic_vector(5 downto 0);
signal B_reg        : std_logic_vector(4 downto 0);
signal Image_X_reg  : integer range 0 to 9;
signal Image_Y_reg  : integer range 0 to 9;

begin

U0: Pixel2Grid port map(   --Takes in Hcount and Vcount and translates them into the 8x8 checker board based on pixel location.
     Grid_X => Grid_X_reg,
     Grid_Y => Grid_Y_reg,
     Hcount => Hcount,
     Vcount => Vcount);
     
U1: Pixel2Graphics port map( --Takes in Hcount, Vcount, and the grid numbers (fromm Pixel2grid) to return Icon x and y pixel coordinates
     Image_X => Image_X_reg, 
     Image_Y => Image_Y_reg,
     Grid_X  => Grid_X_reg,
     Grid_Y  => Grid_Y_reg, 
     Hcount  => Hcount,
     Vcount  => Vcount);
     
U3: Graphic_Icons port map( --Takes in the X and Y pixel coordinates (from pixel2graphics) and returns the RGB value for that piece at that
     Piece => Piece,        --coordinate.
     Image_Y => Image_Y_reg,
     Image_X => Image_X_reg,
     R => R_reg,
     G => G_reg,
     B => B_reg);

Grid_X <= Grid_X_reg;
Grid_Y <= Grid_Y_reg;

process(Vid, Hcount, Vcount, Sel_X, Sel_Y, Prev_X, Prev_Y, Piece_Selected, Piece,
        R_reg, B_reg ,G_reg)
begin

	if(Vid = '1') then
		if(Hcount < 79 OR Hcount > 560) then --This will print a dark blue around the game instead of just leaving it black,
		                                     --since the board will be centered and the left and right would otherwise be black.
		
				R <= "01000";				
				G <= "010110";
				B <= "01101";
				
		elsif(Hcount = 79 OR Hcount = 80 OR Hcount = 139 OR Hcount = 140 OR Hcount = 199 OR Hcount = 200 OR Hcount = 259 
		                                                                                --This will print the brown outline of the board,
		                                                                                --to simulate and actual chess board color scheme.
		                                                                                --the net color pallete of the board will be brown,
		                                                                                --beige, and dark green.
			OR Hcount = 260 OR Hcount = 319 OR Hcount = 320 OR Hcount = 379 OR Hcount = 380 OR Hcount = 439
			OR Hcount = 440 OR Hcount = 499 OR Hcount = 500 OR Hcount = 559 OR Hcount = 560
			OR Vcount = 0 OR Vcount = 1 OR Vcount = 59 OR Vcount = 60 OR Vcount = 119 OR Vcount = 120 OR Vcount = 179 
			OR Vcount = 180 OR Vcount = 239 OR Vcount = 240 OR Vcount = 299 OR Vcount = 300 OR Vcount = 359
			OR Vcount = 360 OR Vcount = 419 OR Vcount = 420 OR Vcount = 479 OR Vcount = 480) then
				
				R <= "11001";
				G <= "100010";
				B <= "01011";
				
		elsif((Piece /= 0) AND ((Hcount > 85 AND Hcount < 134) OR (Hcount > 145 AND Hcount < 194) OR (Hcount > 205 AND Hcount < 254)
		                                                                    --Will print a piece when the piece value is not zero.
		                                                                    --zero means no piece present. Will also print the piece
		                                                                    --in the proper boundaries.
                OR (Hcount > 265 AND Hcount < 314) OR (Hcount > 325 AND Hcount < 374) OR (Hcount > 385 AND Hcount < 434)
                OR (Hcount > 445 AND Hcount < 494) OR (Hcount > 505 AND Hcount < 554)) 
                AND((Vcount > 5 AND Vcount < 54) OR (Vcount > 65 AND Vcount < 114) OR (Vcount > 125 AND Vcount < 174) 
                OR (Vcount > 185 AND Vcount < 234) OR (Vcount > 245 AND Vcount < 294) OR (Vcount > 305 AND Vcount < 354)
                OR (Vcount > 365 AND Vcount < 414) OR (Vcount > 425 AND Vcount < 474))) then
				
				R <= R_reg;
				G <= G_reg;
				B <= B_reg;
				
		elsif(Hcount > (80 + Sel_X * 60) AND Hcount <(80 + (Sel_X + 1) * 60) AND Vcount > (Sel_Y * 60) AND Vcount < ((Sel_Y + 1) * 60))then
				                                                                --This dictates the color of the select cursor. Notice
				                                                                --how it is dependent on Sel_X and Sel_Y. I have it set to
				                                                                --a relaxed blue.                                                         
				R <= "10001";
				G <= "101100";
				B <= "11000";
				
		elsif((Hcount > (80 + Prev_X * 60) AND Hcount <(80 + (Prev_X + 1) * 60) AND Vcount > (Prev_Y*60) 
		                  AND Vcount < ((Prev_Y + 1) * 60)) AND Piece_Selected = '1') then
				                                                                --This dictates the outline color of a selected piece. Notice
				                                                                --how it is dependent on Prev_X and Prev_Y. I have it set to
				                                                                --a coffee (dark brown) color.

                        R <= "01101";
                        G <= "010010";
                        B <= "00110";	

		elsif((((Hcount - 80) mod 120 < 60) AND (Vcount mod 120 < 60)) OR (((Hcount - 80) mod 120 >= 60) 
		          AND (Vcount mod 120 >= 60)))then                               --this will generate the beige squares mentioned
		                                                                         --earlier. These are the light squares.
				
				R <= "11110";
				G <= "111011";
				B <= "11001";
				
		else																     --this will generate the dark green squares mentioned
		                                                                         --earlier. These are the dark squares.
				R <= "01010";
				G <= "011010";
				B <= "00101";
				
		end if;
		
	else											--this will generate black when not displaying anything else as a failsafe.
	
		R <= "00000";
		G <= "000000";
		B <= "00000";
		
	end if;
end process;
end Behavioral;