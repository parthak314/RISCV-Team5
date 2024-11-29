rm -rf obj_dir
verilator   -Wall --cc --trace ../rtl/execute_top.sv \
            -y ../rtl/ \
            --exe ./our_tests/sim_execute.cpp \
            
make -j -C obj_dir/ -f Vexecute_top.mk Vexecute_top
obj_dir/Vexecute_top