rm -rf obj_dir/

verilator   -Wall --trace --cc *.sv \
            -y . \
            --exe ../tb/verify_exe_top.cpp \
            --prefix "Vdut" \
            -o Vdut \
            -LDFLAGS "-lgtest -lgtest_main -lpthread" \

make -j -C obj_dir/ -f Vdut.mk Vdut
obj_dir/Vdut