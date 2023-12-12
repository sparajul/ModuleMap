######################################################################
#
# File name : edge_calc_tb.do
# Created on: Mon Apr 04 13:02:43 -0500 2022
#
######################################################################

# Compile ####################################
vlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/work
vlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/msim

vlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib ../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/modelsim_lib/msim/xil_defaultlib

vlog  -incr -mfcu -work xil_defaultlib  \
"../../graph-constructor/graph-constructor.gen/sources_1/ip/fp_mult_add_0/sim/fp_mult_add_0.v" \
"../../graph-constructor/graph-constructor.gen/sources_1/ip/fp_sub_0/sim/fp_sub_0.v" \
"../../graph-constructor/graph-constructor.gen/sources_1/ip/fp_div_0/sim/fp_div_0.v" \
"../../graph-constructor/graph-constructor.gen/sources_1/ip/fp_gtoe_0/sim/fp_gtoe_0.v"

vcom  -93 -work xil_defaultlib  \
"../../src/graph_constructor_package.vhd" \
"../../src/spram_wrapper.vhd" \
"../../src/fifo_wrapper.vhd" \
"../../src/ec_input.vhd" \
"../../src/ec_pipeline.vhd" \
"../../src/ec_output.vhd" \
"../../src/edge_calc.vhd" \
"./edge_calc_tb.vhd"

# Compile glbl module
vlog -work xil_defaultlib "../../graph-constructor/graph-constructor.sim/sim_1/behav/modelsim/glbl.v"

# Simulate ###################################
vsim -voptargs="+acc" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -L floating_point_v7_1_12 -lib xil_defaultlib xil_defaultlib.edge_calc_tb xil_defaultlib.glbl 

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {edge_calc_wave.do}

#view wave
#view structure
#view signals

# User Do File
# do {graph_constructor_tb.udo}

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
{{Stage 1 : Inputs} {375 ns} 1} \
{{Stage 1 : Results} {485 ns} 1} \
{{Stage 2 : Results} {635 ns} 1} \
{{Stage 3 : Results} {785 ns} 1} \
{{C1} {800 ns} 0} 

run 1.5us
WaveRestoreZoom {0 ns} {1.5us}

