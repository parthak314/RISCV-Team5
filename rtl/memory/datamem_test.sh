#!/bin/bash

# Translate Verilog -> C++ including testbench
verilator   -Wall --trace \
            -cc ram2port.sv \
            --exe datamem_test_tb.cpp \
            --prefix "Vram2port" \
            -o Vram2port \
            -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vram2port.mk

# Run executable simulation file
./obj_dir/Vram2port