#include "gtest/gtest.h"
#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <vector>

Vdut *top;
VerilatedVcdC *tfp;
unsigned int ticks = 0;

class TestDut : public ::testing::Test
{
public:
    void SetUp() override
    {
        initializeInputs();
        runReset();
    }

    void TearDown() override
    {
    }

    void initializeInputs()
    {
        top->clk = 0;
        top->rst = 0;
        top->pipeline_en = 1;
        top->PCSrcE = 0;
        top->ResultW = 5; // random value that will be obviously wrong if PCSrc is not working
        top->PCE = 6;
        top->RdE = 7;
        top->ImmExtE = 8;
    }
    void runReset()
    {
        top->rst = 1;
        runSimulation();
        initializeInputs();
    }


    // Runs the simulation for a clock cycle, evaluates the DUT, dumps waveform.
    void runSimulation(int cycles = 1)
    {
        for (int i = 0; i < cycles; i++)
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
    }
};

std::vector<uint32_t> GROUND_TRUTH = {
        0x010000ef,
        0x020000ef,
        0x050000ef,
        0xffdff06f,
        0x10000593,
        0xfff58593,
        0x10058023,
        0xfe059ce3,
        0x00008067,
        0x000105b7,
        0x00000613,
        0x10000693,
        0x0c800713,
        0x00c587b3,
        0x0007c283,
        0x00d28833,
        0x00084303,
        0x00130313,
        0x00680023,
        0x00160613,
        0xfee312e3,
        0x00008067,
        0x00000593,
        0x0ff00613,
        0x1005c503,
        0x00158593,
        0xfec59ce3,
        0x00008067,
    };

const int NUM_BYTES = 4;

// test that the initial value is correct
TEST_F(TestDut, InitialStateTest)
{
    runReset();
    runSimulation(); // run extra cycle of sim to push instr_mem output to instrD
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[0]);
}

// test that the fetch module iterates through the instruction memory correctly
TEST_F(TestDut, IterationTest)
{
    size_t length = GROUND_TRUTH.size();
    runReset();
    runSimulation();
    for (size_t i = 0; i < length; i++) {
        EXPECT_EQ(top->InstrD, GROUND_TRUTH[i]);
        runSimulation();
    }
}

// // test that the fetch module branches correctly based on the ImmExtE input
TEST_F(TestDut, BranchTest)
{
    std::vector<int32_t> BRANCH_SEQ = { 1, 3, 4, 2, -2, 5, -1, -3, 2, 1, 4, -5, 3, -4, 1, -2, 4, 1, -5, 3 };
    size_t length = BRANCH_SEQ.size();
    runReset();
    top->PCSrcE = 1;
    top->PCE = 0;
    top->ImmExtE = BRANCH_SEQ[0] * 4; // because we need to branch in bytes of 4
    int j = BRANCH_SEQ[0]; // This will only show up 1 cycle later (because of pipeline)
    runSimulation();
    for (int i = 1; i < length; i++) {
        top->PCE += top->ImmExtE; // feed the PC of current InstrD back into PCE to create test loop
        top->ImmExtE = BRANCH_SEQ[i] * 4;
        runSimulation();
        EXPECT_EQ(top->InstrD, GROUND_TRUTH[j]);
        j += BRANCH_SEQ[i];
    }
}

TEST_F(TestDut, ResultTest) {
    runReset();
    top->PCSrcE = 2;
    top->ResultW = 20;
    runSimulation(2);
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[20 / 4]);
}

TEST_F(TestDut, PCRepeatTest) {
    int first_instr_i = 5;
    int second_instr_i = 3;
    runReset();
    top->PCSrcE = 2;
    top->ResultW = first_instr_i * 4;
    runSimulation();

    // set PCF to repeat itself
    top->PCSrcE = 3;
    top->ResultW = second_instr_i * 4;
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[first_instr_i]);

    // expect PCF to repeat itself
    top->PCSrcE = 2;
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[first_instr_i]);

    // return back to original PCSrcE (aka from ResultW)
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[second_instr_i]);
}

// Test that the fetch module en works correctly
TEST_F(TestDut, EnableTest)
{
    int first_instr_i = 3;
    int second_instr_i = 2;
    runReset();
    // send the first and second instr into the pc pipeline
    top->PCSrcE = 1;
    top->ImmExtE = first_instr_i * 4;
    top->PCE = 0;
    runSimulation();
    top->ImmExtE = second_instr_i * 4;
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[first_instr_i]);

    // disable en, ie retain instrD output. If en was high, it should return GROUND_TRUTH[second_instr_i]
    top->pipeline_en = 0;
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[first_instr_i]);

    // set en back to HIGH, continue on to second_instr
    top->pipeline_en = 1;
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[second_instr_i]);
}

int main(int argc, char **argv)
{
    std::ignore = system("rm -f program.hex");
    std::ignore = system("touch program.hex");
    std::ignore = system("cat ./reference/pdf.hex > program.hex");

    top = new Vdut;
    tfp = new VerilatedVcdC;

    Verilated::traceEverOn(true);
    top->trace(tfp, 99);
    tfp->open("fetch.vcd");

    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();

    top->final();
    tfp->close();

    delete top;
    delete tfp;
    std::ignore = system("rm -f program.hex");
    return res;
}