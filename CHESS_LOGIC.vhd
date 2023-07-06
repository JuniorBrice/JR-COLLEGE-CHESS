----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2023 10:03:30 PM
-- Design Name: 
-- Module Name: CHESS_LOGIC - Behavioral
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

--Entity declartion---------------------------------------------------------------------------------------
entity CHESS_LOGIC is
  Port ( CLK        : in std_logic; --input CLK
         Reset      : in std_logic; --resets board
         Sel        : in std_logic; --selects current cursor location
         x_position : in std_logic_vector (7 downto 0);
         y_position : in std_logic_vector (7 downto 0);
--         Up_btn     : in std_logic; --moves cursor up
--         Down_btn   : in std_logic; --moves cursor down
--         Left_btn   : in std_logic; --moves cursor left
--         Right_btn  : in std_logic; --moves cursor right
         
         Grid_X     : in integer range 0 to 7; --determined value from hcount that helps display current board layout
         Grid_Y     : in integer range 0 to 7; --determined value from vcount that helps display current board layout
         
         Cur_piece  : out integer range -6 to 6; --outputs the current chess piece that needs to be dispalyed in accordance to 
                                                 --Grid_X and Grid_Y. The Negative numbers are the green pieces and positive is white
         
         Sel_X      : out integer range 0 to 7; --tells the graphics module the current x coordinate of the cursor (8x8 Grid)
         Sel_Y      : out integer range 0 to 7; --tells the graphics module the current y coordinate of the cursor (8x8 Grid)
         
         Prev_X     : out integer range 0 to 7; --tells the graphics module the x coordinate of the currently selected piece
         Prev_Y     : out integer range 0 to 7; --tells the graphics module the y coordinate of the currently selected piece 
         
         Piece_Selected : out std_logic --tells the graphics module when a piece has been selected to be moved.
      
  );
end CHESS_LOGIC;


--Architacture/component/register definitition------------------------------------------------------
architecture Behavioral of CHESS_LOGIC is

component CHESS_clock_div is    --Generates our move clock. Takes the 125 MHz zybo clock and divides it to 5Hz
    Port ( clk : in STD_LOGIC;
           div : out STD_LOGIC);
end component;

type ChessGrid is array(0 to 7, 0 to 7) of integer range -6 to 6; --defines our chess board size as an 8x8 array, 
                                                                  --and able to be populated with numbers -6 to 6
signal board        : ChessGrid; --initializes our playing board.
signal Piece_Selreg : std_logic := '0'; --intermediate signal for Piece_Selected
signal Sel_Xreg     : integer range 0 to 7 := 0; --intermediate signal for Sel_X
signal Sel_Yreg     : integer range 0 to 7 := 7; --intermediate signal for Sel_Y
signal Prev_Xreg    : integer range 0 to 7 := 0; --intermediate signal for Prev_X
signal Prev_Yreg    : integer range 0 to 7 := 7; --intermediate signal for Prev_Y


signal temp_piece   : integer range -6 to 6; --temporary signal used for identififying pieces suring game logic calculation

signal move_clk     :std_logic; --our 5hz divided move clock.
signal joy_moved  : std_logic := '0'; --signal that tells us that the joy stick has been moved, and must be released before the next btn signal is evaluated

--Game Logic Begins below----------------------------------------------------------------------------------- 
begin

--BEGIN-- passing register values to outputs --BEGIN--
Sel_X <= Sel_Xreg;
Sel_Y <= Sel_Yreg;
Prev_X <= Prev_Xreg;
Prev_Y <= Prev_Yreg;
Cur_piece <= board(Grid_Y,Grid_X);

Piece_Selected <= Piece_Selreg;
--END-- passing register values to outputs --END--


U0: CHESS_clock_div port map(
    clk => CLK,
    div => move_clk);

--BEGIN-- button press logic --BEGIN--
Process(move_clk)begin

if (Reset = '1') then

    Sel_Yreg <= 7;
    Sel_Xreg <= 0;
    joy_moved <= '0';

