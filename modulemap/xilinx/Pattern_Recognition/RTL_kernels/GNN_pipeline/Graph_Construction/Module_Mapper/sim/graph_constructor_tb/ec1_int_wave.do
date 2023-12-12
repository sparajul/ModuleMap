######################################################################
#
# File name : ec_int_wave.do
# Created on: Sun Apr 03 19:58:06 -0500 2022
#
# Manual wave file for 'behavioral' simulation of internal edge calculator structure
#
######################################################################


#############################
## Edge Calc Input
#############################
add wave -group {Edge Calculator 1 : Input : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/CLK
add wave -group {Edge Calculator 1 : Input : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/RESET
add wave -group {Edge Calculator 1 : Input : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/READY
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/MODULE_DATA_OUT
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/MODULE_DATA_ADDR
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/MODULE_DATA_INFO
add wave -group {Edge Calculator 1 : Input : ext} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/MODULE_DATA_WE
add wave -group {Edge Calculator 1 : Input : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/START
add wave -group {Edge Calculator 1 : Input : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/DONE
add wave -radix hex -group {Edge Calculator 1 : Input : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/MODULE_INFO_ADDR
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/MODULE_INFO
add wave -radix hex -group {Edge Calculator 1 : Input : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/OUTPUT_HIT_ADDR
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/OUTPUT_HIT
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/OUTPUT_ID
add wave -radix hex -group {Edge Calculator 1 : Input : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/INPUT_HIT_ADDR
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/INPUT_HIT
add wave -radix hex -group {Edge Calculator 1 : Input : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/INPUT_ID

add wave -group {Edge Calculator 1 : Input : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/input_state
#add wave -group {Edge Calculator 1 : Input : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/input_rtn_state
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/expected_hit_count
add wave -radix hex -group {Edge Calculator 1 : Input : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/expected_in_mod_count
add wave -radix hex -group {Edge Calculator 1 : Input : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/out_hit_din
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/out_id_din
add wave -radix hex -group {Edge Calculator 1 : Input : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/out_hit_addr
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/out_hit_addr_mux
add wave -group {Edge Calculator 1 : Input : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/out_hit_we(0)
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/in_hit_din
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/in_id_din
add wave -radix hex -group {Edge Calculator 1 : Input : int} /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/in_hit_addr
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/in_hit_addr_mux
add wave -group {Edge Calculator 1 : Input : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/in_hit_we(0)
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/mod_info_din
add wave -radix hex -group {Edge Calculator 1 : Input : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/mod_info_addr
add wave -radix hex -group {Edge Calculator 1 : Input : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/mod_info_addr_mux
add wave -group {Edge Calculator 1 : Input : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/mod_info_we(0)
add wave -group {Edge Calculator 1 : Input : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/input_0/mux_select


#############################
## Edge Calculator 1 : Pipeline
#############################
add wave -group {Edge Calculator 1 : Pipeline : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/CLK
add wave -group {Edge Calculator 1 : Pipeline : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/RESET
add wave -group {Edge Calculator 1 : Pipeline : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/READY
add wave -group {Edge Calculator 1 : Pipeline : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/START
add wave -group {Edge Calculator 1 : Pipeline : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/DONE
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/MODULE_INFO_ADDR
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/MODULE_INFO
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/OUTPUT_HIT_ADDR
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/OUTPUT_HIT
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/OUTPUT_ID
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/INPUT_HIT_ADDR
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/INPUT_HIT
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/INPUT_ID
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/EDGE_DATA_OUT
add wave -radix hex -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/ADJ_ID_OUT
add wave -group {Edge Calculator 1 : Pipeline : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/EDGE_WE

add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/ec_pipeline_state
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/ec_pipeline_rtn_state
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/wait_count
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/fp_enable
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/expected_out_hit_count
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/expected_in_mod_count
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/in_mod_count
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/expected_in_hit_count
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/module_info_index
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/output_hit_index
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/input_hit_index

add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/ohfifo_wren
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/oidfifo_wren
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/iidfifo_wren

add wave -group {Edge Calculator 1 : Pipeline : int} 
add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Stage 1}
add wave -group {Edge Calculator 1 : Pipeline : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/CLK

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Ro-Ri}
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tvalid_Ri
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tdata_Ri
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tvalid_Ro
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tdata_Ro
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tvalid_subR
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tdata_subR

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Zo-Zi}
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tvalid_Zi
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tdata_Zi
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tvalid_Zo
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tdata_Zo
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tvalid_subZ
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tdata_subZ

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Phio-Phii}
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tvalid_Phii
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tdata_Phii
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tvalid_Phio
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/tdata_Phio
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tvalid_subPhi
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tdata_subPhi

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Stage 2}
add wave -group {Edge Calculator 1 : Pipeline : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/CLK

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {(Phio-Phii) / (Ro-Ri)}
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tvalid_divPhi
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tdata_divPhi

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {(Zo-Zi) / (Ro-Ri)}
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tvalid_divZ
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tdata_divZ

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Stage 3}
add wave -group {Edge Calculator 1 : Pipeline : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/CLK

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Phi0 = -divPhi*Ro + Phio}
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tvalid_macPhi
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tdata_macPhi

add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Z0 = -divZ*Ro + Zo}
add wave -group {Edge Calculator 1 : Pipeline : int}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tvalid_macZ
add wave -group {Edge Calculator 1 : Pipeline : int}  -radix hex /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/result_tdata_macZ


add wave -group {Edge Calculator 1 : Pipeline : int}  -divider {Pipeline FIFOs}
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/ohfifo_rden
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/ohfifo_dout
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/mfifo_wren
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/mfifo_din

add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/oidfifo_rden
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/oidfifo_dout
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/iidfifo_rden
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/iidfifo_dout
add wave -group {Edge Calculator 1 : Pipeline : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/mfifo_rden
add wave -radix hex -group {Edge Calculator 1 : Pipeline : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/pipeline_0/mfifo_dout

#############################
## Edge Calculator 1 : Output
#############################
add wave -group {Edge Calculator 1 : Output : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/CLK
add wave -group {Edge Calculator 1 : Output : ext} -color yellow /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/RESET
add wave -group {Edge Calculator 1 : Output : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/READY
add wave -group {Edge Calculator 1 : Output : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/START
add wave -group {Edge Calculator 1 : Output : ext} -color magenta /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/DONE
add wave -radix hex -group {Edge Calculator 1 : Output : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/EDGE_DATA_IN
add wave -radix hex -group {Edge Calculator 1 : Output : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/ADJ_ID_IN
add wave -group {Edge Calculator 1 : Output : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/EDGE_WE
add wave -group {Edge Calculator 1 : Output : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/EDGE_DATA_READY
add wave -radix hex -group {Edge Calculator 1 : Output : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/EDGE_DATA_COUNT
add wave -radix hex -group {Edge Calculator 1 : Output : ext}  /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/EDGE_DATA_OUT
add wave -radix hex -group {Edge Calculator 1 : Output : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/ADJ_ID_OUT
add wave -group {Edge Calculator 1 : Output : ext} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/EDGE_RE

add wave -group {Edge Calculator 1 : Output : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/ec_output_state
add wave -group {Edge Calculator 1 : Output : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/ec_output_rtn_state
add wave -radix hex -group {Edge Calculator 1 : Output : int} -color green /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/wait_count
add wave -group {Edge Calculator 1 : Output : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/edge_count
add wave -group {Edge Calculator 1 : Output : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/rd_count
add wave -group {Edge Calculator 1 : Output : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/edge_addr
add wave -group {Edge Calculator 1 : Output : int} -color white /graph_constructor_tb/UUT/GEN_EDGE_CALC(1)/edge_calc_gen/output_0/writing
