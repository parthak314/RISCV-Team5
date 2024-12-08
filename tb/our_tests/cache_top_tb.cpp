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
        top->clk = 0;
        top->addr_mode = 0;
        top->wd = 0;
        top->we = 0;
        top->addr = 0;
        top->rd_from_ram = 0;
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

TEST_F(TestDut, WriteWordTest)
{
    // write and fill both ways in set
    top->rd_from_ram = 100;
    top->wd = 20;
    top->we = 1;
    top->addr = 0x0004;
    runSimulation();
    top->addr = 0x0804;
    top->we = 1;
    top->wd = 30;
    runSimulation();
    // kick out the word at address 0x0004
    top->addr = 0x1804;
    top->wd = 55;
    top->we = 1;
    runSimulation();

    // check that we are correctly reading the kicked out word
    top->we = 0;
    top->addr = 0x0004;
    top->eval();
    EXPECT_EQ(top->rd, 100);
    runSimulation();
    top->addr = 0x0804;
    top->eval();
    EXPECT_EQ(top->rd, 100);
    runSimulation();
}

int main(int argc, char **argv)
{
    top = new Vdut;
    tfp = new VerilatedVcdC;

    Verilated::traceEverOn(true);
    top->trace(tfp, 99);
    tfp->open("cache_top.vcd");

    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();

    top->final();
    tfp->close();

    delete top;
    delete tfp;

    return res;
}