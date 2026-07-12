onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TOP/r_if/clk
add wave -noupdate /TOP/r_if/rst_n
add wave -noupdate -radix binary /TOP/r_if/din
add wave -noupdate /TOP/r_if/rx_valid
add wave -noupdate /TOP/r_if/dout
add wave -noupdate /TOP/r_if/tx_valid
add wave -noupdate -divider {RAM & internal signals}
add wave -noupdate /TOP/DUT/Wr_Addr
add wave -noupdate /TOP/DUT/Rd_Addr
add wave -noupdate /TOP/DUT/MEM
add wave -noupdate -divider {Golden Model Outputs}
add wave -noupdate /TOP/r_if/dout_golden
add wave -noupdate /TOP/r_if/tx_valid_golden
add wave -noupdate -divider Counters
add wave -noupdate /ram_scoreboard_pkg::correct_count
add wave -noupdate /ram_scoreboard_pkg::error_count
add wave -noupdate -divider Assertions
add wave -noupdate /ram_sequence_pkg::ram_write_only_sequence::body/#ublk#33711751#41/immed__45
add wave -noupdate /ram_sequence_pkg::ram_read_only_sequence::body/#ublk#33711751#65/immed__69
add wave -noupdate /ram_sequence_pkg::ram_write_read_sequence::body/#ublk#33711751#89/immed__93
add wave -noupdate /TOP/DUT/ram_assertions/reset
add wave -noupdate /TOP/DUT/ram_assertions/tx_valid_low
add wave -noupdate /TOP/DUT/ram_assertions/tx_valid_rise_fall
add wave -noupdate /TOP/DUT/ram_assertions/wa_wd
add wave -noupdate /TOP/DUT/ram_assertions/ra_rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {139990 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {139988 ns} {140003 ns}
