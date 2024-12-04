#!/bin/bash
# cleanup
rm -rf obj_dir

# Translate Verilog -> C++ including testbench
verilator -Wall --trace \
          -cc ../rtl/data/signextend.sv \
          --exe ../our_tests/signextend_test_tb.cpp \
          -o Vsignextend \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vsignextend.mk

# Run executable simulation file
./obj_dir/Vsignextend