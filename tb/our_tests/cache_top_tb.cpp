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
        top->en = 1;
        top->cache_miss = 0;
        top->after_miss = 0;
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

// test word writing and eviction
TEST_F(TestDut, WriteWordTest)
{
    // write and fill both ways in set
    top->rd_from_ram = 100;
    top->wd = 20;
    top->we = 1;
    top->addr = 0x0004;
    runSimulation();
    // on miss, we stall, so change none of the inputs
    top->after_miss = 1;
    runSimulation();
    top->after_miss = 0;
    top->addr = 0x0804;
    top->we = 1;
    top->wd = 30;
    runSimulation();
    top->after_miss = 1;
    runSimulation();
    top->after_miss = 0;

    // kick out the word at address 0x0004
    top->addr = 0x1804;
    top->wd = 55;
    top->we = 1;
    runSimulation();
    top->after_miss = 1;
    runSimulation();
    top->after_miss = 0;

    // check that we are correctly reading the kicked out word from RAM
    top->we = 0;
    top->addr = 0x0004;
    top->eval();
    EXPECT_EQ(top->cache_miss, 1); // check that on miss, we are reading from ram
    runSimulation();
    top->after_miss = 1;
    top->eval();
    EXPECT_EQ(top->rd, 100);
    runSimulation();

    // setup to check that dirty bits are updating correctly
    top->after_miss = 0;
    top->wd = 110;
    top->we = 1;
    top->addr = 0x1804;
    runSimulation();
    top->addr = 0x0004;
    top->we = 1;
    top->wd = 111;
    runSimulation();

    // check that 
    top->addr = 0x0804;
    top->rd_from_ram = 550;
    top->eval();
    EXPECT_EQ(top->cache_miss, 1);
    EXPECT_EQ(top->we_to_ram, 1);
    EXPECT_EQ(top->wd_to_ram, 110);
    EXPECT_EQ(top->w_addr_to_ram, 0x1804);

    runSimulation();
    top->after_miss = 1;
    top->eval();
    EXPECT_EQ(top->rd, 550);
    runSimulation();
}

// test en function
TEST_F(TestDut, EnableTest) {
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
    top->en = 0;
    top->eval();
    EXPECT_EQ(top->rd, 0);
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