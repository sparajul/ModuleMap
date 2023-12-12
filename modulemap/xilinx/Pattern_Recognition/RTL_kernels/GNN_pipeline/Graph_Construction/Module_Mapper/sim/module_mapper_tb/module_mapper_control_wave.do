######################################################################
#
# File name : graph_constructor_wave.do
# Created on: Sun Apr 03 19:58:06 -0500 2022
#
# Manual wave file for 'behavioral' simulation
#
######################################################################
##if { [catch {[add wave *]}] } {}

## Contoller State Machine ##################################################
add wave -group {Control Processes} -divider {Controller Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/wbuf_empty_hbufr(0)
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/rbuf_ready_hbufr(0)
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/w_done_dcdr
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/r_done_omgr
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/flag_reset_done_hbufr
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/controller_0/buf_data_flag

## States
add wave -group {Control Processes} /module_mapper_tb/UUT/controller_0/control_state

## Outputs
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/rw_mode_cntrl(0)
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/w_start_cntrl
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/r_start_cntrl
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/flag_reset_cntrl

## Hit Buffer 0 State Machines ##################################################
## Write #########
add wave -group {Control Processes} -divider {Hit Buffer 0 : Write Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/rw_mode_cntrl(0)
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/raw_we_dcdr
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/event_we_dcdr
add wave -group {Control Processes} -color white  /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/mw_flag_in

## States
add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/write_state

## Outputs
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_raw_addr
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_hit_count
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/rbuf_ready_hbufr(0)
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/rbuf_ready_set

## Read #########
add wave -group {Control Processes} -divider {Hit Buffer 0 : Read Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/rw_mode_cntrl(0)
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/module_re_omgr
add wave -group {Control Processes} -color yellow -radix hex /module_mapper_tb/UUT/module_id_omgr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/raw_rd_addr
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/raw_hit_count

## States
add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/read_state

## Outputs
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/read_done_hbufr(0)
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/valid_data_hbufr(0)
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/wbuf_empty_hbufr(0)
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_rd_addr
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/rbuf_ready_clr
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/ibuf_ready_set

## Inferencing #########
add wave -group {Control Processes} -divider {Hit Buffer 0 : Inference Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/rw_mode_cntrl(0)
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/i_done_infr

## States
add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/iread_state

## Outputs
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/ibuf_ready_hbufr(0)
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/wbuf_empty_hbufr(0)
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/wbuf_empty_set
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/ibuf_ready_clr


## Reset #########
add wave -group {Control Processes} -divider {Hit Buffer 0 : Flag Reset Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/flag_reset_cntrl(0)
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_reset_addr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_we_mux(0)
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_we_mux(0)
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_rd_addr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_addr_mux
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/index_addr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_dout
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_din
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag
add wave -group {Control Processes} -radix dec -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_set
## States
add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(0)/hit_buffer_gen/flag_state

## Outputs
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/flag_reset_done_hbufr(0)

## Hit Buffer 1 State Machines ##################################################
## Write #########
add wave -group {Control Processes} -divider {Hit Buffer 1 : Write Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/rw_mode_cntrl(1)
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/raw_we_dcdr
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/event_we_dcdr
add wave -group {Control Processes} -color white  /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/mw_flag_in

## States
add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/write_state

## Outputs
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_raw_addr
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_hit_count
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/rbuf_ready_hbufr(1)
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/rbuf_ready_set

## Read #########
add wave -group {Control Processes} -divider {Hit Buffer 1 : Read Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/rw_mode_cntrl(1)
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/module_re_omgr
add wave -group {Control Processes} -color yellow -radix hex /module_mapper_tb/UUT/module_id_omgr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/raw_rd_addr
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/raw_hit_count

## States
add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/read_state

## Outputs
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/read_done_hbufr(1)
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/valid_data_hbufr(1)
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/wbuf_empty_hbufr(1)
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_rd_addr
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/rbuf_ready_clr

## Reset #########
add wave -group {Control Processes} -divider {Hit Buffer 1 : Flag Reset Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Inputs
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/flag_reset_cntrl(1)
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_reset_addr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_we_mux(0)
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_we_mux(0)
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_rd_addr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_addr_mux
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/index_addr
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_dout
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_din
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag
add wave -group {Control Processes} -radix dec -color white /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_set
## States
add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/GEN_HIT_BUFFER(1)/hit_buffer_gen/flag_state

## Outputs
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/flag_reset_done_hbufr(1)

## Output Manager State Machines ##################################################
add wave -group {Control Processes} -divider {Output Manager Process}
add wave -group {Control Processes} /module_mapper_tb/UUT/CLK

## Input
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/r_start_cntrl
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/EDGE_CALC_READY
add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/read_done_hbufr(0)
#add wave -group {Control Processes} -color yellow /module_mapper_tb/UUT/valid_data_hbufr(0)

add wave -group {Control Processes} -color white /module_mapper_tb/UUT/output_manager_0/edge_calc_index
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/output_manager_0/read_buffer_index
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/output_manager_0/wait_count
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/output_manager_0/module_map_din
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/output_manager_0/module_map_dout
add wave -group {Control Processes} -color white /module_mapper_tb/UUT/output_manager_0/mmw_io_flag
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/output_manager_0/mmw_incount
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/output_manager_0/mmw_layer_id
add wave -group {Control Processes} -color white -radix hex /module_mapper_tb/UUT/output_manager_0/mmw_module_id

## States
add wave -group {Control Processes} /module_mapper_tb/UUT/output_manager_0/output_manager_state
add wave -group {Control Processes} /module_mapper_tb/UUT/output_manager_0/output_manager_rtn_state

## Output
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/r_done_omgr
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/output_manager_0/module_map_addr
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/module_id_omgr
add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/module_re_omgr
#add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/output_manager_0/hit_data_int
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/MODULE_DATA_OUT
add wave -group {Control Processes} -color magenta -radix hex /module_mapper_tb/UUT/MODULE_DATA_WE

#add wave -group {Control Processes} -color magenta /module_mapper_tb/UUT/output_manager_0/module_map_we(0)
#add wave -group {Control Processes} -radix hex /module_mapper_tb/UUT/hit_data_hbufr(0)