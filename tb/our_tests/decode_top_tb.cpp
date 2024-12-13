#include "gtest/gtest.h"
#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class TestDut : public ::testing::Test
{
public:
    void SetUp() override
    {
        initializeInputs();
       // runReset();
    }

    void TearDown() override
    {
    }

    void initializeInputs()
    {
    top->clk= 0;
    top->stall= 0;
    top->reset= 0;
    top->InstrD= 0;
    top->PCD= 0;
    top->PCPlus4D= 0;
    top->RegWriteW= 0;
    top->ResultW= 0;
    top->RdW= 0;
    top->PCSrcE= 0;
    }


    // Runs the simulation for a clock cycle, evaluates the top, dumps waveform.
    void runSimulation()
    {
        for (int clk = 0; clk < 2; clk++)
        {
            top->eval();
            tfp->dump(2 * ticks + clk);
            top->clk = !top->clk;
        }
        ticks++;

        if (Verilated::gotFinish())
        {
            exit(0);
        }
    }
};


TEST_F(TestDut, InstructionDecoding) {
    top->InstrD = 0x001000B3;
    runSimulation();
    EXPECT_EQ(top->ALUSrcE, 0);
    EXPECT_EQ(top->MemWriteE, 0);
}

TEST_F(TestDut, ImmediateExtension) {
    top->InstrD = 0x00500113;  // addi x1, x0, 5
    runSimulation();
    runSimulation();
    EXPECT_EQ(top->ImmExtE, 0x5);
}




TEST_F(TestDut, ShiftOperations) {
    top->InstrD = 0x001081B3; // sll x3, x1, x2 (x3 = x1 << x2)
    top->ResultW = 0;
    runSimulation();

    top->InstrD = 0x0010A1B3; // srl x3, x1, x2 (x3 = x1 >> x2)
    top->ResultW = 0;
    runSimulation();

    top->InstrD = 0x4010A1B3; // sra x3, x1, x2 (x3 = x1 >>> x2)
    top->ResultW = 0;
    runSimulation();

    EXPECT_EQ(top->RD1E, 0);
}



int main(int argc, char **argv)
{
    top = new Vdut;
    tfp = new VerilatedVcdC;

    Verilated::traceEverOn(true);
    top->trace(tfp, 99);
    tfp->open("memory.vcd");

    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();

    top->final();
    tfp->close();

    delete top;
    delete tfp;

    return res;
}