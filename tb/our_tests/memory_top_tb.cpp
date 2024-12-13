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
    top->RegWriteM= 0;
    top->ResultsSrcM= 0;
    top->MemWriteM= 0;
    top->MemoryOpM= 0;
    top->ALUResultM= 0;
    top->WriteDataM= 0;
    top->RdM= 0;
    top->PCPlus4M= 0;
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


TEST_F(TestDut, Datamemory_WritebackMux1)
{
    top->MemWriteM = 1;
    top->ALUResultM = 10;
    top->WriteDataM = 5;
    runSimulation();
    top->ALUResultM = 10;
    top->ResultsSrcM = 1;
    runSimulation();
    EXPECT_EQ(top->ResultW, 5);

}

TEST_F(TestDut, ALU_WritebackMux0)
{
    top->ALUResultM = 10;
    top->ResultsSrcM = 0;
    runSimulation();
    EXPECT_EQ(top->ResultW, 10);

}

TEST_F(TestDut, PC_WritebackMux2)
{
    top->PCPlus4M = 10;
    top->ResultsSrcM = 2;
    runSimulation();
    EXPECT_EQ(top->ResultW, 10);

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