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
        top->ALUResult = 0;
        top->WriteData = 0;
        top->ResultSrc = 0;
        top->clk = 0;
    }


    // Runs the simulation for a clock cycle, evaluates the DUT, dumps waveform.
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

TEST_F(TestDut, MuxDatatest)
{
    top->ALUResult = 0b11;
    top->WriteData = 20;
    top->MemWrite = 1;
    top->ResultSrc = 1;
    runSimulation();
    EXPECT_EQ(top->Result, 20);
}

TEST_F(TestDut, MuxALUtest)
{
    top->ALUResult = 0x00010003;
    top->ResultSrc = 0;
    runSimulation();
    EXPECT_EQ(top->Result, 0x00010003);
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