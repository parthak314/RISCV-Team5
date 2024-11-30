#!/bin/bash

# Translate Verilog -> C++ including testbench
verilator -Wall --trace \
          -cc control.sv \
          --exe control_test_tb.cpp \
          -o Vcontrol \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vcontrol.mk

# Run executable simulation file
./obj_dir/Vcontrol