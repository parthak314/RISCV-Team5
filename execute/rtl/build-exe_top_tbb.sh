rm -rf obj_dir
verilator -Wall --cc --trace execute_top.sv adder.sv alu.sv execute_pipeline_regfile.sv mux.sv --exe ../tb/execute_top_tbb.cpp
make -j -C obj_dir/ -f Vexecute_top.mk Vexecute_top
obj_dir/Vexecute_top