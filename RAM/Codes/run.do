vlib work
vlog -f src_files.list  +cover -covercells
vsim -voptargs=+acc work.TOP -cover -classdebug -uvmcontrol=all
coverage exclude -src ram.sv -line 42 -code s
coverage exclude -src ram.sv -line 42 -code b
do wave.do
coverage save RAM_Coverage.ucdb -onexit
run -all

#quit -sim
# Code Coverage Report 
#vcover report RAM_Coverage.ucdb \-codeAll -details -annotate -output RAM_code_coverage_report.txt
#
##Assertion Coverage Report
#vcover report RAM_Coverage.ucdb \-assert -details -annotate -output RAM_assertion_coverage_report.txt
#
##Functional Coverage Report
#vcover report RAM_Coverage.ucdb \-cvg -details -annotate -output RAM_functional_coverage_report.txt
