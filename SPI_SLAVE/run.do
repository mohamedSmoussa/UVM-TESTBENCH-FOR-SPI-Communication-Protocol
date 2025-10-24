vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.spi_top -classdebug -uvmcontrol=all -sv_seed random -cover
run 0
add wave -position insertpoint \
sim:/spi_top/Golden/MOSI \
sim:/spi_top/DUT/MOSI \
sim:/spi_top/Golden/MISO \
sim:/spi_top/DUT/MISO \
sim:/spi_top/Golden/SS_n \
sim:/spi_top/DUT/SS_n \
sim:/spi_top/Golden/tx_valid \
sim:/spi_top/DUT/tx_valid \
sim:/spi_top/Golden/rx_valid \
sim:/spi_top/DUT/rx_valid \
sim:/spi_top/Golden/rx_data \
sim:/spi_top/DUT/rx_data \
sim:/spi_top/Golden/cs \
sim:/spi_top/DUT/cs \
sim:/spi_top/Golden/ns \
sim:/spi_top/DUT/ns \
sim:/spi_top/Golden/rst_n \
sim:/spi_top/Golden/clk \
sim:/spi_top/Golden/tx_data
add wave -position insertpoint \
sim:/spi_shared::cs_s \
sim:/spi_shared::ns_s
add wave  -position insertpoint \
sim:/uvm_root/uvm_test_top/env/sb/correct_count \
sim:/uvm_root/uvm_test_top/env/sb/error_count
run -all
coverage exclude -src SPI_slave.sv -line 39 -code s
coverage exclude -src SPI_slave.sv -line 38 -code b
coverage exclude -src SPI_slave.sv -line 81 -code b
coverage save SPI.ucdb -onexit -du work.SLAVE
coverage report -detail -cvg -directive -comments -output SPI_fcover_report.txt {}
quit -sim 
vcover report SPI.ucdb -details -annotate -all -output SPI_co.txt 