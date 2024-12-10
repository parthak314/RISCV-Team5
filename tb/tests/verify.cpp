#include <cstdlib>
#include <utility>

#include "cpu_testbench.h"

#define CYCLES 10000

TEST_F(CpuTestbench, TestAddiBne)
{
    setupTest("1_addi_bne");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 254);
}

TEST_F(CpuTestbench, TestLiAdd)
{
    setupTest("2_li_add");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 1000);
}

TEST_F(CpuTestbench, TestLbuSb)
{
    setupTest("3_lbu_sb");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 300);
}

TEST_F(CpuTestbench, TestJalRet)
{
    setupTest("4_jal_ret");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 53);
}

TEST_F(CpuTestbench, TestPdf)
{
    setupTest("5_pdf");
    setData("reference/gaussian.mem");
    initSimulation();
    runSimulation(CYCLES * 100);
    EXPECT_EQ(top_->a0, 15363);
}

TEST_F(CpuTestbench, Testshift)
{
    setupTest("6_shift");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 0x3C000000);
}

TEST_F(CpuTestbench, Testlogic)
{
    setupTest("7_logic");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 31);
}

TEST_F(CpuTestbench, TestLoad)
{
    setupTest("8_load");
    initSimulation();
    runSimulation(CYCLES);
    EXPECT_EQ(top_->a0, 4294892583);
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}
