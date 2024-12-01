#!/bin/bash

# Translate Verilog -> C++ including testbench
verilator -Wall --trace \
          -cc signextend.sv \
          --exe signextend_test_tb.cpp \
          -o Vsignextend \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vsignextend.mk

# Run executable simulation file
./obj_dir/Vsignextend