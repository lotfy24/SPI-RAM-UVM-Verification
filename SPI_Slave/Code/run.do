vlib work
vlog -f src_files.list +cover=sbfec -coveropt 3 +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -sv_seed 906904221 -l sim.log -coverage -assertdebug -do "coverage save -onexit coverage.ucdb"
#interestiong seeds 376014177 906904221 17147361
#add wave /top/SPIIF/*
do wave.do
run -all
#default case of the branches 
#coverage exclude -src SPI_slave.sv -line 165 -code b
#coverage exclude -src SPI_slave.sv -line 221 -code b
#coverage exclude -src SPI_slave.sv -line 175 -code b
#coverage exclude -src SPI_slave.sv -line 231 -code b

#coverage save coverage_final.ucdb
#coverage report -detail -cvg -directive -comments -file assertions_coverage_report.txt -instance=/top/SPI_SLAVE/SPI_ASSERT
#coverage report -detail -cvg -directive -comments -file spi_slave_assertions_coverage_report.txt -instance=/top/SPI_SLAVE
#coverage report -detail -cvg -comments -file functional_coverage_report.txt
#coverage report -detail -code bcefs -file code_coverage_report.txt -du=SLAVE
#coverage report -detail -file combined_coverage_summary.txt

#quit -f