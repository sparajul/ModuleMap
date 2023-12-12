######################################################################
#
# File name : graph_constructor_wave.do
# Created on: Sun Apr 03 19:58:06 -0500 2022
#
# Manual wave file for 'behavioral' simulation
#
######################################################################
##if { [catch {[add wave *]}] } {}

#############################
## Summary
#############################
add wave -group {Summary} -color yellow /graph_constructor_tb/UUT/module_mapper_0/CLK
add wave -group {Summary} -color yellow /graph_constructor_tb/UUT/module_mapper_0/decoder_0/READY
add wave -group {Summary} -color magenta /graph_constructor_tb/UUT/module_mapper_0/decoder_0/EVENT_START
add wave -group {Summary} -color magenta /graph_constructor_tb/UUT/module_mapper_0/decoder_0/EVENT_END
add wave -group {Summary} -color yellow -radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/DATA_IN
add wave -group {Summary} -color yellow /graph_constructor_tb/UUT/module_mapper_0/decoder_0/VALID_DATA_IN
add wave -group {Summary} -color white /graph_constructor_tb/UUT/module_mapper_0/controller_0/RW_MODE(0)
add wave -group {Summary} -color white /graph_constructor_tb/UUT/module_mapper_0/controller_0/RW_MODE(1)
add wave -group {Summary} -color white /graph_constructor_tb/UUT/module_mapper_0/controller_0/RW_MODE(2)
add wave -group {Summary} -color white -label FLAG_RESET(0) /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/FLAG_RESET
add wave -group {Summary} -color white -label FLAG_RESET(1) /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/FLAG_RESET
add wave -group {Summary} -color white -label FLAG_RESET(2) /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/FLAG_RESET
add wave -group {Summary} /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EDGE_CALC_WREN(0)
add wave -group {Summary} /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EDGE_CALC_RESET(0)
add wave -group {Summary} /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EDGE_CALC_WREN(1)
add wave -group {Summary} /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EDGE_CALC_RESET(1)
add wave -group {Summary} -radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_OUT
add wave -group {Summary} -radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_ADDR
add wave -group {Summary} -radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_INFO
add wave -group {Summary} -radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_WE
add wave -group {Summary} -radix hex -color green /graph_constructor_tb/UUT/concatenator_0/edge_dina
add wave -group {Summary} -radix hex -color green /graph_constructor_tb/UUT/concatenator_0/adj_dina
add wave -group {Summary} -radix hex -color green /graph_constructor_tb/UUT/concatenator_0/edge_addr
add wave -group {Summary} -color white /graph_constructor_tb/UUT/concatenator_0/edge_logic_we(0)


#############################
## Testbench
#############################
add wave -group {Testbench}
add wave -group {Testbench} /graph_constructor_tb/clk
add wave -group {Testbench} /graph_constructor_tb/reset
add wave -group {Testbench} /graph_constructor_tb/ready
add wave -group {Testbench} /graph_constructor_tb/meta_data_flag
add wave -group {Testbench} -radix hex /graph_constructor_tb/inference_data
add wave -group {Testbench} -radix hex /graph_constructor_tb/inference_addr
add wave -group {Testbench} /graph_constructor_tb/inference_start
add wave -group {Testbench} /graph_constructor_tb/inference_done
add wave -group {Testbench} /graph_constructor_tb/edge_data_out
add wave -group {Testbench} /graph_constructor_tb/adj_id_out

add wave -group {Testbench} -divider {Testbench : int}
add wave -group {Testbench} -color white /graph_constructor_tb/fr_state
add wave -group {Testbench} -color white /graph_constructor_tb/inf_state
add wave -group {Testbench} -color white -radix hex /graph_constructor_tb/inf_wait_count
add wave -group {Testbench} -color white -radix hex /graph_constructor_tb/inf_addr_count

#############################
## Graph Constructor Top (UUT)
#############################
add wave -divider {Graph Constructor}
add wave -group {Graph Constructor}
add wave -group {Graph Constructor} -radix hex /graph_constructor_tb/UUT/edge_calc_ready_eclc 
add wave -group {Graph Constructor} -radix hex /graph_constructor_tb/UUT/module_data_out_mmap
add wave -group {Graph Constructor} -radix hex /graph_constructor_tb/UUT/module_data_we_mmap 

add wave -group {Graph Constructor : int}
add wave -group {Graph Constructor : int} -color white /graph_constructor_tb/UUT/gc_state 
add wave -group {Graph Constructor : int} -color white /graph_constructor_tb/UUT/gc_rtn_state 
add wave -group {Graph Constructor : int} -color white /graph_constructor_tb/UUT/start
add wave -group {Graph Constructor : int} -color white /graph_constructor_tb/UUT/done

