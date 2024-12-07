#include <iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vexecute_top.h"

int main(int argc, char **argv, char **env)
{
    int simcyc;
    int tick;

    Verilated::commandArgs(argc, argv);
    Vexecute_top *top = new Vexecute_top;
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("execute_top_tbb_waveform.vcd");

    top->clk = 0;

    top->ALUSrcE = 0;
    top->ALUControlE = 0b0000;
    top->RD1E = 5;
    top->RD2E = 2;


    for (simcyc = 0; simcyc <= 2; simcyc++)
    {
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        std::cout << "ALUResultM register: " << top->ALUResultM << std::endl;
        
        if (Verilated::gotFinish())
            exit(0);
    }

    tfp->close();
    exit(0);
}