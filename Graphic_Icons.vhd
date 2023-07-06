----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2023 02:48:36 AM
-- Design Name: 
-- Module Name: Graphic_Icons - Behavioral
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

entity Graphic_Icons is
    Port ( Piece : in INTEGER range -6 to 6;
           Image_Y : in INTEGER range 0 to 11;
           Image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end Graphic_Icons;

architecture Behavioral of Graphic_Icons is

--Pixels from memory block made for WHITE ROOK
component White_Rook is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for WHITE QUEEN
component White_Queen is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for WHITE PAWN
component White_Pawn is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for WHITE KNIGHT
component White_Knight is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for WHITE KING
component White_King is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for WHITE BISHOP
component White_Bishop is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for BLACK BISHOP	
component Black_Bishop is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for BLACK KING
component Black_King is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for BLACK KNIGHT
component Black_Knight is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for BLACK PAWN
component Black_Pawn is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for BLACK QUEEN	
component Black_Queen is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Pixels from memory block made for BLACK ROOK	
component Black_Rook is
    Port ( image_Y : in INTEGER range 0 to 11;
           image_X : in INTEGER range 0 to 11;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0));
end component;

--Color signals for each individual piece are found below.
signal R_white_rook, R_white_queen, R_white_pawn, R_white_knight,
        R_white_king, R_white_bishop : std_logic_vector (4 downto 0);

signal G_white_rook, G_white_queen, G_white_pawn, G_white_knight,
        G_white_king, G_white_bishop : std_logic_vector (5 downto 0);
        
signal B_white_rook, B_white_queen, B_white_pawn, B_white_knight,
        B_white_king, B_white_bishop : std_logic_vector (4 downto 0);

signal R_black_rook, R_black_queen, R_black_pawn, R_black_knight,
        R_black_king, R_black_bishop : std_logic_vector (4 downto 0);

signal G_black_rook, G_black_queen, G_black_pawn, G_black_knight,
        G_black_king, G_black_bishop : std_logic_vector (5 downto 0);
        
signal B_black_rook, B_black_queen, B_black_pawn, B_black_knight,
        B_black_king, B_black_bishop : std_logic_vector (4 downto 0);

begin

--instantiating pixel maps and passing RGB values.
B1: Black_King port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_black_king,
           G => G_black_king,
           B => B_black_king);

B2: Black_Queen port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_black_queen,
           G => G_black_queen,
           B => B_black_queen);
           
B3: Black_Bishop port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_black_bishop,
           G => G_black_bishop,
           B => B_black_bishop); 
           
B4: Black_Knight port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_black_knight,
           G => G_black_knight,
           B => B_black_knight);
           
B5: Black_Rook port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_black_rook,
           G => G_black_rook,
           B => B_black_rook);
           
B6: Black_Pawn port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_black_pawn,
           G => G_black_pawn,
           B => B_black_pawn);
           
W1: White_King port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_white_king,
           G => G_white_king,
           B => B_white_king);
           
W2: White_Queen port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_white_queen,
           G => G_white_queen,
           B => B_white_queen);
           
W3: White_Bishop port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_white_bishop,
           G => G_white_bishop,
           B => B_white_bishop);
           
W4: White_Knight port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_white_knight,
           G => G_white_knight,
           B => B_white_knight);
 
W5: White_Rook port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_white_rook,
           G => G_white_rook,
           B => B_white_rook);

W6: White_Pawn port map(
           image_Y => Image_Y,
           image_X => Image_X,
           R => R_white_pawn,
           G => G_white_pawn,
           B => B_white_pawn);

--Process block determining which RGB values from which pixel map to send out
process(Image_X, Image_Y, Piece)
begin
    
    Case(Piece) is
        when -1 =>
			R <= R_black_king;
			G <= G_black_king;
			B <= B_black_king;
		when -2 =>
			R <= R_black_queen;
			G <= G_black_queen;
			B <= B_black_queen;
		when -3 =>
			R <= R_black_bishop;
			G <= G_black_bishop;
			B <= B_black_bishop;
		when -4 =>
			R <= R_black_knight;
			G <= G_black_knight;
			B <= B_black_knight;
		when -5 =>
			R <= R_black_rook;
			G <= G_black_rook;
			B <= B_black_rook;
		when -6 =>
			R <= R_black_pawn;
			G <= G_black_pawn;
			B <= B_black_pawn;
		when 1 =>
			R <= R_white_king;
			G <= G_white_king;
			B <= B_white_king;
		when 2 =>
			R <= R_white_queen;
			G <= G_white_queen;
			B <= B_white_queen;
		when 3 =>
			R <= R_white_bishop;
			G <= G_white_bishop;
			B <= B_white_bishop;
		when 4 =>
			R <= R_white_knight;
			G <= G_white_knight;
			B <= B_white_knight;
		when 5 =>
			R <= R_white_rook;
			G <= G_white_rook;
			B <= B_white_rook;
		when 6 =>
			R <= R_white_pawn;
			G <= G_white_pawn;
			B <= B_white_pawn;
		when others =>
		  --when there is no match, we'll send a purple block. 
			R <= "11111";
			G <= "000000";
			B <= "11111";
    end case;

end process;
            
end Behavioral;

