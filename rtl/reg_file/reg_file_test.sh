#!/bin/bash

# Translate Verilog -> C++ including testbench
verilator -Wall --trace \
          -cc reg_file.sv \
          --exe reg_file_test_tb.cpp \
          -o Vreg_file \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vreg_file.mk

# Run executable simulation file
./obj_dir/Vreg_file