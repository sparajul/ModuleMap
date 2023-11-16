######################################################################
#
# File name : concatenator_wave.do
# Created on: Sun Apr 03 19:58:06 -0500 2022
#
# Manual wave file for 'behavioral' simulation
#
######################################################################
##if { [catch {[add wave *]}] } {}


#############################
## Testbench
#############################

add wave -divider {Testbench}
add wave -color yellow /concatenator_tb/clk
add wave -color yellow /concatenator_tb/reset
add wave -color magenta /concatenator_tb/ready
add wave -color magenta /concatenator_tb/start
add wave -color magenta /concatenator_tb/done

add wave -color white /concatenator_tb/edge_data_ready
add wave -color white /concatenator_tb/edge_data_count
add wave -color white /concatenator_tb/edge_re
add wave -color white /concatenator_tb/edge_data_out
add wave -color white /concatenator_tb/adj_id_out


add wave -group {Testbench : int} -color white /concatenator_tb/fr_state
add wave -group {Testbench : int} -color white /concatenator_tb/wait_count

add wave -group {Testbench : int} -color white /concatenator_tb/edge_calc_num
add wave -group {Testbench : int} -color white /concatenator_tb/edge_calc_index
add wave -group {Testbench : int} -color white /concatenator_tb/edge_word_count
add wave -group {Testbench : int} -color white /concatenator_tb/tb_edge_count
add wave -group {Testbench : int} -color white /concatenator_tb/tb_wait

#add wave -radix hex -group {Testbench : int} -color green /concatenator_tb/file_reader_process/file_line
#add wave -radix hex -group {Testbench : int} -color green /concatenator_tb/file_reader_process/data_line
add wave -radix hex -group {Testbench : int} -color green /concatenator_tb/file_reader_process/read_count
add wave -radix hex -group {Testbench : int} -color white /concatenator_tb/file_reader_process/input_data_word_1
add wave -radix hex -group {Testbench : int} -color white /concatenator_tb/file_reader_process/input_data_word_2



#############################
## Summary
#############################
#add wave -divider {Summary}


#############################
## Concatenator Top (UUT)
#############################
add wave -group {Concatenator : ext} -color yellow /concatenator_tb/UUT/CLK
add wave -group {Concatenator : ext} -color yellow /concatenator_tb/UUT/RESET
add wave -group {Concatenator : ext} -color magenta /concatenator_tb/UUT/READY
add wave -group {Concatenator : ext} -color magenta /concatenator_tb/UUT/START
add wave -group {Concatenator : ext} -color magenta /concatenator_tb/UUT/DONE

add wave -group {Concatenator : ext} -color green /concatenator_tb/UUT/EDGE_DATA_READY
add wave -radix hex -group {Concatenator : ext} -color green /concatenator_tb/UUT/EDGE_DATA_COUNT
add wave -radix hex -group {Concatenator : ext}  /concatenator_tb/UUT/EDGE_DATA_IN
add wave -radix hex -group {Concatenator : ext} -color green /concatenator_tb/UUT/ADJ_ID_IN
add wave -group {Concatenator : ext} -color green /concatenator_tb/UUT/EDGE_RE

add wave -radix hex -group {Concatenator : ext}  /concatenator_tb/UUT/EDGE_DATA_OUT
add wave -radix hex -group {Concatenator : ext} -color green /concatenator_tb/UUT/ADJ_ID_OUT

add wave -group {Concatenator : int} -color white /concatenator_tb/UUT/concatenator_state
add wave -group {Concatenator : int} -color white /concatenator_tb/UUT/concatenator_rtn_state
add wave -radix hex -group {Concatenator : int} -color green /concatenator_tb/UUT/wait_count
add wave -group {Concatenator : int} -color white /concatenator_tb/UUT/rd_index
add wave -group {Concatenator : int} -color white /concatenator_tb/UUT/edge_count
add wave -group {Concatenator : int} -color white /concatenator_tb/UUT/rd_count
add wave -radix hex -group {Concatenator : int} -color green /concatenator_tb/UUT/edge_dina
add wave -radix hex -group {Concatenator : int} -color green /concatenator_tb/UUT/adj_dina
add wave -radix hex -group {Concatenator : int} -color green /concatenator_tb/UUT/edge_addr
add wave -group {Concatenator : int} -color white /concatenator_tb/UUT/edge_logic_we(0)



