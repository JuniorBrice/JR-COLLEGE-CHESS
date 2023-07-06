# JR-COLLEGE-CHESS
2-player joystick controlled chess, written in VHDL and implementable on an FPGA.

Images: 
![resized chess opening](https://github.com/JuniorBrice/JR-COLLEGE-CHESS/assets/79341423/76cdf84a-79d0-41e9-ac3e-8b7758e7f841)

![Resided Chess Reset State](https://github.com/JuniorBrice/JR-COLLEGE-CHESS/assets/79341423/526ae8ce-76ae-4791-8e4b-a52952fdc7c3)

Disclaimer:
This readme won't be able to properly encapsulate all aspects of this chess game. For that reason, I have included a report (in the EXTRAS folder) that does a slightly
better job. If any confusion arises, I have also commented the code which may help a bit more.

Purpose/Objective:
The purpose of this was to implement a functional version of chess on the Zybo Zynq-7000 FPGA board.

Basic Explanation:
This project is broken up into 3 main blocks. The Chess Logic block, the VGA Control block, and the GUI block. In total, there are 4 inputs to the system and 8 outputs.

---> The Chess Logic block is where the bulk of computational work is done, and where are memory for the current state of the chess board is stored/modified. It was implemented
using a combination of large priority/non-priority muxes, memory arrays, and a custom logic design. 

---> The GUI block takes 3 inputs, 2 of which (hcount and vcount) come from the VGA Control block and are used to control the RGB display out, but one of which comes the Chess Logic block, and is 
used to check every position of the chess grid depending on hcount and vcount. The GUI block also outputs its own inquiry signal to the Chess Logic block that has a direct impact on the Chess
Logic block return signal.

---> The VGA Control block consists of a clock signal modifier module, and a basic control module that takes in both the original and modified clocks, then outputs hcount (horizontal pixel count),
vcount (vertical pixel count), vid (video output enable), hs (horizontal sync), and vs (vertical sync) to the GUI block or the proper interface pins.

Capabilities:
-> Pieces are constrained to movements only allowed by their type. (I.e., Knights can only move like Knights, and Queens can only move like Queens.)
-> Pawns that have not been previously moved can in fact move the initial two squares as usual, if there is nothing blocking their way. They cannot move two squares otherwise.
-> Pieces of opposite color can be captured. Pieces of the same color cannot be captured.
-> Pawns may not move diagonally unless in the act of capturing, as usual.
-> Pawn promotion is functional; however, pawns auto promote to Queen.
-> Diagonal movement selection allowed by the joystick.

Areas for Improvement:
-> No turn order, players can move pieces however they wish regardless of proper turn.
-> No castling functionality.
-> No En passant functionality.
-> No check or checkmate functionality.
-> No collision detection for the Queen, Bishop, or Rook pieces. (I.e., these pieces may behave like a knight and jump over other pieces in its path of legal moves)

Hope you find this interesting!
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
If you randomly found this on the internet, feel free to take inspiration but please do not redistribute or copy code.  
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

