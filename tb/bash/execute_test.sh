rm -rf obj_dir/

verilator   -Wall --trace --cc ../rtl/execute/execute_top.sv \
            -y ../rtl/ \
            --exe ./our_tests/execute_tb.cpp \
            --prefix "Vdut" \
            -o Vdut \
            -LDFLAGS "-lgtest -lgtest_main -lpthread" \

make -j -C obj_dir/ -f Vdut.mk Vdut
obj_dir/Vdut