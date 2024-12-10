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
    // tfp->open("riscv.vcd");

    top->MemoryOp           = 0b001;
    top->ByteOffset         = 0b01;
    top->MemReadOutData     = 0xAB'CD'EF'69;
    top->WriteData          = 0x12'34'56'FF;
    
    top->eval();

    printf("input read in: %08X\n", top->MemReadOutData);
    printf("input write in: %08X\n", top->WriteData);

    printf("LOAD READ DATA: %08X\n", top->ReadData);
    printf("STORE WRITE DATA: %08X\n", top->MemWriteInData);

    tfp->close();
    exit(0);
}