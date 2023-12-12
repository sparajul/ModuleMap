######################################################################
#
# File name : concatenator_tb.do
# Created on: Mon Apr 04 13:02:43 -0500 2022
#
######################################################################

# Compile ####################################
vlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/work
vlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/msim

vlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/msim/xil_defaultlib

vcom  -93 -work xil_defaultlib  \
"../../src/graph_constructor_package.vhd" \
"../../src/spram_wrapper.vhd" \
"../../src/fifo_wrapper.vhd" \
"../../src/concatenator.vhd" \
"./concatenator_tb.vhd"

# Compile glbl module
vlog -work xil_defaultlib "../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/glbl.v"

# Simulate ###################################
vsim -voptargs="+acc" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -L floating_point_v7_1_12 -lib xil_defaultlib xil_defaultlib.concatenator_tb xil_defaultlib.glbl 

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {concatenator_wave.do}

#view wave
#view structure
#view signals

# Modelsim Preferences Setup ##################################################
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
configure wave -shortnames 1

# Cursor Setup ################################################################
WaveRestoreCursors \
{{Stage 1 : Inputs} {100 ns} 1} \
{{Stage 1 : Results} {20 ns} 1} \
{{C1} {200 ns} 0} 

run 1.5us
WaveRestoreZoom {0 ns} {1us}

