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
add wave -group {Summary} -divider {Summary}
add wave -group {Summary} -color yellow /module_mapper_tb/UUT/CLK
add wave -group {Summary} -color yellow /module_mapper_tb/UUT/decoder_0/READY
add wave -group {Summary} -color magenta /module_mapper_tb/UUT/decoder_0/EVENT_START
add wave -group {Summary} -color magenta /module_mapper_tb/UUT/decoder_0/EVENT_END
add wave -group {Summary} -color yellow -radix hex /module_mapper_tb/UUT/decoder_0/DATA_IN
add wave -group {Summary} -color yellow /module_mapper_tb/UUT/decoder_0/VALID_DATA_IN
add wave -group {Summary} -color white /module_mapper_tb/UUT/controller_0/RW_MODE(0)
add wave -group {Summary} -color white /module_mapper_tb/UUT/controller_0/RW_MODE(1)
add wave -group {Summary} -color white /module_mapper_tb/UUT/controller_0/RW_MODE(2)
add wave -group {Summary} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/FLAG_RESET
add wave -group {Summary} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/FLAG_RESET
add wave -group {Summary} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/FLAG_RESET
add wave -group {Summary} -radix hex /module_mapper_tb/UUT/output_manager_0/EDGE_CALC_WREN
add wave -group {Summary} -radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_DATA_OUT
add wave -group {Summary} -radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_DATA_ADDR
add wave -group {Summary} -radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_DATA_INFO
add wave -group {Summary} -radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_DATA_WE

#############################
## Testbench
#############################
add wave -group {Testbench}
add wave -group {Testbench} /module_mapper_tb/clk
add wave -group {Testbench} /module_mapper_tb/reset
add wave -group {Testbench} /module_mapper_tb/ready
add wave -group {Testbench} /module_mapper_tb/meta_data_flag
add wave -group {Testbench} -radix hex /module_mapper_tb/inference_data
add wave -group {Testbench} -radix hex /module_mapper_tb/inference_addr
add wave -group {Testbench} /module_mapper_tb/inference_start
add wave -group {Testbench} /module_mapper_tb/inference_done

add wave -group {Testbench} -divider {Testbench : int}
add wave -group {Testbench} -color white /module_mapper_tb/fr_state
add wave -group {Testbench} -color white /module_mapper_tb/inf_state
add wave -group {Testbench} -color white -radix hex /module_mapper_tb/inf_wait_count
add wave -group {Testbench} -color white -radix hex /module_mapper_tb/inf_addr_count


#############################
## Graph Constructor Top (UUT)
#############################
add wave -group {Graph Constructor} \
-radix hex /module_mapper_tb/edge_calc_ready_mmap \
-radix hex /module_mapper_tb/edge_calc_wren_mmap \
-radix hex /module_mapper_tb/module_data_out_mmap \
/module_mapper_tb/module_data_we_mmap 

#############################
## Module Mapper (DUT)
#############################
add wave -group {Module Mapper} \
/module_mapper_tb/UUT/CLK \
/module_mapper_tb/UUT/RESET \
/module_mapper_tb/UUT/READY \
-radix hex /module_mapper_tb/UUT/DATA_IN \
-radix hex /module_mapper_tb/UUT/VALID_DATA_IN \
/module_mapper_tb/UUT/META_DATA_FLAG \
-radix hex /module_mapper_tb/UUT/EDGE_CALC_READY \
-radix hex /module_mapper_tb/UUT/EDGE_CALC_WREN \
-radix hex /module_mapper_tb/UUT/MODULE_DATA_OUT \
-radix hex /module_mapper_tb/UUT/MODULE_DATA_ADDR \
/module_mapper_tb/UUT/MODULE_DATA_WE \
-radix hex /module_mapper_tb/UUT/INFERENCE_DATA \
-radix hex /module_mapper_tb/UUT/INFERENCE_ADDR \
/module_mapper_tb/UUT/INFERENCE_START \
/module_mapper_tb/UUT/INFERENCE_DONE

add wave -group  {Module Mapper : int} \
/module_mapper_tb/UUT/CLK \
/module_mapper_tb/UUT/raw_data_dcdr \
/module_mapper_tb/UUT/raw_addr_dcdr \
/module_mapper_tb/UUT/raw_we_dcdr \


