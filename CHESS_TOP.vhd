----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2023 03:26:46 PM
-- Design Name: 
-- Module Name: CHESS_TOP - Behavioral
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

entity CHESS_TOP is
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
end CHESS_TOP;

architecture Behavioral of CHESS_TOP is

---GAME LOGIC GENERATOR COMPONENT--------------------------------
component CHESS_LOGIC is
  Port ( CLK        : in std_logic;
         Reset      : in std_logic;
         Sel        : in std_logic;
         x_position : in std_logic_vector (7 downto 0);
         y_position : in std_logic_vector (7 downto 0);         
         
--         Up_btn     : in std_logic;
--         Down_btn   : in std_logic;
--         Left_btn   : in std_logic;
--         Right_btn  : in std_logic;
         
         Grid_X     : in integer range 0 to 7;
         Grid_Y     : in integer range 0 to 7;
         
         Cur_piece  : out integer range -6 to 6;
         
         Sel_X      : out integer range 0 to 7;
         Sel_Y      : out integer range 0 to 7;
         
         Prev_X     : out integer range 0 to 7;
         Prev_Y     : out integer range 0 to 7;
         
         Piece_Selected : out std_logic    
  );
end component;

---GUI/GRAPHICS GENERATOR COMPONENT --------------------------------
component GUI is
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
end component;

---VGA OUTPUT GENERATOR COMPONENT---------------------------------
component VGA_top is
	port(	HS           : out std_logic;
	        VS           : out std_logic;
	        Vid          : out std_logic;
			hcount       : out integer range 0 to 640;
			vcount       : out integer range 0 to 480;
			CLK          : in std_logic);	
end component;

--DEBOUNCER---------------------------------------------------------
component debounce is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end component;

--JOYSTICK CONTROLLER---------------------------------------------
component pmod_joystick IS
  GENERIC(
    clk_freq        : INTEGER := 125); --system clock frequency in MHz
  PORT(
    clk             : IN     STD_LOGIC;                     --system clock
    reset_n         : IN     STD_LOGIC;                     --active low reset
    miso            : IN     STD_LOGIC;                     --SPI master in, slave out
    mosi            : OUT    STD_LOGIC;                     --SPI master out, slave in
    sclk            : BUFFER STD_LOGIC;                     --SPI clock
    cs_n            : OUT    STD_LOGIC;                     --pmod chip select
    x_position      : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0);  --joystick x-axis position
    y_position      : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0);  --joystick y-axis position
    trigger_button  : OUT    STD_LOGIC;                     --trigger button status
    center_button   : OUT    STD_LOGIC);                    --center button status
end component;

--Intermediates-------------------------------------------
signal Hcount   : INTEGER range 0 to 640;
signal Vcount   : INTEGER range 0 to 480;
signal Vid      : STD_LOGIC;
signal Piece_Sel: STD_LOGIC;
signal Sel_X    : INTEGER range 0 to 7;
signal Sel_Y    : INTEGER range 0 to 7;
signal Prev_X   : INTEGER range 0 to 7;
signal Prev_Y   : INTEGER range 0 to 7;
signal Piece    : INTEGER range -6 to 6;
signal Grid_X   : INTEGER range 0 to 7;
signal Grid_Y   : INTEGER range 0 to 7;

--button signals---------------------------------------------
signal dbnc_Reset : std_logic;
signal dbnc_Sel : std_logic;
--signal dbnc_Up : std_logic;
--signal dbnc_Down : std_logic;
--signal dbnc_Left : std_logic;
--signal dbnc_Right : std_logic;

--joystick
signal joy_x_position : std_logic_vector (7 downto 0);
signal joy_y_position : std_logic_vector (7 downto 0);

begin

U0: VGA_top port map(
        HS => VGA_HS,
        VS => VGA_VS,
        Vid => Vid,
        hcount => Hcount,
        vcount => Vcount,
        CLK => CLK);
        
U1: GUI port map(
         R => VGA_R,
         G => VGA_G,
         B => VGA_B,
         Grid_X => Grid_X,
         Grid_Y => Grid_Y,
         Hcount => Hcount,
         Vcount => Vcount,
         Vid => Vid,
         Piece_Selected => Piece_Sel,
         Sel_X => Sel_X,
         Sel_Y => Sel_Y,
         Prev_X => Prev_X,
         Prev_Y => Prev_Y,
         Piece => Piece);

U2: CHESS_LOGIC port map(
         CLK => CLK,
         Reset => dbnc_Reset,
         Sel => dbnc_Sel,
         x_position => joy_x_position,
         y_position => joy_y_position,
--         Up_btn => dbnc_Up,
--         Down_btn => dbnc_Down,
--         Left_btn => dbnc_Left,
--         Right_btn => dbnc_Right,
         Grid_X => Grid_X,
         Grid_Y => Grid_Y,     
         Cur_piece => Piece,
         Sel_X => Sel_X,
         Sel_Y => Sel_Y, 
         Prev_X => Prev_X, 
         Prev_Y => Prev_Y,        
         Piece_Selected => Piece_Sel   
  );
  
J0: pmod_joystick port map(

        clk => CLK,
        reset_n => not dbnc_Reset,
        miso => miso,
        mosi => mosi,
        sclk => sclk,
        cs_n => cs_n,
        x_position => joy_x_position,
        y_position => joy_y_position

);
  
D0: debounce port map(
       clk => CLK,
       btn => Reset,
       dbnc => dbnc_Reset );

D1: debounce port map(
       clk => CLK,
       btn => Sel,
       dbnc => dbnc_Sel );

--D2: debounce port map(
--       clk => CLK,
--       btn => Up_btn,
--       dbnc => dbnc_Up ); 

--D3: debounce port map(
--       clk => CLK,
--       btn => Down_btn,
--       dbnc => dbnc_down ); 

--D4: debounce port map(
--       clk => CLK,
--       btn => Left_btn,
--       dbnc => dbnc_Left ); 
   
--D5: debounce port map(
--       clk => CLK,
--       btn => Right_btn,
--       dbnc => dbnc_Right );   
       
end Behavioral;
