vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.wrapper_top -classdebug -uvmcontrol=all -cover -sv_seed random 
run 0
add wave -position insertpoint  \
sim:/wrapper_shared::cs_s  \
sim:/wrapper_shared::ns_s
add wave -position insertpoint  \
sim:/wrapper_top/DUT/MISO  \
sim:/wrapper_top/DUT/tx_valid \
sim:/wrapper_top/DUT/tx_data_dout \
sim:/wrapper_top/DUT/rx_valid \
sim:/wrapper_top/DUT/rx_data_din \
sim:/wrapper_top/DUT/rst_n \
sim:/wrapper_top/DUT/MOSI \
sim:/wrapper_top/DUT/SS_n \
sim:/wrapper_top/DUT/clk  
add wave -position insertpoint  \
sim:/wrapper_top/Golden/MISO  \
sim:/wrapper_top/Golden/tx_valid \
sim:/wrapper_top/Golden/tx_data \
sim:/wrapper_top/Golden/rx_valid \
sim:/wrapper_top/Golden/rx_data 
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/wr_env/sb/correct_count \
sim:/uvm_root/uvm_test_top/wr_env/sb/error_count
run -all
coverage exclude -src RAM.sv -line 34 -code b
coverage exclude -src SPI_slave.sv -line 38 -code b
coverage exclude -src SPI_slave.sv -line 39 -code s
coverage exclude -src SPI_slave.sv -line 81 -code b
coverage exclude -src RAM.sv -line 34 -code s
coverage save wrapper.ucdb -onexit -du work.WRAPPER
coverage report -detail -cvg -directive -comments -output wrapper_fcover_report.txt {}
quit -sim
vcover report wrapper.ucdb -details -annotate -all -output wrapper_co.txt 

