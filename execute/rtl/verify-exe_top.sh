rm -rf obj_dir/

verilator   -Wall --cc --trace execute_top.sv adder.sv alu.sv execute_pipeline_regfile.sv mux.sv \
            --exe ../tb/verify_exe_top.cpp \
            --prefix "Vdut" \
            -o Vdut \
            -LDFLAGS "-lgtest -lgtest_main -lpthread" \

make -j -C obj_dir/ -f Vdut.mk Vdut
obj_dir/Vdut