#############################
## Decoder
#############################
add wave -group {Decoder} \
-radix hex /module_mapper_tb/UUT/decoder_0/CLK \
/module_mapper_tb/UUT/decoder_0/RESET \
/module_mapper_tb/UUT/decoder_0/READY \
/module_mapper_tb/UUT/decoder_0/EVENT_START \
/module_mapper_tb/UUT/decoder_0/EVENT_END \
/module_mapper_tb/UUT/decoder_0/W_START_CNTRL \
/module_mapper_tb/UUT/decoder_0/W_DONE_DCDR \
/module_mapper_tb/UUT/decoder_0/META_DATA_FLAG \
-radix hex /module_mapper_tb/UUT/decoder_0/EVENT_DATA \
/module_mapper_tb/UUT/decoder_0/EVENT_WE \
-radix hex /module_mapper_tb/UUT/decoder_0/DATA_IN \
/module_mapper_tb/UUT/decoder_0/VALID_DATA_IN \
-radix hex /module_mapper_tb/UUT/decoder_0/RAW_DATA \
-radix hex /module_mapper_tb/UUT/decoder_0/RAW_ADDR \
/module_mapper_tb/UUT/decoder_0/RAW_WE \
-radix hex /module_mapper_tb/UUT/decoder_0/DEBUG

add wave -group {Decoder:int} \
/module_mapper_tb/UUT/decoder_0/mw_flag_in \
-radix hex /module_mapper_tb/UUT/decoder_0/layer_id \
-radix hex /module_mapper_tb/UUT/decoder_0/module_id \
-radix hex /module_mapper_tb/UUT/decoder_0/module_word_raw_addr \
-radix hex /module_mapper_tb/UUT/decoder_0/r_coordinate \
-radix hex /module_mapper_tb/UUT/decoder_0/phi_coordinate \
-radix hex /module_mapper_tb/UUT/decoder_0/z_coordinate \
-radix hex /module_mapper_tb/UUT/decoder_0/raw_addr_count \
/module_mapper_tb/UUT/decoder_0/raw_write \
-radix hex /module_mapper_tb/UUT/decoder_0/event_word_count \
/module_mapper_tb/UUT/decoder_0/event_write \
/module_mapper_tb/UUT/decoder_0/decode_state \
/module_mapper_tb/UUT/decoder_0/decode_rtn_state


#############################
## Hit Buffers
#############################
add wave -group {Hit_Buffer_0} \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/CLK \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/RESET \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_DATA_IN \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_WE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/RAW_DATA \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/RAW_ADDR \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/RAW_WE \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/WBUF_EMPTY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/RBUF_READY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/IBUF_READY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/RW_MODE \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/FLAG_RESET \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/FLAG_RESET_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/MODULE_ID \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/MODULE_RE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/HIT_DATA \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/HIT_ADDR \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/HIT_COUNT \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/VALID_DATA \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/READ_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/IBUF_RAW_ADDR \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/IBUF_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_DATA_OUT \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_RE

add wave -group {Hit_Buffer_0:int} \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/mw_flag_in \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/module_id \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/raw_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/raw_addr_mux \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_addr_r1 \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_din_r1 \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_din \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_addr \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_we \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_addr_mux \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_hit_count \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_raw_addr \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_addr_mux \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/event_we_mux(0) \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/event_re_mux(0)

add wave -group {Hit_Buffer_1} \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/CLK \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/RESET \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_DATA_IN \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_WE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/RAW_DATA \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/RAW_ADDR \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/RAW_WE \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/WBUF_EMPTY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/RBUF_READY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/IBUF_READY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/RW_MODE \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/FLAG_RESET \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/FLAG_RESET_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/MODULE_ID \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/MODULE_RE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/HIT_DATA \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/HIT_ADDR \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/HIT_COUNT \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/VALID_DATA \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/READ_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/IBUF_RAW_ADDR \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/IBUF_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_DATA_OUT \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_RE

add wave -group {Hit_Buffer_1:int} \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/mw_flag_in \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/module_id \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/raw_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/raw_addr_mux \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_addr_r1 \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_din_r1 \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_din \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_addr \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_we \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_addr_mux \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_hit_count \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_raw_addr \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_addr_mux \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/event_we_mux(0) \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/event_re_mux(0)

add wave -group {Hit_Buffer_2} \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/CLK \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/RESET \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_DATA_IN \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_WE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/RAW_DATA \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/RAW_ADDR \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/RAW_WE \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/WBUF_EMPTY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/RBUF_READY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/IBUF_READY \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/RW_MODE \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/FLAG_RESET \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/FLAG_RESET_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/MODULE_ID \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/MODULE_RE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/HIT_DATA \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/HIT_ADDR \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/HIT_COUNT \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/VALID_DATA \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/READ_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/IBUF_RAW_ADDR \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/IBUF_DONE \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_DATA_OUT \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_RE

add wave -group {Hit_Buffer_2:int} \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/mw_flag_in \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/module_id \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/raw_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/raw_addr_mux \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_addr_r1 \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_din_r1 \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_din \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_addr \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_we \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_addr_mux \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_hit_count \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_raw_addr \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/flag_we_mux(0) \
-radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/flag_addr_mux \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/event_we_mux(0) \
/module_mapper_tb/UUT/GEN_HIT_BUFFER(2)/hit_buffer_gen/event_re_mux(0)


