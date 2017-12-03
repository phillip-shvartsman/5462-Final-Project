# This script will compile the Testbenchs
# NOTE : Make sure that version 2008 of compiler is selected in compiler options 
vcom -reportprogress 300 -work work ./fpuAdderStage/Testbenchs/comparator8bit_tb.vhdl
vcom -reportprogress 300 -work work ./fpuAdderStage/Testbenchs/fpuAdderStage_test_vect.vhdl
vcom -reportprogress 300 -work work ./fpuAdderStage/Testbenchs/fpuAdderStage_tb.vhdl
