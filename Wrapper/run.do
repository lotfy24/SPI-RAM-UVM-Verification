vlib work
vlog -f src_files.list +cover=sbfec -coveropt 3 +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -sv_seed 1000754857 -l sim.log -coverage -assertdebug -do "coverage save -onexit coverage.ucdb"
#interestiong seeds 376014177 906904221 1000754857
#add wave /top/SPIIF/*
#add wave /top/r_if/*
#add wave /top/wrapper_vif/*
do wave.do
run -all

#coverage save coverage_final.ucdb
#coverage report -detail -cvg -directive -comments -file assertions_coverage_report.txt -instance=/top/DUT/ALSU_ASSERT
#coverage report -detail -cvg -comments -file functional_coverage_report.txt
#coverage report -detail -code bcefs -file code_coverage_report.txt -du=SPI
#coverage report -detail -file combined_coverage_summary.txt

#quit -f