#############################
## Controller
#############################
add wave -group {Controller_0} \
/module_mapper_tb/UUT/controller_0/CLK \
/module_mapper_tb/UUT/controller_0/RESET \
/module_mapper_tb/UUT/controller_0/READY \
/module_mapper_tb/UUT/controller_0/RW_MODE \
/module_mapper_tb/UUT/controller_0/R_INDEX \
/module_mapper_tb/UUT/controller_0/I_INDEX \
/module_mapper_tb/UUT/controller_0/WBUF_EMPTY \
/module_mapper_tb/UUT/controller_0/RBUF_READY \
/module_mapper_tb/UUT/controller_0/IBUF_READY \
-radix hex /module_mapper_tb/UUT/controller_0/FLAG_RESET \
-radix hex /module_mapper_tb/UUT/controller_0/FLAG_RESET_DONE \
/module_mapper_tb/UUT/controller_0/EVENT_START \
/module_mapper_tb/UUT/controller_0/EVENT_END \
/module_mapper_tb/UUT/controller_0/W_START_CNTRL \
/module_mapper_tb/UUT/controller_0/W_DONE_DCDR \
/module_mapper_tb/UUT/controller_0/R_START_CNTRL \
/module_mapper_tb/UUT/controller_0/R_DONE_OMGR \
/module_mapper_tb/UUT/controller_0/I_START_CNTRL \
/module_mapper_tb/UUT/controller_0/I_DONE_INFR \
-radix hex /module_mapper_tb/UUT/controller_0/DEBUG

add wave -group {Controller_0:int} \
-radix hex /module_mapper_tb/UUT/controller_0/buf_data_flag \
/module_mapper_tb/UUT/controller_0/control_state \
/module_mapper_tb/UUT/controller_0/control_rtn_state

#############################
## Output Manager
#############################
add wave -group {Output_Manager_0} \
/module_mapper_tb/UUT/output_manager_0/CLK \
/module_mapper_tb/UUT/output_manager_0/RESET \
/module_mapper_tb/UUT/output_manager_0/READY \
-radix hex /module_mapper_tb/UUT/output_manager_0/EVENT_DATA_IN \
/module_mapper_tb/UUT/output_manager_0/R_START_CNTRL \
/module_mapper_tb/UUT/output_manager_0/R_DONE_OMGR \
/module_mapper_tb/UUT/output_manager_0/RW_MODE \
/module_mapper_tb/UUT/output_manager_0/R_INDEX \
-radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_ID \
/module_mapper_tb/UUT/output_manager_0/MODULE_RE \
-radix hex /module_mapper_tb/UUT/output_manager_0/HIT_DATA \
-radix hex /module_mapper_tb/UUT/output_manager_0/HIT_ADDR \
-radix hex /module_mapper_tb/UUT/output_manager_0/HIT_COUNT \
-radix hex /module_mapper_tb/UUT/output_manager_0/VALID_DATA \
-radix hex /module_mapper_tb/UUT/output_manager_0/EDGE_CALC_READY \
-radix hex /module_mapper_tb/UUT/output_manager_0/EDGE_CALC_WREN \
-radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_DATA_OUT \
-radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_DATA_ADDR \
-radix hex /module_mapper_tb/UUT/output_manager_0/MODULE_DATA_INFO \
/module_mapper_tb/UUT/output_manager_0/MODULE_DATA_WE \
-radix hex /module_mapper_tb/UUT/output_manager_0/READ_DONE \
-radix hex /module_mapper_tb/UUT/output_manager_0/DEBUG

add wave -group {Output_Manager_0:int} \
/module_mapper_tb/UUT/output_manager_0/output_manager_state \
/module_mapper_tb/UUT/output_manager_0/output_manager_rtn_state \
-radix hex /module_mapper_tb/UUT/output_manager_0/module_map_din \
-radix hex /module_mapper_tb/UUT/output_manager_0/module_map_dout \
-radix hex /module_mapper_tb/UUT/output_manager_0/module_map_addr \
/module_mapper_tb/UUT/output_manager_0/module_map_we \
/module_mapper_tb/UUT/output_manager_0/mmw_io_flag \
-radix hex /module_mapper_tb/UUT/output_manager_0/mmw_incount \
-radix hex /module_mapper_tb/UUT/output_manager_0/mmw_layer_id \
-radix hex /module_mapper_tb/UUT/output_manager_0/mmw_module_id \
/module_mapper_tb/UUT/output_manager_0/io_flag \
-radix hex /module_mapper_tb/UUT/output_manager_0/hit_count \
-radix hex /module_mapper_tb/UUT/output_manager_0/module_count \
/module_mapper_tb/UUT/output_manager_0/read_buffer_index \
/module_mapper_tb/UUT/output_manager_0/edge_calc_index
