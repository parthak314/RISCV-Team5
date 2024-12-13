#!/bin/bash

# cleanup
rm -rf obj_dir
rm -f *.vcd

find ../rtl -type f -name "*.sv" > filelist.f

# Translate Verilog -> C++ including testbench
verilator   -Wall --trace \
            -cc ../rtl/memory/two_way_cache_top.sv \
            --exe ./our_tests/cache_top_tb.cpp \
            -f filelist.f \
            --top-module two_way_cache_top \
            --prefix "Vdut" \
            -o Vdut \
            -CFLAGS "-isystem /opt/homebrew/Cellar/googletest/1.15.2/include"\
            -LDFLAGS "-L/opt/homebrew/Cellar/googletest/1.15.2/lib -lgtest -lgtest_main -lpthread" \

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vdut.mk

# Run executable simulation file
./obj_dir/Vdut