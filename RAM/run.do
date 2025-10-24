vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover 
run 0
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/correct_count \
sim:/uvm_root/uvm_test_top/env/sb/error_count
add wave -position insertpoint  \
sim:/top/dut/din \
sim:/top/dut/rx_valid \
sim:/top/dut/dout \
sim:/top/dut/tx_valid \
sim:/top/dut/Rd_Addr \
sim:/top/dut/Wr_Addr 
add wave -position insertpoint  \
sim:/top/golden_model/din \
sim:/top/golden_model/rx_valid \
sim:/top/golden_model/dout \
sim:/top/golden_model/tx_valid \
sim:/top/golden_model/wr_Addr \
sim:/top/golden_model/rd_Addr 
run -all
coverage exclude -src RAM.sv -line 34 -code s
coverage exclude -src RAM.sv -line 34 -code b
coverage save RAM.ucdb -onexit -du work.RAM
coverage report -detail -cvg -directive -comments -output RAM_fcover_report.txt {}
quit -sim
vcover report RAM.ucdb -details -annotate -all -output RAM_co.txt 
