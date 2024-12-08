#!/bin/bash
# cleanup
rm -rf obj_dir

# Translate Verilog -> C++ including testbench
verilator -Wall --trace \
          -cc two_way_cache_top.sv \
          --exe two_way_cache_top_test.cpp \
          -y ../ \
          -o Vtwo_way_cache_top \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vtwo_way_cache_top.mk

# Run executable simulation file
./obj_dir/Vtwo_way_cache_top