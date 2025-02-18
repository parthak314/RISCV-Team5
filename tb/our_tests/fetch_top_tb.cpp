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
        top->PCSrc = 0;
        top->ImmExt = 5; // random value that will be obviously wrong if PCSrc is not working
        top->Result = 7;
    }

    void runReset()
    {
        top->rst = 1;
        runSimulation();
        top->rst = 0;
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
// conditions: clk = 0, rst = 1, PCSrc = 0, ImmExt = 5
TEST_F(TestDut, InitialStateTest)
{
    top->rst = 1;
    top->eval(); // instr mem is async, so should ready to read immediately
    EXPECT_EQ(top->Instr, GROUND_TRUTH[0]);
}

// test that the fetch module iterates through the instruction memory correctly
// conditions: clk = [0 to GROUND_TRUTH.size() - 1], rst = 0, PCSrc = 0, ImmExt = 5
TEST_F(TestDut, IterationTest)
{
    size_t length = GROUND_TRUTH.size();
    runReset();
    for (size_t i = 0; i < length; i++) {
        EXPECT_EQ(top->Instr, GROUND_TRUTH[i]);
        runSimulation();
    }
}

// test that the fetch module branches correctly based on the ImmExt input
// conditions: clk = [0 to BRANCH_SEQ.size() - 1] rst = 0, PCSrc = 1, ImmExt = BRANCH_SEQ[i] * 4
TEST_F(TestDut, BranchTest)
{
    std::vector<int32_t> BRANCH_SEQ = { 1, 3, 4, 2, -2, 5, -1, -3, 2, 1, 4, -5, 3, -4, 1, -2, 4, 1, -5, 3 };
    size_t length = BRANCH_SEQ.size();
    runReset();
    int j = 0;
    top->PCSrc = 1;
    for (int i = 0; i < length; i++) {
        j += BRANCH_SEQ[i];
        top->ImmExt = BRANCH_SEQ[i] * 4; // because we need to branch in bytes of 4
        runSimulation();
        EXPECT_EQ(top->Instr, GROUND_TRUTH[j]);
    }
}

// test that the fetch module correctly jumps to Result with PCSrc = 2
TEST_F(TestDut, JumpTest)
{
    std::vector<int32_t> JUMP_SEQ = {5,3,6,1,7,20,13,4};
    size_t length = JUMP_SEQ.size();
    runReset();
    top->PCSrc = 2;
    for (int i = 0; i < length; i ++) {
        top->Result = 4 * JUMP_SEQ[i];
        runSimulation();
        EXPECT_EQ(top->Instr, GROUND_TRUTH[JUMP_SEQ[i]]);
    }
}

// test that the fetch module correctly stalls with PCSrc = 2
TEST_F(TestDut, StallTest)
{
    runReset();
    size_t length = GROUND_TRUTH.size();
    int j = 0;
    bool increment = true;
    for (size_t i = 0; i < length; i++) {
        EXPECT_EQ(top->Instr, GROUND_TRUTH[j]);
        if (i == 5) {
            top->PCSrc = 3;
            increment = false;
        }
        else if (i == 8) {
            top->PCSrc = 0;
            increment = true;
        }

        if (increment) {
            j += 1;
        }
        runSimulation();
    }
}

// test that the fetch module resets, branches and iterates correctly
// conditions: mix of everything 
TEST_F(TestDut, FullTest)
{
    // verify that reset works
    runReset();
    EXPECT_EQ(top->Instr, GROUND_TRUTH[0]);

    // set immop to branch by 14 instructions, but stall with trigger
    int32_t branch = 14;
    top->PCSrc = 3;
    runSimulation();
    EXPECT_EQ(top->Instr, GROUND_TRUTH[0]);

    // branch forward by 14 instructions
    int i = branch;
    top->PCSrc = 1;
    // top->trigger = 0;
    top->ImmExt = branch * NUM_BYTES;
    runSimulation();
    EXPECT_EQ(top->Instr, GROUND_TRUTH[i]);
    
    // iterate once forward
    top->PCSrc = 0;
    i++;
    runSimulation();
    EXPECT_EQ(top->Instr, GROUND_TRUTH[i]);

    // branch backwards by 3 instructions
    branch = -3;
    top->PCSrc = 1;
    i += branch;
    top->ImmExt = branch * NUM_BYTES;
    runSimulation();
    EXPECT_EQ(top->Instr, GROUND_TRUTH[i]);

    // jump to instruction at position 20
    top->Result = 20;
    top->PCSrc = 2;
    runSimulation();
    EXPECT_EQ(top->Instr, GROUND_TRUTH[5]);

    // verify again that reset works
    runReset();
    EXPECT_EQ(top->Instr, GROUND_TRUTH[0]);
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