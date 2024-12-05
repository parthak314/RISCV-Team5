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
        top->RegWriteM = 0;
        top->RdM = 0;
        top->PCPlus4M = 0;
        top->ResultSrcM = 0;
        top->ALUResultM = 0;
        top->MemWriteM = 0;
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

TEST_F(TestDut, Testregister)
{
    EXPECT_EQ(top->RegWriteW, 0);
    top->RegWriteM = 1;
    runSimulation();
    EXPECT_EQ(top->RegWriteW, 1);
}


TEST_F(TestDut, TestMuxRegister0)
{
    top->ALUResultM = 5;
    top->WriteDataM = 20;
    top->ResultSrcM = 0;
    runSimulation();    //First simulation is to load the data into the register and let ReadData equal 20
    runSimulation(); // We need this second RunSim to push the Value through
    // runSimulation();
    EXPECT_EQ(top->ResultW, 5);
}

TEST_F(TestDut, TestMuxRegister1)
{
    top->ALUResultM = 5;
    top->WriteDataM = 20;
    top->MemWriteM = 1;
    top->ResultSrcM = 1;
    runSimulation();    //First simulation is to load the data into the register and let ReadData equal 20
    runSimulation(); // We need this second RunSim to push the Value through
    // runSimulation();
    EXPECT_EQ(top->ResultW, 20);
}

TEST_F(TestDut, TestMuxRegister2)
{
    top->ALUResultM = 5;
    top->WriteDataM = 20;
    top->ResultSrcM = 2;
    top->PCPlus4M = 100;
    runSimulation();    //First simulation is to load the data into the register and let ReadData equal 20
    runSimulation(); // We need this second RunSim to push the Value through
    // runSimulation();
    EXPECT_EQ(top->ResultW, 100);
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