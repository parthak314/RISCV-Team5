#!/bin/bash

# Cleanup previous build artifacts
rm -rf obj_dir

# Translate Verilog -> C++ including all required source files
verilator   -Wall -cc --trace \
<<<<<<< HEAD:tb/bash/data_top_test.sh
            ../rtl/data/data_top.sv \
            --exe ../our_tests/data_top_test_tb.cpp \
=======
            ../rtl/decode_top.sv \
            --exe ../our_tests/decode_top_test_tb.cpp \
>>>>>>> 6cd110b (rename data -> decode):tb/bash/decode_top_test.sh
            -y ../rtl/ \
            --prefix "Vdut" \
            -o Vdut -LDFLAGS "-lgtest -lgtest_main -lpthread"

# Check if compilation was successful
if [ $? -ne 0 ]; then
    echo "Verilator compilation failed!"
    exit 1
fi

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vdecode_top.mk

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Makefile build failed!"
    exit 1
fi

# Run executable simulation file
./obj_dir/Vdecode_top

# Check if the simulation ran successfully
if [ $? -ne 0 ]; then
    echo "Simulation failed!"
    exit 1
fi

echo "Simulation completed successfully!"
