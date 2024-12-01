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

    // Check default output values after reset
    EXPECT_EQ(dut->PCsrc, 0);
    EXPECT_EQ(dut->ResultSrc, 0);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->ALUcontrol, 0);
    EXPECT_EQ(dut->ALUSrc, 0);
    EXPECT_EQ(dut->rd1, 0);
    EXPECT_EQ(dut->rd2, 0);
    EXPECT_EQ(dut->ImmExt, 0);
}

TEST_F(data_topTest, InstructionDecoding) {
    // Set an instruction and check control signals
    dut->instr = 0b00000000000100000000000110110011;  // Example R-type instruction
    evaluate();

    EXPECT_EQ(dut->ALUSrc, 0);
    EXPECT_EQ(dut->MemWrite, 0);
}

TEST_F(data_topTest, ImmediateExtension) {
    // Test immediate value extension for I-type instruction
    dut->instr = 0b00000000010100000000000110010011;  
    evaluate();

    EXPECT_EQ(dut->ImmExt, 0x5);  // Immediate should match lower 12 bits
}

TEST_F(data_topTest, RegisterFileOperations) {
    // Write to register 5
    dut->instr = 0b00000000010100101000001010010011;  // Example instruction: rs1=10, rd=5
    dut->result = 0xA5A5A5A5;
    evaluate();
    clockTick();
    dut->instr = 0b00000000010100000000000110000011;  // Read from register 5
    evaluate();

    EXPECT_EQ(dut->rd1, 0xA5A5A5A5); 
}

TEST_F(data_topTest, ALUControlAndPCSrc) {
    // Test control logic for branches
    dut->instr = 0b00000000000100000000000111000111;
    dut->zero = 1;
    evaluate();
    EXPECT_EQ(dut->PCsrc, 1);  // PCsrc should be asserted for branch
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
