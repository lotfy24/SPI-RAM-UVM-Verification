onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/SPIIF/clk
add wave -noupdate /top/r_if/rst_n
add wave -noupdate /top/SPIIF/SS_n
add wave -noupdate -divider {New Divider}
add wave -noupdate /top/SPIIF/tx_data
add wave -noupdate /top/r_if/dout_golden
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix binary /top/SPIIF/rx_data
add wave -noupdate -radix binary /top/SPIIF/rx_data_gld
add wave -noupdate -divider {New Divider}
add wave -noupdate /top/SPIIF/rx_valid
add wave -noupdate /top/SPIIF/rx_valid_gld
add wave -noupdate -divider {New Divider}
add wave -noupdate /top/r_if/tx_valid
add wave -noupdate /top/r_if/tx_valid_golden
add wave -noupdate -divider {New Divider}
add wave -noupdate /top/SPIIF/MISO
add wave -noupdate /top/wrapper_vif/MISO_gld
add wave -noupdate -divider -height 25 {INTERNAL SIGNALS}
add wave -noupdate /top/SPIIF/MOSI
add wave -noupdate -divider {New Divider}
add wave -noupdate /top/wrapper_inst/SLAVE_instance/cs
add wave -noupdate /top/wrapper_inst_golden/SLAVE_instance_golden/cs
add wave -noupdate /top/wrapper_inst/SLAVE_instance/ns
add wave -noupdate /top/wrapper_inst_golden/SLAVE_instance_golden/ns
add wave -noupdate /top/wrapper_inst/SLAVE_instance/counter
add wave -noupdate /top/wrapper_inst_golden/SLAVE_instance_golden/counter
add wave -noupdate /top/wrapper_inst/SLAVE_instance/received_address
add wave -noupdate /top/wrapper_inst_golden/SLAVE_instance_golden/Recieved_address
add wave -noupdate /shared_pkg::prev_operation
add wave -noupdate /shared_pkg::flag
add wave -noupdate -color White -radix unsigned /shared_pkg::counter_SS_N_SHARED
add wave -noupdate -radix unsigned /shared_pkg::cmd_shared
add wave -noupdate /shared_pkg::f_read_addr_shared
add wave -noupdate /shared_pkg::f_read_data_shared
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4989 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 203
configure wave -valuecolwidth 173
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
WaveRestoreZoom {4989 ns} {5017 ns}
