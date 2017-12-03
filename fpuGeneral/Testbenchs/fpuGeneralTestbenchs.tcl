# This script will compile the Testbenchs
# NOTE : Make sure that version 2008 of compiler is selected in compiler options 
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/cmaAdderCell_Level2_tb.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/cmaSubstage_Level2_tb.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/barrelShifter_tb.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/cma8bits_tb.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/cma24bits_tb.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/cma25bits_tb.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/cma48bits_tb.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Testbenchs/cma49bits_tb.vhdl
