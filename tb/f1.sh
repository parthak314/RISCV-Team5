#!/bin/bash

# cleanup
rm -rf obj_dir
rm -f *.vcd

# Translate Verilog -> C++ including testbench
verilator   -Wall --trace \
            -cc ../rtl/top.sv ../rtl/alu.sv ../rtl/mux.sv ../rtl/branch_logic.sv ../rtl/datamem.sv ../rtl/instr_mem.sv ../rtl/mux.sv ../rtl/pc_register.sv ../rtl/reg_file.sv ../rtl/signextend.sv\
            --exe ./our_tests/memory_tb.cpp \
            --prefix "Vtop" \
            -o Vtop \
            -CFLAGS "-isystem /opt/homebrew/Cellar/googletest/1.15.2/include"\
            -LDFLAGS "-L/opt/homebrew/Cellar/googletest/1.15.2/lib -lgtest -lgtest_main -lpthread" \

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vtop.mk

# Run executable simulation file
./obj_dir/Vtop