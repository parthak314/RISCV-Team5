#!/bin/sh

# cleanup
rm -rf obj_dir
rm -f 5_pdf.vcd

# run Verilator to translate Verilog into C++, including C++ testbench
verilator -Wall -cc --trace ../rtl/top.sv --exe ./pdf_test/pdf_tb.cpp -y ../rtl/ --prefix "Vdut"

# build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f Vdut.mk Vdut

# run executable simulation file
obj_dir/Vdut