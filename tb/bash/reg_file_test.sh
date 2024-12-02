#!/bin/bash
# cleanup
rm -rf obj_dir

# Translate Verilog -> C++ including testbench
verilator -Wall --trace \
          -cc ../rtl/reg_file.sv \
          --exe ../our_tests/reg_file_test_tb.cpp \
          -o Vreg_file \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vreg_file.mk

# Run executable simulation file
./obj_dir/Vreg_file