######################################################################
#
# File name : mm_int_wave.do
# Created on: Sun Apr 03 19:58:06 -0500 2022
#
# Manual wave file for 'behavioral' simulation of internal edge module mapper structure
#
######################################################################


#############################
## Decoder
#############################
add wave -group {Module Mapper : Decoder : ext} \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/CLK \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/RESET \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/READY \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/EVENT_START \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/EVENT_END \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/W_START_CNTRL \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/W_DONE_DCDR \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/META_DATA_FLAG \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/EVENT_DATA \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/EVENT_WE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/DATA_IN \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/VALID_DATA_IN \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/RAW_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/RAW_ADDR \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/RAW_WE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/DEBUG

add wave -group {Module Mapper : Decoder : int} \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/mw_flag_in \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/layer_id \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/module_id \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/module_word_raw_addr \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/r_coordinate \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/phi_coordinate \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/z_coordinate \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/raw_addr_count \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/raw_write \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/decoder_0/event_word_count \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/event_write \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/decode_state \
/graph_constructor_tb/UUT/module_mapper_0/decoder_0/decode_rtn_state


#############################
## Hit Buffers
#############################
add wave -group {Module Mapper : Hit_Buffer_0 : ext} \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/CLK \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/RESET \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_DATA_IN \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_WE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/RAW_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/RAW_ADDR \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/RAW_WE \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/WBUF_EMPTY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/RBUF_READY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/IBUF_READY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/RW_MODE \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/FLAG_RESET \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/FLAG_RESET_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/MODULE_ID \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/MODULE_RE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/HIT_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/HIT_ADDR \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/HIT_COUNT \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/VALID_DATA \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/READ_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/IBUF_RAW_ADDR \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/IBUF_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_DATA_OUT \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/EVENT_RE

add wave -group {Module Mapper : Hit_Buffer_0 : int} \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/mw_flag_in \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/module_id \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/raw_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/raw_addr_mux \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_addr_r1 \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_din_r1 \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_din \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_addr \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_we \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_addr_mux \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_hit_count \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_raw_addr \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_addr_mux \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/event_we_mux(0) \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(0)/hit_buffer_gen/event_re_mux(0)

add wave -group {Module Mapper : Hit_Buffer_1 : ext} \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/CLK \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/RESET \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_DATA_IN \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_WE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/RAW_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/RAW_ADDR \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/RAW_WE \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/WBUF_EMPTY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/RBUF_READY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/IBUF_READY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/RW_MODE \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/FLAG_RESET \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/FLAG_RESET_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/MODULE_ID \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/MODULE_RE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/HIT_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/HIT_ADDR \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/HIT_COUNT \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/VALID_DATA \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/READ_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/IBUF_RAW_ADDR \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/IBUF_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_DATA_OUT \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/EVENT_RE

add wave -group {Module Mapper : Hit_Buffer_1 : int} \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/mw_flag_in \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/module_id \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/raw_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/raw_addr_mux \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_addr_r1 \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_din_r1 \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_din \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_addr \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_we \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_addr_mux \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_hit_count \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_raw_addr \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_addr_mux \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/event_we_mux(0) \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(1)/hit_buffer_gen/event_re_mux(0)

add wave -group {Module Mapper : Hit_Buffer_2 : ext} \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/CLK \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/RESET \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_DATA_IN \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_WE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/RAW_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/RAW_ADDR \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/RAW_WE \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/WBUF_EMPTY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/RBUF_READY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/IBUF_READY \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/RW_MODE \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/FLAG_RESET \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/FLAG_RESET_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/MODULE_ID \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/MODULE_RE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/HIT_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/HIT_ADDR \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/HIT_COUNT \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/VALID_DATA \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/READ_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/IBUF_RAW_ADDR \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/IBUF_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_DATA_OUT \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/EVENT_RE

add wave -group {Module Mapper : Hit_Buffer_1 : int} \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/mw_flag_in \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/module_id \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/raw_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/raw_addr_mux \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_addr_r1 \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_din_r1 \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_din \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_addr \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_we \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_addr_mux \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_hit_count \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/index_raw_addr \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/flag_we_mux(0) \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/flag_addr_mux \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/event_we_mux(0) \
/graph_constructor_tb/UUT/module_mapper_0/GEN_HIT_BUFFER(2)/hit_buffer_gen/event_re_mux(0)


#############################
## Controller
#############################
add wave -group {Module Mapper : Controller_0 : ext} \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/CLK \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/RESET \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/READY \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/RW_MODE \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/R_INDEX \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/I_INDEX \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/WBUF_EMPTY \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/RBUF_READY \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/IBUF_READY \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/controller_0/FLAG_RESET \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/controller_0/FLAG_RESET_DONE \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/EVENT_START \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/EVENT_END \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/W_START_CNTRL \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/W_DONE_DCDR \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/R_START_CNTRL \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/R_DONE_OMGR \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/I_START_CNTRL \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/I_DONE_INFR \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/controller_0/DEBUG

add wave -group {Module Mapper : Controller_0 : int} \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/controller_0/buf_data_flag \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/control_state \
/graph_constructor_tb/UUT/module_mapper_0/controller_0/control_rtn_state

#############################
## Output Manager
#############################
add wave -group {Module Mapper : Output_Manager_0 : ext} \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/CLK \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/RESET \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/READY \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EVENT_DATA_IN \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/R_START_CNTRL \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/R_DONE_OMGR \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/RW_MODE \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/R_INDEX \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_ID \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_RE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/HIT_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/HIT_ADDR \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/HIT_COUNT \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/VALID_DATA \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EDGE_CALC_RESET \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EDGE_CALC_READY \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/EDGE_CALC_WREN \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_OUT \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_ADDR \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_INFO \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/MODULE_DATA_WE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/READ_DONE \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/DEBUG

add wave -group {Module Mapper : Output_Manager_0 : int} \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/output_manager_state \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/output_manager_rtn_state \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/module_map_din \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/module_map_dout \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/module_map_addr \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/module_map_we \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/mmw_io_flag \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/mmw_incount \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/mmw_layer_id \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/mmw_module_id \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/io_flag \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/hit_count \
-radix hex /graph_constructor_tb/UUT/module_mapper_0/output_manager_0/module_count \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/read_buffer_index \
/graph_constructor_tb/UUT/module_mapper_0/output_manager_0/edge_calc_index
