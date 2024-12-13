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
        top->reset = 0;
        top->stall = 0;
        top->PCSrc = 0;
        top->PCTarget = 5;  // random value that will be obviously wrong if PCSrc is not working
    }
    void runReset()
    {
        top->reset = 1;
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

// test that the fetch module selects PCTarget correctly
TEST_F(TestDut, TargetTest)
{
    std::vector<int32_t> TARGET_SEQ = {5,3,6,1,7,20,13,4};
    size_t length = TARGET_SEQ.size();
    runReset();
    top->PCSrc = 1;
    top->PCTarget = NUM_BYTES * TARGET_SEQ[0];
    runSimulation();
    for (int i = 1; i < length; i ++) {
        top->PCTarget = NUM_BYTES * TARGET_SEQ[i];
        runSimulation();
        EXPECT_EQ(top->InstrD, GROUND_TRUTH[TARGET_SEQ[i - 1]]); // delay of 1 cycle because of pipeline register
    }
}

// test that the fetch module stalls correctly
TEST_F(TestDut, StallTest) {
    int first_instr_i = 6;
    int second_instr_i = 3;
    runReset();
    top->PCSrc = 1;
    top->PCTarget = first_instr_i * NUM_BYTES;
    runSimulation();

    // get first instr and set target for second
    top->PCTarget = second_instr_i * NUM_BYTES;
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[first_instr_i]);

    // expect PCF to repeat itself
    top->stall = 1;
    runSimulation();
    EXPECT_EQ(top->InstrD, GROUND_TRUTH[first_instr_i]);

    // return back to original PCSrcE (aka from ResultW)
    top->stall = 0;
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