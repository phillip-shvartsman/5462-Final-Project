# This script will compile the components and testbenchs for the 8 and 25 bit CMA adders
# NOTE : Make sure that version 2008 of compiler is selected in compiler options 
vcom -reportprogress 300 -work work ./fpuGeneral/Components/RippleAdder.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/Mux21.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaXor_Unit.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaSum_Unit.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaCarry_Unit.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaAdderCell_Level2.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaAdderCell_Level3.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaLastAdderCell_Level3.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaHalfAdderCell_Level2.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaHalfAdderCell_Level3.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaSubstage_Level2.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaSubstage_Level3.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cmaStage.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cma8bits.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cma24bits.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cma25bits.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cma26bits.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cma48bits.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cma49bits.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/cma64bits.vhdl
vcom -reportprogress 300 -work work ./fpuGeneral/Components/barrelShifter.vhdl
