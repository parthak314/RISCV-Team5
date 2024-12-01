#include "gtest/gtest.h"
#include "Vcontrol.h"  // Include the correct Verilated header for the module
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <memory>

class ControlTest : public ::testing::Test {
public:
    Vcontrol* dut;

protected:
    void SetUp() override {
        dut = new Vcontrol;
    }

    void TearDown() override {
        delete dut;
    }

    void evaluate() {
        dut->eval();
    }
};

TEST_F(ControlTest, RTypeInstruction) {
    dut->op = 0b0110011;  // R-type
    dut->funct3 = 0b000;
    dut->funct7 = 0;
    evaluate();

    EXPECT_EQ(dut->RegWrite, 1);
    EXPECT_EQ(dut->ALUSrc, 0);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->ResultSrc, 0b00);
    EXPECT_EQ(dut->PCsrc, 0);
    EXPECT_EQ(dut->ALUcontrol, 0b0000);  // Add
}

TEST_F(ControlTest, ITypeAddiInstruction) {
    dut->op = 0b0010011;  // I-type (addi)
    dut->funct3 = 0b000;
    dut->funct7 = 0;  // Not used for addi
    evaluate();

    EXPECT_EQ(dut->RegWrite, 1);
    EXPECT_EQ(dut->ALUSrc, 1);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->ResultSrc, 0b00);
    EXPECT_EQ(dut->PCsrc, 0);
    EXPECT_EQ(dut->ALUcontrol, 0b0000);  // Add immediate
}

TEST_F(ControlTest, ITypeLoadInstruction) {
    dut->op = 0b0000011;  // I-type (load)
    dut->funct3 = 0b010;
    dut->funct7 = 0;  // Not used for load
    evaluate();

    EXPECT_EQ(dut->RegWrite, 1);
    EXPECT_EQ(dut->ALUSrc, 1);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->ResultSrc, 0b01);
    EXPECT_EQ(dut->PCsrc, 0);
    EXPECT_EQ(dut->ALUcontrol, 0b0000);  // Add for address calculation
}

TEST_F(ControlTest, BTypeBranchEqual) {
    dut->op = 0b1100011;  // B-type (branch)
    dut->funct3 = 0b000;  // BEQ
    dut->zero = 1;        // Condition is true
    evaluate();

    EXPECT_EQ(dut->RegWrite, 0);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->PCsrc, 1);  // Branch taken
    EXPECT_EQ(dut->ALUcontrol, 0b001);  // Subtraction
}

TEST_F(ControlTest, JTypeJal) {
    dut->op = 0b1101111;  // J-type (jal)
    evaluate();

    EXPECT_EQ(dut->RegWrite, 1);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->PCsrc, 1);  // Jump
    EXPECT_EQ(dut->ResultSrc, 0b10);  // PC + 4
}

TEST_F(ControlTest, DefaultCase) {
    dut->op = 0b1111111;  // Undefined opcode
    evaluate();

    EXPECT_EQ(dut->RegWrite, 0);
    EXPECT_EQ(dut->MemWrite, 0);
    EXPECT_EQ(dut->ResultSrc, 0b00);
    EXPECT_EQ(dut->PCsrc, 0);
    EXPECT_EQ(dut->ALUcontrol, 0b0000);  // Default
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