else
	if(rising_edge(move_clk)) then
        
        if (joy_moved = '1') then
        
            if (unsigned(x_position) > 160 OR unsigned(y_position) > 160 OR unsigned(x_position) < 96 OR unsigned(y_position) < 96) then
                joy_moved <= '1';
            
            else            
                joy_moved <= '0';
            
            end if;
        
        else
            
            if (unsigned(x_position) > 160 AND unsigned(y_position) > 160)then
                Sel_Yreg <= Sel_Yreg - 1;
                Sel_Xreg <= Sel_Xreg + 1;
                joy_moved <= '1';
            
            elsif (unsigned(x_position) < 96 AND unsigned(y_position) > 160)then
                Sel_Yreg <= Sel_Yreg + 1;
                Sel_Xreg <= Sel_Xreg + 1;
                joy_moved <= '1';                
                
            elsif (unsigned(x_position) < 96 AND unsigned(y_position) < 96)then
                Sel_Yreg <= Sel_Yreg + 1;
                Sel_Xreg <= Sel_Xreg - 1;
                joy_moved <= '1'; 

            elsif (unsigned(x_position) > 160 AND unsigned(y_position) < 96)then
                Sel_Yreg <= Sel_Yreg - 1;
                Sel_Xreg <= Sel_Xreg - 1;
                joy_moved <= '1'; 
                
            elsif(unsigned(y_position) > 160) then
                Sel_Xreg <= Sel_Xreg + 1;
                joy_moved <= '1';
                
            elsif(unsigned(y_position) < 96) then
                Sel_Xreg<= Sel_Xreg - 1;
                joy_moved <= '1';
                
            elsif(unsigned(x_position) < 96) then
                Sel_Yreg <= Sel_Yreg + 1;
                joy_moved <= '1';
                
            elsif(unsigned(x_position) > 160) then
                Sel_Yreg <= Sel_Yreg - 1;
                joy_moved <= '1';
                
            else
                Sel_Xreg <= Sel_Xreg;
                Sel_Yreg <= Sel_Yreg;
                
            end if;        
		end if;
	end if;
end if;
end process;
--END-- button press logic --END--

--BEGIN-- MAIN GAME PIECE MOVEMENT LOGIC --BEGIN--------------------------------------------------

