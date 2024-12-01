#!/bin/bash

# Cleanup previous build artifacts
rm -rf obj_dir

# Translate Verilog -> C++ including all required source files
verilator -Wall --trace \
          -cc ../../rtl/data_top.sv ../../rtl/control.sv ../../rtl/reg_file.sv ../../rtl/signextend.sv \
          --exe ../tests/data_top_test_tb.cpp \
          -o Vdata_top \
          -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Check if compilation was successful
if [ $? -ne 0 ]; then
    echo "Verilator compilation failed!"
    exit 1
fi

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vdata_top.mk

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Makefile build failed!"
    exit 1
fi

# Run executable simulation file
./obj_dir/Vdata_top

# Check if the simulation ran successfully
if [ $? -ne 0 ]; then
    echo "Simulation failed!"
    exit 1
fi

echo "Simulation completed successfully!"
