#include <iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdut.h"
#include "Vdut__Syms.h"

int main(int argc, char **argv, char **env)
{
    int simcyc;
    int tick;
    std::unique_ptr<Vdut> top;
    std::unique_ptr<VerilatedVcdC> tfp;
    top = std::make_unique<Vdut>();
    tfp = std::make_unique<VerilatedVcdC>();

    Verilated::traceEverOn(true);
    top->trace(tfp.get(), 99);
    tfp->open("riscv.vcd");

    top->clk = 0;
    // VlUnpacked<IData/*31:0*/, 32>& reg_file = top->rootp->riscv_top__DOT__data__DOT__register_file_mod__DOT__reg_file;
    // uint32_t& A0 = reg_file[10];
    // uint32_t& T1 = reg_file[6];

    for (simcyc = 0; simcyc <= 50; simcyc++)
    {
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        // std::cout << "T1: " << T1 << std::endl;

        if (Verilated::gotFinish())
            exit(0);
    }

    // std::cout << "A0: " << A0 << std::endl;

    tfp->close();
    exit(0);
}