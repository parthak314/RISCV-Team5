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
        top->a = 0;
        top->wd = 0;
        top->we = 0;
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

TEST_F(TestDut, Readtest)
{
    top->a = 1;
    top->we = 1;
    top->wd = 0b10;
    runSimulation();
    EXPECT_EQ(top->rd, 0b10);
}

TEST_F(TestDut, Writetest)
{
    top->a = 0b11;
    top->wd = 20;
    top->we = 1;
    runSimulation();
    EXPECT_EQ(top->rd, 20);
}

TEST_F(TestDut, Loadtest)
{
    top->a = 0x00010003; 
    runSimulation();
    EXPECT_EQ(top->rd, 0x00000004);
}

int main(int argc, char **argv)
{
    top = new Vdut;
    tfp = new VerilatedVcdC;

    Verilated::traceEverOn(true);
    top->trace(tfp, 99);
    tfp->open("datamem.vcd");

    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();

    top->final();
    tfp->close();

    delete top;
    delete tfp;

    return res;
}