process(Sel_Xreg, Sel_Yreg, Sel, board, temp_piece, reset, move_clk) 
variable distance: integer range 0 to 7;--position variable used for calculations
begin 

    if Reset = '1' then
            Board <= ((-5,-4,-3,-2,-1,-3,-4,-5),    --This is the board we will be modifying!
                      (-6,-6,-6,-6,-6,-6,-6,-6),    --The negative numbers are the dark pieces,
                      (0,0,0,0,0,0,0,0),            --and the positive are the white pieces.
                      (0,0,0,0,0,0,0,0),            -- 6 is PAWN
                      (0,0,0,0,0,0,0,0),            -- 5 is ROOK
                      (0,0,0,0,0,0,0,0),            -- 4 is KNIGHT
                      (6,6,6,6,6,6,6,6),            -- 3 is BISHOP
                      (5,4,3,2,1,3,4,5));           -- 2 is QUEEN
                                                    -- 1 is KING
                                                    -- 0 is EMPTY
                                                    
            Piece_Selreg <= '0'; --if reset, no piece will be selected.

            Prev_Xreg <= 0;
            Prev_Yreg <= 7;
 
        elsif(rising_edge(Sel))then
        
                if(Piece_Selreg = '0') then       --if no piece is selected and sel is pressed, select that piece!
                
                        temp_piece <= board(Sel_Yreg, Sel_Xreg); -- sends piece number into a temporary register
                        Prev_Yreg <= Sel_Yreg;  --registers the piece's current y location.
                        Prev_Xreg <= Sel_Xreg;  --registers the piece's current x location.
                        Board(Sel_Yreg,Sel_Xreg) <= 0;  --empties the space in which the piece inhabited.
                        Piece_Selreg <= '1';            --enters select mode, i.e. a piece has been selected to be moved.
                        
                else
                
                        if(temp_piece = 0) then --if an empty spot was selected, disable select mode on next button press.
                        
					                       Piece_Selreg <= '0';
					                       
			            elsif(Sel_Xreg = Prev_Xreg and Sel_Yreg = Prev_Yreg) then --The game will always allow places a piece back where it came.
			            
                                            board(Sel_Yreg, Sel_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                        
--WHITE PIECES-------------------------------------------------------------------------------------------------------------------------------
                        --BEGIN WHITE BISHOP MOVEMENT DEFINITION--
                        elsif(temp_piece = 3)then
                        
                                        if(((Prev_Yreg - Sel_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg > Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 1
                                            
                                                if(board(Sel_Yreg,Sel_Xreg) <= 0) then --white bishop can only capture black pieces, or move to an empty spot.
                                                    board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                    Piece_Selreg <= '0';
                                                    temp_piece <= 0;
                                               
                                                elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                                    board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                    Piece_Selreg <= '0';
                                                    temp_piece <= 0;

                                                end if;

                                        elsif(((Prev_Yreg - Sel_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg < Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 2
                                                                                       
                                                if(board(Sel_Yreg, Sel_Xreg) <= 0) then --white bishop can only capture black pieces, or move to an empty spot.
                                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then      --if a white piece is selected for capture, do nothing and exit select mode.
                                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                end if;
                                
                                        elsif(((Sel_Yreg - Prev_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg < Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 3
                                                
                                                if(board(Sel_Yreg, Sel_Xreg) <= 0) then --white bishop can only capture black pieces, or move to an empty spot.
                                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then      --if a white piece is selected for capture, do nothing and exit select mode.
                                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                end if;
                                
                                        elsif(((Sel_Yreg - Prev_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg > Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 4
                                               
                                                if(board(Sel_Yreg, Sel_Xreg) <= 0) then --white bishop can only capture black pieces, or move to an empty spot.
                                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then      --if a white piece is selected for capture, do nothing and exit select mode.
                                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                end if;
                                                
                                        else
                                                --if an invalid space is selected, do nothing and exit select mode.
                                                board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                       
                            end if;              
                        --END WHITE BISHOP MOVEMENT DEFINITION--
                        
                        --BEGIN WHITE KING MOVEMENT DEFINITION--
			            elsif(temp_piece = 1) then
			             
                                    if((board(Prev_Yreg+1, Prev_Xreg+1) <= 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg+1) or --checks if selected square to the bottom right of the KING is availble and not
                                                                                                                                    --occupied by a white piece.    
                                        (board(Prev_Yreg+1, Prev_Xreg) <= 0 and Sel_Xreg=Prev_Xreg and Sel_Yreg = Prev_Yreg+1) or     --checks if selected square to the bottom of the KING is availble and not
                                                                                                                                    --occupied by a white piece.
                                        (board(Prev_Yreg+1, Prev_Xreg-1) <= 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg+1) or --so on and so forth, for every square around the king.
                                        (board(Prev_Yreg, Prev_Xreg+1) <= 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg) or
                                        (board(Prev_Yreg, Prev_Xreg) <= 0 and Sel_Xreg=Prev_Xreg and Sel_Yreg = Prev_Yreg) or
                                        (board(Prev_Yreg, Prev_Xreg-1) <= 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg) or
                                        (board(Prev_Yreg, Prev_Xreg+1) <= 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-1, Prev_Xreg) <= 0 and Sel_Xreg=Prev_Xreg and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-1, Prev_Xreg-1) <= 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg-1)) then
                                                
                                                board(Sel_Yreg, Sel_Xreg) <= temp_piece; --if any of these conditions are true, it is okay to move the white king to that corresponding square.
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                    else
                                             board(Prev_Yreg, Prev_Xreg) <= temp_piece; --if no condition is satisfied, change nothing exit select mode.
                                             Piece_Selreg <= '0';
                                             temp_piece <= 0;
                                                
                                    end if;
			            --END WHITE KING MOVEMENT DEFINITION--
                        
                        --BEGIN WHITE KNIGHT MOVEMENT DEFINITION--
			            elsif(temp_piece = 4) then
                                    if((board(Prev_Yreg+2,Prev_Xreg+1) <=0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg+2) or --checks if selected square to the bottom right of the KNIGHT is availble and not
                                                                                                                                    --occupied by a white piece.
                                        (board(Prev_Yreg+2,Prev_Xreg-1) <=0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg+2) or--checks if selected square to the bottom left of the KNIGHT is availble and not
                                                                                                                                    --occupied by a white piece.
                                        (board(Prev_Yreg+1,Prev_Xreg+2) <=0 and Sel_Xreg=Prev_Xreg+2 and Sel_Yreg = Prev_Yreg+1) or --so on and so forth, for every L movement pattern around the knight.
                                        (board(Prev_Yreg+1,Prev_Xreg-2) <=0 and Sel_Xreg=Prev_Xreg-2 and Sel_Yreg = Prev_Yreg+1) or
                                        (board(Prev_Yreg-1,Prev_Xreg+2) <=0 and Sel_Xreg=Prev_Xreg+2 and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-1,Prev_Xreg-2) <=0 and Sel_Xreg=Prev_Xreg-2 and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-2,Prev_Xreg+1) <=0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg-2) or
                                        (board(Prev_Yreg-2,Prev_Xreg-1) <=0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg-2)) then
                                        
                                                board(Sel_Yreg,Sel_Xreg) <= temp_piece; --if any of these conditions are true, it is okay to move the white KNIGHT to that corresponding square.
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                    else
                                                board(Prev_Yreg, Prev_Xreg) <= temp_piece; --if no condition is satisfied, change nothing exit select mode.
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                    end if;
                        --END WHITE KNIGHT MOVEMENT DEFINITION--
                        
                        --BEGIN WHITE PAWN MOVEMENT DEFINITION--
                        elsif(temp_piece = 6) then
                            
                            if((board(Prev_Yreg-1,Prev_Xreg+1) < 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg-1) or --mechanism for capturing pieces diagonally.
                                (Board(Prev_Yreg-1,Prev_Xreg-1) < 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg-1)) then
                                        if(Sel_Yreg = 0) then
                                            board(Sel_Yreg,Sel_Xreg) <= 2; --if diagonal capture occurs on the 8th rank, promote pawn to queen.
                                        else
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece; --else, just capture.
                                        end if;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            elsif(Sel_Xreg = Prev_Xreg and board(Prev_Yreg-1,Prev_Xreg) = 0 and Sel_Yreg = Prev_Yreg-1) then --mechanism for forward progression
                                        if(Sel_Yreg = 0) then
                                            board(Sel_Yreg,Sel_Xreg) <= 2; --if forward progression occurs on the 8th rank, promote pawn to queen.
                                        else
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece; --else, just progress
                                        end if;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            elsif(Sel_Xreg = Prev_Xreg and board(Prev_Yreg-1,Prev_Xreg) = 0 and board(Prev_Yreg-2,Prev_Xreg) = 0 and Sel_Yreg = Prev_Yreg-2 and Prev_Yreg = 6) then --mechanism for inital 2
                                                                                                                                                                                    --space pawn progression.
                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            else
                                        board(Prev_Yreg, Prev_Xreg) <= temp_piece; --if no condition is satisfied, change nothing exit select mode.
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            end if;
                        --END WHITE PAWN MOVEMENT DEFINITION--
                        
                        --BEGIN WHITE QUEEN MOVEMENT DEFINITION--
                        elsif(temp_piece = 2) then
                            if((Prev_Xreg = Sel_Xreg) and Prev_Yreg > Sel_Yreg) then --rook like movement, in the upwards direction.

                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                    
                            elsif((Prev_Xreg = Sel_Xreg) and Prev_Yreg < Sel_Yreg) then --rook like movement, in the downwards direction.                           
                                
                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg > Sel_Xreg) then --rook like movement, in the left direction.
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg < Sel_Xreg) then --rook like movement, in the right direction.
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif(((Prev_Yreg - Sel_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg > Prev_Xreg) then --bishop like movement, toward quadrant 1
                                
                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                   
                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;

                            elsif(((Prev_Yreg - Sel_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg < Prev_Xreg) then --bishop like movement, toward quadrant 2
                                                                           
                                    if(board(Sel_Yreg, Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then      --if a white piece is selected for capture, do nothing and exit select mode.
                                            board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    end if;
                    
                            elsif(((Sel_Yreg - Prev_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg < Prev_Xreg) then --bishop like movement, toward quadrant 3
                                    
                                    if(board(Sel_Yreg, Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then      --if a white piece is selected for capture, do nothing and exit select mode.
                                            board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    end if;
                    
                            elsif(((Sel_Yreg - Prev_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg > Prev_Xreg) then --bishop like movement, toward quadrant 4
                                   
                                    if(board(Sel_Yreg, Sel_Xreg) <= 0) then --queen may only capture or move to a square not inhabited by another white piece
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then      --if a white piece is selected for capture, do nothing and exit select mode.
                                            board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    end if;
                                    
                            else
                                    --if an invalid space is selected, do nothing and exit select mode.
                                    board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                    Piece_Selreg <= '0';
                                    temp_piece <= 0;   
                            end if;
                        --END WHITE QUEEN MOVEMENT DEFINITION--
                        
                        --BEGIN WHITE ROOK MOVEMENT DEFINITION--
                        elsif(temp_piece = 5) then
                            if((Prev_Xreg = Sel_Xreg) and Prev_Yreg > Sel_Yreg) then --forces rook into upwards motion

                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --rook may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                    
                            elsif((Prev_Xreg = Sel_Xreg) and Prev_Yreg < Sel_Yreg) then --forces rook into downwards motion                           
                                
                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --rook may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg > Sel_Xreg) then --forces rook into left motion
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --rook may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg < Sel_Xreg) then --forces rook into right motion
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) <= 0) then --rook may only capture or move to a square not inhabited by another white piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) >= 1) then --if a white piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                            else
                            
                                    --if an invalid space is selected, do nothing and exit select mode.
                                    board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                    Piece_Selreg <= '0';
                                    temp_piece <= 0; 
                            end if;
                        --END WHITE ROOK MOVEMENT DEFINITION--
                        
--BLACK PIECES-------------------------------------------------------------------------------------------------------------------------------                     
                        --BEGIN BLACK BISHOP MOVEMENT DEFINITION--
                        elsif(temp_piece = -3)then
                        
                                        if(((Prev_Yreg - Sel_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg > Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 1
                                            
                                                if(board(Sel_Yreg,Sel_Xreg) >= 0) then --black bishop can only capture white pieces, or move to an empty spot.
                                                    board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                    Piece_Selreg <= '0';
                                                    temp_piece <= 0;
                                               
                                                elsif(board(Sel_Yreg, Sel_Xreg) <= 1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                                    board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                    Piece_Selreg <= '0';
                                                    temp_piece <= 0;

                                                end if;

                                        elsif(((Prev_Yreg - Sel_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg < Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 2
                                                                                       
                                                if(board(Sel_Yreg, Sel_Xreg) >= 0) then --black bishop can only capture white pieces, or move to an empty spot.
                                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                elsif(board(Sel_Yreg, Sel_Xreg) <= 1) then      --if a black piece is selected for capture, do nothing and exit select mode.
                                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                end if;
                                
                                        elsif(((Sel_Yreg - Prev_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg < Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 3
                                                
                                                if(board(Sel_Yreg, Sel_Xreg) >= 0) then --black bishop can only capture white pieces, or move to an empty spot.
                                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                elsif(board(Sel_Yreg, Sel_Xreg) <= 1) then      --if a black piece is selected for capture, do nothing and exit select mode.
                                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                end if;
                                
                                        elsif(((Sel_Yreg - Prev_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg > Prev_Xreg) then --Forces bishop movement to diagonal only in Quadrant 4
                                               
                                                if(board(Sel_Yreg, Sel_Xreg) >= 0) then --black bishop can only capture white pieces, or move to an empty spot.
                                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                elsif(board(Sel_Yreg, Sel_Xreg) <= 1) then      --if a black piece is selected for capture, do nothing and exit select mode.
                                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                        Piece_Selreg <= '0';
                                                        temp_piece <= 0;
                                                    
                                                end if;
                                                
                                        else
                                                --if an invalid space is selected, do nothing and exit select mode.
                                                board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                       
                            end if;              
                        --END BLACK BISHOP MOVEMENT DEFINITION--
                        
                        --BEGIN BLACK KING MOVEMENT DEFINITION--
			            elsif(temp_piece = -1) then
			             
                                    if((board(Prev_Yreg+1, Prev_Xreg+1) >= 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg+1) or --checks if selected square to the bottom right of the KING is availble and not
                                                                                                                                    --occupied by a black piece.    
                                        (board(Prev_Yreg+1, Prev_Xreg) >= 0 and Sel_Xreg=Prev_Xreg and Sel_Yreg = Prev_Yreg+1) or     --checks if selected square to the bottom of the KING is availble and not
                                                                                                                                    --occupied by a black piece.
                                        (board(Prev_Yreg+1, Prev_Xreg-1) >= 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg+1) or --so on and so forth, for every square around the king.
                                        (board(Prev_Yreg, Prev_Xreg+1) >= 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg) or
                                        (board(Prev_Yreg, Prev_Xreg) >= 0 and Sel_Xreg=Prev_Xreg and Sel_Yreg = Prev_Yreg) or
                                        (board(Prev_Yreg, Prev_Xreg-1) >= 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg) or
                                        (board(Prev_Yreg, Prev_Xreg+1) >= 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-1, Prev_Xreg) >= 0 and Sel_Xreg=Prev_Xreg and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-1, Prev_Xreg-1) >= 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg-1)) then
                                                
                                                board(Sel_Yreg, Sel_Xreg) <= temp_piece; --if any of these conditions are true, it is okay to move the black king to that corresponding square.
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                    else
                                             board(Prev_Yreg, Prev_Xreg) <= temp_piece; --if no condition is satisfied, change nothing exit select mode.
                                             Piece_Selreg <= '0';
                                             temp_piece <= 0;
                                                
                                    end if;
			            --END BLACK KING MOVEMENT DEFINITION--
                        
                        --BEGIN BLACK KNIGHT MOVEMENT DEFINITION--
			            elsif(temp_piece = -4) then
                                    if((board(Prev_Yreg+2,Prev_Xreg+1) >=0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg+2) or --checks if selected square to the bottom right of the KNIGHT is availble and not
                                                                                                                                    --occupied by a black piece.
                                        (board(Prev_Yreg+2,Prev_Xreg-1) >=0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg+2) or--checks if selected square to the bottom left of the KNIGHT is availble and not
                                                                                                                                    --occupied by a black piece.
                                        (board(Prev_Yreg+1,Prev_Xreg+2) >=0 and Sel_Xreg=Prev_Xreg+2 and Sel_Yreg = Prev_Yreg+1) or --so on and so forth, for every L movement pattern around the knight.
                                        (board(Prev_Yreg+1,Prev_Xreg-2) >=0 and Sel_Xreg=Prev_Xreg-2 and Sel_Yreg = Prev_Yreg+1) or
                                        (board(Prev_Yreg-1,Prev_Xreg+2) >=0 and Sel_Xreg=Prev_Xreg+2 and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-1,Prev_Xreg-2) >=0 and Sel_Xreg=Prev_Xreg-2 and Sel_Yreg = Prev_Yreg-1) or
                                        (board(Prev_Yreg-2,Prev_Xreg+1) >=0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg-2) or
                                        (board(Prev_Yreg-2,Prev_Xreg-1) >=0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg-2)) then
                                        
                                                board(Sel_Yreg,Sel_Xreg) <= temp_piece; --if any of these conditions are true, it is okay to move the black KNIGHT to that corresponding square.
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                    else
                                                board(Prev_Yreg, Prev_Xreg) <= temp_piece; --if no condition is satisfied, change nothing exit select mode.
                                                Piece_Selreg <= '0';
                                                temp_piece <= 0;
                                    end if;
                        --END BLACK KNIGHT MOVEMENT DEFINITION--
                        
                        --BEGIN BLACK PAWN MOVEMENT DEFINITION--
                        elsif(temp_piece = -6) then
                            
                            if((board(Prev_Yreg+1,Prev_Xreg+1) > 0 and Sel_Xreg=Prev_Xreg+1 and Sel_Yreg = Prev_Yreg+1) or --mechanism for capturing pieces diagonally.
                                (Board(Prev_Yreg+1,Prev_Xreg-1) > 0 and Sel_Xreg=Prev_Xreg-1 and Sel_Yreg = Prev_Yreg+1)) then
                                        if(Sel_Yreg = 7) then
                                            board(Sel_Yreg,Sel_Xreg) <= 2; --if diagonal capture occurs on the 1st rank, promote pawn to queen.
                                        else
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece; --else, just capture.
                                        end if;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            elsif(Sel_Xreg = Prev_Xreg and board(Prev_Yreg+1,Prev_Xreg) = 0 and Sel_Yreg = Prev_Yreg+1) then --mechanism for forward progression
                                        if(Sel_Yreg = 7) then
                                            board(Sel_Yreg,Sel_Xreg) <= 2; --if forward progression occurs on the 1st rank, promote pawn to queen.
                                        else
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece; --else, just progress
                                        end if;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            elsif(Sel_Xreg = Prev_Xreg and board(Prev_Yreg+1,Prev_Xreg) = 0 and board(Prev_Yreg+2,Prev_Xreg) = 0 and Sel_Yreg = Prev_Yreg+2 and Prev_Yreg = 1) then --mechanism for inital 2
                                                                                                                                                                                    --space pawn progression.
                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            else
                                        board(Prev_Yreg, Prev_Xreg) <= temp_piece; --if no condition is satisfied, change nothing exit select mode.
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                        
                            end if;
                        --END BLACK PAWN MOVEMENT DEFINITION--
                        
                        --BEGIN BLACK QUEEN MOVEMENT DEFINITION--
                        elsif(temp_piece = -2) then
                            if((Prev_Xreg = Sel_Xreg) and Prev_Yreg > Sel_Yreg) then --rook like movement, in the upwards direction.

                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                    
                            elsif((Prev_Xreg = Sel_Xreg) and Prev_Yreg < Sel_Yreg) then --rook like movement, in the downwards direction.                           
                                
                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then ---if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg > Sel_Xreg) then --rook like movement, in the left direction.
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg < Sel_Xreg) then --rook like movement, in the right direction.
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif(((Prev_Yreg - Sel_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg > Prev_Xreg) then --bishop like movement, toward quadrant 1
                                
                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                        board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;
                                   
                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;

                            elsif(((Prev_Yreg - Sel_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg < Prev_Yreg and Sel_Xreg < Prev_Xreg) then --bishop like movement, toward quadrant 2
                                                                           
                                    if(board(Sel_Yreg, Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then      --if a black piece is selected for capture, do nothing and exit select mode.
                                            board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    end if;
                    
                            elsif(((Sel_Yreg - Prev_Yreg) = (Prev_Xreg - Sel_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg < Prev_Xreg) then --bishop like movement, toward quadrant 3
                                    
                                    if(board(Sel_Yreg, Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then      --if a black piece is selected for capture, do nothing and exit select mode.
                                            board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    end if;
                    
                            elsif(((Sel_Yreg - Prev_Yreg) = (Sel_Xreg - Prev_Xreg)) and Sel_Yreg > Prev_Yreg and Sel_Xreg > Prev_Xreg) then --bishop like movement, toward quadrant 4
                                   
                                    if(board(Sel_Yreg, Sel_Xreg) >= 0) then --queen may only capture or move to a square not inhabited by another black piece
                                            board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then      --if a black piece is selected for capture, do nothing and exit select mode.
                                            board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                            Piece_Selreg <= '0';
                                            temp_piece <= 0;
                                        
                                    end if;
                                    
                            else
                                    --if an invalid space is selected, do nothing and exit select mode.
                                    board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                    Piece_Selreg <= '0';
                                    temp_piece <= 0;   
                            end if;
                        --END BLACK QUEEN MOVEMENT DEFINITION--
                        
                        --BEGIN BLACK ROOK MOVEMENT DEFINITION--
                        elsif(temp_piece = -5) then
                            if((Prev_Xreg = Sel_Xreg) and Prev_Yreg > Sel_Yreg) then --forces rook into upwards motion

                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --rook may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                    
                            elsif((Prev_Xreg = Sel_Xreg) and Prev_Yreg < Sel_Yreg) then --forces rook into downwards motion                           
                                
                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --rook may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg > Sel_Xreg) then --forces rook into left motion
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --rook may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                                
                            elsif((Prev_Yreg = Sel_Yreg) and Prev_Xreg < Sel_Xreg) then --forces rook into right motion
                                    
                                    if(board(Sel_Yreg,Sel_Xreg) >= 0) then --rook may only capture or move to a square not inhabited by another black piece
                                        Board(Sel_Yreg,Sel_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    elsif(board(Sel_Yreg, Sel_Xreg) <= -1) then --if a black piece is selected for capture, do nothing and exit select mode.
                                        board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                        Piece_Selreg <= '0';
                                        temp_piece <= 0;

                                    end if;
                            else
                            
                                    --if an invalid space is selected, do nothing and exit select mode.
                                    board(Prev_Yreg,Prev_Xreg) <= temp_piece;
                                    Piece_Selreg <= '0';
                                    temp_piece <= 0; 
                            end if;
                        --END BLACK ROOK MOVEMENT DEFINITION--
                        
                        end if;
                end if;
    end if;
      
end process;

--END-- MAIN GAME PIECE MOVEMENT LOGIC --END--------------------------------------------------

end Behavioral;
