#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

TEST_F(CpuTestbench, Test1)
{
    setupTest("test1");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 350);
}

TEST_F(CpuTestbench, Test2)
{
    setupTest("test2");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 219);
}

TEST_F(CpuTestbench, Test3)
{
    setupTest("test3");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1000);
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}