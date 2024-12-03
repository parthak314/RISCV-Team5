#include "gtest/gtest.h"
#include "Vdata_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

class data_topTest : public ::testing::Test {
public:
    Vdata_top* dut;

protected:
    virtual void SetUp() override {
        dut = new Vdata_top;

        Verilated::traceEverOn(true);
        auto tfp = new VerilatedVcdC;
        dut->trace(tfp, 99);
        tfp->open("waveform.vcd");

        dut->rst = 1;
        dut->clk = 0;
        dut->instr = 0;
        dut->result = 0;
        dut->zero = 0;
        dut->negative = 0;
        evaluate();
        clockTick();
        dut->rst = 0;
        evaluate();
    }

    virtual void TearDown() override {
        delete dut;
    }

    void evaluate() {
        dut->eval();
    }

    void clockTick() {
        dut->clk = 1;
        evaluate();
        dut->clk = 0;
        evaluate();
    }
};

TEST_F(data_topTest, ResetTest) {
    dut->rst = 1;
    clockTick();
    dut->rst = 0;

    EXPECT_EQ(dut->PCSrc, 0);
    EXPECT_EQ(dut->ResultSrc, 0);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->ALUControl, 0);
    EXPECT_EQ(dut->ALUSrc, 0);
    EXPECT_EQ(dut->rd1, 0);
    EXPECT_EQ(dut->rd2, 0);
    EXPECT_EQ(dut->ImmExt, 0);
}

TEST_F(data_topTest, InstructionDecoding) {
    dut->instr = 0x001000B3;  // add x1, x0, x1
    evaluate();

    EXPECT_EQ(dut->ALUSrc, 0);
    EXPECT_EQ(dut->MemWrite, 0);
}

TEST_F(data_topTest, ImmediateExtension) {
    dut->instr = 0x00500113;  // addi x1, x0, 5
    evaluate();

    EXPECT_EQ(dut->ImmExt, 0x5);
}

TEST_F(data_topTest, ALUOperations) {
    dut->instr = 0x004000B3; // add x1, x0, x1 (x1 = 0 + 0)
    dut->result = 0;
    evaluate();
    clockTick();

    dut->instr = 0x40410133; // sub x2, x2, x1 (x2 = 0 - 0)
    dut->result = 0;
    evaluate();
    clockTick();

    dut->instr = 0x0011A193; // xori x3, x3, 1 (x3 = x3 ^ 1)
    dut->result = 1;
    evaluate();
    clockTick();

    dut->instr = 0x0021A213; // ori x4, x4, 2 (x4 = x4 | 2)
    dut->result = 2;
    evaluate();
    clockTick();

    dut->instr = 0x0031A393; // andi x5, x5, 3 (x5 = x5 & 3)
    dut->result = 3;
    evaluate();
    clockTick();

    EXPECT_EQ(dut->rd1, 3);
}

TEST_F(data_topTest, MemoryAccessOperations) {
    dut->instr = 0x00002003; // lb x4, 0(x0) (load byte from memory at x0+0 into x4)
    dut->result = 0xFF; // Assume memory[0] = 0xFF
    evaluate();
    clockTick();

    dut->instr = 0x00412023; // sb x4, 4(x2) (store byte x4 at memory[x2+4])
    dut->MemWrite = 1;
    evaluate();
    clockTick();

    EXPECT_EQ(dut->rd1, 0xFF);
    EXPECT_EQ(dut->MemWrite, 1);
}

TEST_F(data_topTest, BranchInstructions) {
    dut->instr = 0x00018663; // beq x3, x0, offset=12 (branch if x3 == x0)
    dut->zero = 1; // Assume x3 == x0
    evaluate();
    EXPECT_EQ(dut->PCSrc, 1);

    dut->instr = 0x0011C063; // bne x3, x1, offset=16 (branch if x3 != x1)
    dut->zero = 0; // Assume x3 != x1
    evaluate();
    EXPECT_EQ(dut->PCSrc, 1);
}

TEST_F(data_topTest, ImmediateInstructions) {
    dut->instr = 0x000000B7; // lui x1, 0x1 (load upper immediate into x1)
    dut->result = 0x1000;
    evaluate();
    clockTick();

    dut->instr = 0x00100197; // auipc x3, 0x1 (x3 = PC + 0x1000)
    dut->result = 0x1000; 
    evaluate();
    clockTick();

    EXPECT_EQ(dut->rd1, 0x1000);
}

TEST_F(data_topTest, ShiftOperations) {
    dut->instr = 0x001081B3; // sll x3, x1, x2 (x3 = x1 << x2)
    dut->result = 0;
    evaluate();
    clockTick();

    dut->instr = 0x0010A1B3; // srl x3, x1, x2 (x3 = x1 >> x2)
    dut->result = 0;
    evaluate();
    clockTick();

    dut->instr = 0x4010A1B3; // sra x3, x1, x2 (x3 = x1 >>> x2)
    dut->result = 0;
    evaluate();
    clockTick();

    EXPECT_EQ(dut->rd1, 0);
}

TEST_F(data_topTest, ComprehensiveControlUnitVerification) {
    dut->instr = 0x00400093; // addi x1, x0, 4
    dut->result = 4;
    evaluate();
    clockTick();

    EXPECT_EQ(dut->ALUControl, 0x0); // ALU should perform addition
    EXPECT_EQ(dut->ALUSrc, 1);       // Immediate value should be selected

    dut->instr = 0x00018663; // beq x3, x0, offset=12
    dut->zero = 1;
    evaluate();

    EXPECT_EQ(dut->PCSrc, 1);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
