onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/SPIIF/clk
add wave -noupdate /top/SPIIF/rst_n
add wave -noupdate -divider -height 25 INPUTS
add wave -noupdate /top/SPIIF/MOSI
add wave -noupdate /top/SPIIF/SS_n
add wave -noupdate /top/SPIIF/tx_valid
add wave -noupdate -radix binary /top/SPIIF/tx_data
add wave -noupdate -divider OUTPUTS
add wave -noupdate -radix binary /top/SPIIF/rx_data
add wave -noupdate -radix binary /top/SPIIF/rx_data_gld
add wave -noupdate /top/SPIIF/rx_valid
add wave -noupdate /top/SPIIF/MISO
add wave -noupdate /top/SPIIF/rx_valid_gld
add wave -noupdate /top/SPIIF/MISO_gld
add wave -noupdate /top/clk
add wave -noupdate -divider -height 25 {INTERNAL SIGNAL}
add wave -noupdate /top/SPI_SLAVE/cs
add wave -noupdate /top/GLD/cs
add wave -noupdate /top/SPI_SLAVE/ns
add wave -noupdate /top/GLD/ns
add wave -noupdate /top/SPI_SLAVE/counter
add wave -noupdate /top/GLD/counter
add wave -noupdate /top/SPI_SLAVE/received_address
add wave -noupdate /top/GLD/Recieved_address
add wave -noupdate /SPI_shared_pkg::MOSI_arr_shared
add wave -noupdate -radix binary /SPI_shared_pkg::MOSI_arr_shared
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24101 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 268
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
WaveRestoreZoom {8006 ns} {8094 ns}
