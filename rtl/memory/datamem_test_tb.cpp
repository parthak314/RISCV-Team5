#include "gtest/gtest.h"
#include "Vram2port.h"  // Include the correct Verilated header for the module
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <memory>

class data_memoryTest : public ::testing::Test
{
public:

protected:
    Vram2port* dut; 

    virtual void SetUp() override {
        dut = new Vram2port;
    }

    virtual void TearDown() override {
        delete dut;
    }
    
    void clockTick() {
        dut->clk = 1;
        evaluate();
        dut->clk = 0;
        evaluate();
    }

    void evaluate() {
        dut->eval(); 
    }
};

 TEST_F(data_memoryTest, WriteEnableIsZeroAndResultSrcIsZero) {
    dut->ResultSrc = 0;   
    dut->A = 0x00000020;
    dut->WE = 0;
    dut->modeBU = 1;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x000000020); 
} 

TEST_F(data_memoryTest, WriteEnableIsOneAndResultSrcIsOne) {
    dut->ResultSrc = 1;   
    dut->A = 0x000000;
    dut->WE = 1;
    dut->WD = 0x0002;
    dut->modeBU = 1;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x0002); 
}

TEST_F(data_memoryTest, WriteEnableIsOneAndResultSrcIsOneAndModeBUIsFour) {
    dut->ResultSrc = 1;   
    dut->A = 0x000040;
    dut->WE = 1;
    dut->WD = 0x0004;
    dut->modeBU = 4;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x0004); 
}

TEST_F(data_memoryTest, WriteEnableIsOneAndResultSrcIsOneAndModeBUIsThree) {
    dut->ResultSrc = 1;   
    dut->A = 0x000050;
    dut->WE = 1;
    dut->WD = 0x00FF;
    dut->modeBU = 3;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0xFFFFFFFF); 
}

TEST_F(data_memoryTest, WriteEnableIsOneAndResultSrcIsOneAndModeBUIsFive) {
    dut->ResultSrc = 1;   
    dut->A = 0x000000;
    dut->WE = 1;
    dut->WD = 0x0004;
    dut->modeBU = 5;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x0004); 
}

TEST_F(data_memoryTest, ReadFromUninitializedMemory) {
    dut->ResultSrc = 1;  // Load mode
    dut->A = 0x00000010; // Address to read
    dut->WE = 0;         // Write Enable off
    dut->modeBU = 1;     // Mode irrelevant for read
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x0); // Expect default value for uninitialized memory
}

TEST_F(data_memoryTest, WriteAndReadBackWord) {
    // Write operation
    dut->ResultSrc = 0;  // Write operation
    dut->A = 0x00000010; // Target address
    dut->WD = 0xDEADBEEF; // Data to write
    dut->WE = 1;         // Write Enable on
    dut->modeBU = 1;     // Write word mode
    evaluate();
    clockTick();
    evaluate();

    // Read back operation
    dut->ResultSrc = 1;  // Read operation
    dut->WE = 0;         // Write Enable off
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0xDEADBEEF); // Ensure data matches
}

TEST_F(data_memoryTest, WriteAndReadBackHalfWord) {
    // Write half-word
    dut->ResultSrc = 0;
    dut->A = 0x00000020;
    dut->WD = 0x1234;
    dut->WE = 1;
    dut->modeBU = 2; // Half-word mode
    evaluate();
    clockTick();
    evaluate();

    // Read back half-word
    dut->ResultSrc = 1;
    dut->WE = 0;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x00001234);
}

TEST_F(data_memoryTest, WriteAndReadBackByte) {
    // Write byte
    dut->ResultSrc = 0;
    dut->A = 0x00000030;
    dut->WD = 0xAB;
    dut->WE = 1;
    dut->modeBU = 5; // Byte mode
    evaluate();
    clockTick();
    evaluate();

    // Read back byte
    dut->ResultSrc = 1;
    dut->WE = 0;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x000000AB);
}

TEST_F(data_memoryTest, ReadSignedHalfWord) {
    // Write half-word with signed value
    dut->ResultSrc = 0;
    dut->A = 0x00000040;
    dut->WD = 0xFF80; // Negative value in 16 bits
    dut->WE = 1;
    dut->modeBU = 2; // Half-word mode
    evaluate();
    clockTick();
    evaluate();

    // Read back signed half-word
    dut->ResultSrc = 1;
    dut->WE = 0;
    dut->modeBU = 2; // Signed half-word mode
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0xFFFFFF80); // Sign-extended to 32 bits
}

TEST_F(data_memoryTest, ReadUnsignedHalfWord) {
    // Write half-word with unsigned value
    dut->ResultSrc = 0;
    dut->A = 0x00000050;
    dut->WD = 0x7FFF; // Positive value in 16 bits
    dut->WE = 1;
    dut->modeBU = 2; // Half-word mode
    evaluate();
    clockTick();
    evaluate();

    // Read back unsigned half-word
    dut->ResultSrc = 1;
    dut->WE = 0;
    dut->modeBU = 4; // Unsigned half-word mode
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x00007FFF); // Zero-extended to 32 bits
}

TEST_F(data_memoryTest, OutOfBoundsAccess) {
    // Attempt to read/write out of bounds
    dut->ResultSrc = 1;
    dut->A = 0x1FFFFF; // Address exceeds memory bounds
    dut->WE = 1;
    dut->WD = 0x12345678;
    dut->modeBU = 1; // Word mode
    evaluate();
    clockTick();
    evaluate();
    // Behavior depends on implementation: could be ignored, error, or wrap-around
    // For now, we check that the value is not written
    EXPECT_NE(dut->Result, 0x12345678);
}

TEST_F(data_memoryTest, ZeroWriteEnableHasNoEffect) {
    // Attempt to write with WE=0
    dut->ResultSrc = 0;
    dut->A = 0x00000060;
    dut->WD = 0x1234;
    dut->WE = 0; // Write disabled
    dut->modeBU = 1;
    evaluate();
    clockTick();
    evaluate();

    // Read the memory to ensure it hasn't changed
    dut->ResultSrc = 1;
    dut->WE = 0;
    evaluate();
    clockTick();
    evaluate();
    EXPECT_EQ(dut->Result, 0x0); // Memory should remain unmodified
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}