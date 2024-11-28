#include "gtest/gtest.h"
#include "Vsignextend.h"  // Include the correct Verilated header for the module
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <memory>

class SignExtensionTest : public ::testing::Test
{
public:

protected:
    Vsignextend* dut; 

    virtual void SetUp() override {
        dut = new Vsignextend;
    }

    virtual void TearDown() override {
        delete dut;
    }

    void evaluate() {
        dut->eval(); 
    }
};


TEST_F(SignExtensionTest, Itype) {
    dut->instr = 0xff600313;
    dut->ImmSrc = 0b000;
    evaluate();
    EXPECT_EQ(dut->ImmOp, 0xFFFFFFF6); 
}

TEST_F(SignExtensionTest, Stype) {
    dut->instr = 0xff600313;   
    dut->ImmSrc = 0b001;
    evaluate();
    EXPECT_EQ(dut->ImmOp, 0xFFFFFFE6); 
}

TEST_F(SignExtensionTest, Btype) {
    dut->instr = 0xff600313;   
    dut->ImmSrc = 0b010;
    evaluate();
    EXPECT_EQ(dut->ImmOp, 0xFFFFF7E6); 
}

TEST_F(SignExtensionTest, Utype) {
    dut->instr = 0xff600313;   
    dut->ImmSrc = 0b011;
    evaluate();
    EXPECT_EQ(dut->ImmOp, 0xFFFFF600); 
}

TEST_F(SignExtensionTest, Jtype) {
    dut->instr = 0xff600313;   
    dut->ImmSrc = 0b100;
    evaluate();
    std::cout << "\n------------------------------------------------\n";
    std::cout << "Running Jtype\n";
    std::cout << "instr: " << dut->instr << " | immSrc: " << dut->ImmSrc << " | immOp: " << dut->ImmOp << " | expected: " << 0xFFF803FB;
    std::cout << "\n------------------------------------------------\n";
    EXPECT_EQ(dut->ImmOp, 0xFFF803FB); 
}

// TEST_F(SignExtensionTest, other) {
//     dut->instr = 0x00000A;   
//     dut->ImmSrc = 1;
//     evaluate();
//     EXPECT_EQ(dut->ImmOp, 0x0000000A); 
// }


int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}