#############################
## Module Mapper
#############################
add wave -divider {Module Mapper}
add wave -group {Module Mapper}
add wave -group {Module Mapper} /graph_constructor_tb/UUT/module_mapper_0/CLK
add wave -group {Module Mapper} /graph_constructor_tb/UUT/module_mapper_0/RESET
add wave -group {Module Mapper} /graph_constructor_tb/UUT/module_mapper_0/READY
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/DATA_IN
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/VALID_DATA_IN
add wave -group {Module Mapper} /graph_constructor_tb/UUT/module_mapper_0/META_DATA_FLAG
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/EDGE_CALC_RESET
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/EDGE_CALC_READY
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/EDGE_CALC_WREN
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/EDGE_CALC_LAST
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/MODULE_DATA_OUT
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/MODULE_DATA_ADDR
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/MODULE_DATA_WE
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/INFERENCE_DATA
add wave -group {Module Mapper} -radix hex /graph_constructor_tb/UUT/module_mapper_0/INFERENCE_ADDR
add wave -group {Module Mapper} /graph_constructor_tb/UUT/module_mapper_0/INFERENCE_START
add wave -group {Module Mapper} /graph_constructor_tb/UUT/module_mapper_0/INFERENCE_DONE

### Internal Signals 
do {mm0_int_wave.do}


#############################
## Edge Calculator 0 
#############################
add wave -divider {Edge Calculator 0}
add wave -group {Edge Calculator 0}
add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/CLK
add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/RESET
add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/READY

add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/WREN
add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/LAST

add wave -group {Edge Calculator 0} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/MODULE_DATA_OUT
add wave -group {Edge Calculator 0} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/MODULE_DATA_ADDR
add wave -group {Edge Calculator 0} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/MODULE_DATA_INFO
add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/MODULE_DATA_WE
add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/EDGE_DATA_READY
add wave -group {Edge Calculator 0} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/EDGE_DATA_COUNT
add wave -group {Edge Calculator 0} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/EDGE_DATA_OUT
add wave -group {Edge Calculator 0} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/ADJ_ID_OUT
add wave -group {Edge Calculator 0} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/EDGE_RE

add wave -group {Edge Calculator 0 : int}
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/ec_state
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/ec_rtn_state
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/wait_count
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/start_ec
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/done_ecin
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/done_ecpipe
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/done_ecout
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/ready_ecin
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/ready_ecpl
add wave -group {Edge Calculator 0 : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(0)/edge_calc_gen/ready_ecout

### Internal Signals 
do {ec0_int_wave.do}

#############################
## Edge Calculator 1 
#############################
add wave -divider {Edge Calculator 1}
add wave -group {Edge Calculator 1}
add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/CLK
add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/RESET
add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/READY

add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/WREN
add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/LAST

add wave -group {Edge Calculator 1} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/MODULE_DATA_OUT
add wave -group {Edge Calculator 1} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/MODULE_DATA_ADDR
add wave -group {Edge Calculator 1} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/MODULE_DATA_INFO
add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/MODULE_DATA_WE

add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/EDGE_DATA_READY
add wave -group {Edge Calculator 1} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/EDGE_DATA_COUNT
add wave -group {Edge Calculator 1} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/EDGE_DATA_OUT
add wave -group {Edge Calculator 1} -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/ADJ_ID_OUT
add wave -group {Edge Calculator 1} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/EDGE_RE

### Internal Signals 
do {ec1_int_wave.do}


#############################
## Concatenator
#############################
add wave -divider {Concatenator}
add wave -group {Concatenator}
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/CLK
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/RESET
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/READY

add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/START
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/DONE

add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/EDGE_DATA_READY
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/EDGE_DATA_COUNT
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/EDGE_DATA_IN
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/ADJ_ID_IN
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/EDGE_RE

add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/EDGE_DATA_OUT
add wave -group {Concatenator} /graph_constructor_tb/UUT/concatenator_0/ADJ_ID_OUT

add wave -group  {Concatenator : int}
add wave -group {Concatenator : int} -color white /graph_constructor_tb/UUT/concatenator_0/concatenator_state
add wave -group {Concatenator : int} -color white /graph_constructor_tb/UUT/concatenator_0/concatenator_rtn_state
add wave -group {Concatenator : int} -radix hex -color green /graph_constructor_tb/UUT/concatenator_0/wait_count
add wave -group {Concatenator : int} -color white /graph_constructor_tb/UUT/concatenator_0/rd_index
add wave -group {Concatenator : int} -color white /graph_constructor_tb/UUT/concatenator_0/edge_count
add wave -group {Concatenator : int} -color white /graph_constructor_tb/UUT/concatenator_0/rd_count
add wave -group {Concatenator : int} -radix hex -color green /graph_constructor_tb/UUT/concatenator_0/edge_dina
add wave -group {Concatenator : int} -radix hex -color green /graph_constructor_tb/UUT/concatenator_0/adj_dina
add wave -group {Concatenator : int} -radix hex -color green /graph_constructor_tb/UUT/concatenator_0/edge_addr
add wave -group {Concatenator : int} -color white /graph_constructor_tb/UUT/concatenator_0/edge_logic_we(0)