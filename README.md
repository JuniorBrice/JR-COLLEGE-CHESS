# VHDL-CHESS
2-player chess controlled by a joystick and buttons, designed in VHDL 

Purpose/Objective:
The purpose of this was to implement a functional version of chess on the Zybo Zynq-7000 FPGA board.

Basic Explanation:
This project is broken up into 3 main blocks. The Chess Logic block, the VGA Control block, and the GUI block. In total, there are 4 inputs to the system and 8 outputs.

-> The Chess Logic block is where the bulk of computational work is done, and where are memory for the current state of the chess board is stored/modified. It was implemented
using a combination of large priority/non-priority muxes, memory arrays, and a custom logic design. 

-> The GUI block
