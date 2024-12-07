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

    top->RegWriteW = 0;
    top->RegWriteM = 0;
    top->WriteRegE = 0;
    top->WriteRegM = 0;
    top->BranchD = 0;
    top->RegWriteE = 0;
    top->Rs1E = 0;
    top->Rs1D = 0;
    top->Rs2E = 0;
    top->Rs2D = 0;
    top->RdM = 0;
    top->RdW = 0;
    }
    void resetinputs()
    {
    top->RegWriteW = 0;
    top->RegWriteM = 0;
    top->WriteRegE = 0;
    top->WriteRegM = 0;
    top->BranchD = 0;
    top->RegWriteE = 0;
    top->Rs1E = 0;
    top->Rs1D = 0;
    top->Rs2E = 0;
    top->Rs2D = 0;
    top->RdM = 0;
    top->RdW = 0;
    }

};

TEST_F(TestDut, TestForwardingAE)
{
    resetinputs();
    top->Rs1E = 5;
    top->RdM = 5;
    top->RegWriteM = 1;
    top->RegWriteW = 0;
    top->eval();
    EXPECT_EQ(top->ForwardAE, 2);

    resetinputs();
    top->Rs1E = 5;
    top->RdM = 5;
    top->RegWriteM = 0;
    top->RegWriteW = 1;
    top->eval();
    EXPECT_EQ(top->ForwardAE, 1);

    resetinputs();
    top->Rs1E = 5;
    top->RdM = 5;
    top->RegWriteM = 0;
    top->RegWriteW = 0;
    top->eval();
    EXPECT_EQ(top->ForwardAE, 0);
}

TEST_F(TestDut, TestForwardingBE)
{
    resetinputs();
    top->Rs2E = 5;
    top->RdM = 5;
    top->RegWriteM = 1;
    top->RegWriteW = 0;
    top->eval();
    EXPECT_EQ(top->ForwardBE, 2);

    resetinputs();
    top->Rs2E = 5;
    top->RdM = 5;
    top->RegWriteM = 0;
    top->RegWriteW = 1;
    top->eval();
    EXPECT_EQ(top->ForwardBE, 1);

    resetinputs();
    top->Rs2E = 5;
    top->RdM = 5;
    top->RegWriteM = 0;
    top->RegWriteW = 0;
    top->eval();
    EXPECT_EQ(top->ForwardBE, 0);

}

TEST_F(TestDut, lwstall)
{
    resetinputs();
    top->Rs1D = 5; 
    top->Rs2E = 5;
    top->ResultSrcE = 1;
    top->eval();
    EXPECT_EQ(top->StallF, 1);

    resetinputs();
    top->Rs2D = 5; 
    top->Rs2E = 5;
    top->ResultSrcE = 1;
    top->eval();
    EXPECT_EQ(top->StallF, 1);

    resetinputs();
    top->Rs1D = 5; 
    top->Rs2E = 4;
    top->ResultSrcE = 1;
    top->eval();
    EXPECT_EQ(top->StallF, 0);

    resetinputs();
    top->Rs1D = 5; 
    top->Rs2E = 5;
    top->ResultSrcE = 0;
    top->eval();
    EXPECT_EQ(top->StallF, 0);
}

TEST_F(TestDut, TestForwardingAD)
{
    resetinputs();
    top->Rs1D = 5;
    top->WriteRegM = 5;
    top->RegWriteM = 1;
    top->eval();
    EXPECT_EQ(top->ForwardAD, 1);

    resetinputs();
    top->Rs1D = 5;
    top->WriteRegM = 4;
    top->RegWriteM = 1;
    top->eval();
    EXPECT_EQ(top->ForwardAD, 0);

}

TEST_F(TestDut, TestForwardingBD)
{
    resetinputs();
    top->Rs2D = 5;
    top->WriteRegM = 5;
    top->RegWriteM = 1;
    top->eval();
    EXPECT_EQ(top->ForwardBD, 1);

    resetinputs();
    top->Rs2D = 5;
    top->WriteRegM = 4;
    top->RegWriteM = 1;
    top->eval();
    EXPECT_EQ(top->ForwardBD, 0);

}


TEST_F(TestDut, Branchstall)
{
    resetinputs();
    top->BranchD = 1;
    top->RegWriteE = 1;
    top->WriteRegE = 5;
    top->Rs1D = 5;
    top->eval();
    EXPECT_EQ(top->StallF, 1);

    resetinputs();
    top->BranchD = 1;
    top->RegWriteE = 1;
    top->WriteRegE = 5;
    top->Rs2D = 5;
    top->eval();
    EXPECT_EQ(top->StallF, 1);

    resetinputs();
    top->BranchD = 1;
    top->ResultSrcM = 1;
    top->WriteRegM = 5;
    top->Rs1D = 5;
    top->eval();
    EXPECT_EQ(top->StallF, 1);

    resetinputs();
    top->BranchD = 1;
    top->ResultSrcM = 1;
    top->WriteRegM = 5;
    top->Rs2D = 5;
    top->eval();
    EXPECT_EQ(top->StallF, 1);

// 

    resetinputs();
    top->BranchD = 1;
    top->RegWriteE = 1;
    top->WriteRegE = 5;
    top->Rs1D = 4;
    top->Rs2D = 3;
    top->eval();
    EXPECT_EQ(top->StallF, 0);

    resetinputs();
    top->BranchD = 1;
    top->ResultSrcM = 1;
    top->WriteRegM = 5;
    top->Rs1D = 4;
    top->eval();
    EXPECT_EQ(top->StallF, 0);

    resetinputs();
    top->BranchD = 1;
    top->ResultSrcM = 1;
    top->WriteRegM = 5;
    top->Rs2D = 4;
    top->eval();
    EXPECT_EQ(top->StallF, 0);
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