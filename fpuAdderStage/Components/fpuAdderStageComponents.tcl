# This script will compile the components and testbenchs for the 8 and 25 bit CMA adders
# NOTE : Make sure that version 2008 of compiler is selected in compiler options 
vcom -reportprogress 300 -work work ./fpuAdderStage/Components/comparator8bit.vhdl
vcom -reportprogress 300 -work work ./fpuAdderStage/Components/comparator25bit.vhdl
vcom -reportprogress 300 -work work ./fpuAdderStage/Components/fpuAdderStage.vhdl
