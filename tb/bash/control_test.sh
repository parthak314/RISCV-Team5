#!/bin/bash
# cleanup
rm -rf obj_dir

# Translate Verilog -> C++ including testbench
verilator -Wall --trace \
          -cc ../rtl/control.sv \
          --exe ../our_tests/control_test_tb.cpp \
          -o Vcontrol \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vcontrol.mk

# Run executable simulation file
./obj_dir/Vcontrol