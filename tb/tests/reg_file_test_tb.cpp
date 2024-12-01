#include "gtest/gtest.h"
#include "Vreg_file.h"
#include "verilated.h"

class reg_fileTest : public ::testing::Test {
public:
    Vreg_file* dut;  // Device Under Test (DUT)

protected:
    virtual void SetUp() override {
        dut = new Vreg_file;
        dut->reset = 1;
        dut->write_enable = 0;
        dut->clk = 0;
        evaluate();
        clockTick();  // Apply reset for one cycle
        dut->reset = 0;
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

TEST_F(reg_fileTest, ResetTest) {
    dut->reset = 1;
    clockTick();
    dut->reset = 0;
    for (int i = 0; i < 32; i++) {
        dut->read_addr1 = i;
        dut->read_addr2 = i;
        evaluate();
        EXPECT_EQ(dut->read_data1, 0);
        EXPECT_EQ(dut->read_data2, 0);
    }
}

TEST_F(reg_fileTest, WriteAndReadValidRegister) {
    dut->write_addr = 1;
    dut->write_data = 0xA5A5A5A5;
    dut->write_enable = 1;
    clockTick();  // Write occurs on clock edge
    dut->write_enable = 0;

    dut->read_addr1 = 1;  // Read the value
    evaluate();
    EXPECT_EQ(dut->read_data1, 0xA5A5A5A5);
}

TEST_F(reg_fileTest, WriteAndReadAnotherRegister) {
    dut->write_addr = 2;
    dut->write_data = 0xDEADBEEF;
    dut->write_enable = 1;
    clockTick();
    dut->write_enable = 0;

    dut->read_addr2 = 2;  // Read from second port
    evaluate();
    EXPECT_EQ(dut->read_data2, 0xDEADBEEF);
}

TEST_F(reg_fileTest, WriteToRegister0ShouldNotChange) {
    dut->reset = 0;
    dut->write_addr = 0;
    dut->write_data = 0x12345678;
    dut->write_enable = 1;
    clockTick();
    dut->write_enable = 0;  // Deassert write_enable after writing
    dut->read_addr1 = 0;
    evaluate();
    EXPECT_EQ(dut->read_data1, 0);
}

TEST_F(reg_fileTest, ResetAfterWriteOperations) {
    dut->reset = 0;
    dut->write_addr = 1;
    dut->write_data = 0xA5A5A5A5;
    dut->write_enable = 1;
    clockTick();
    dut->write_enable = 0;  // Deassert write_enable after writing
    dut->reset = 1;
    clockTick();
    dut->reset = 0;
    for (int i = 0; i < 32; i++) {
        dut->read_addr1 = i;
        dut->read_addr2 = i;
        evaluate();
        EXPECT_EQ(dut->read_data1, 0);
        EXPECT_EQ(dut->read_data2, 0);
    }
}

TEST_F(reg_fileTest, WriteAndReadMultipleRegisters) {
    // Write to register 1
    dut->write_addr = 1;
    dut->write_data = 0x1;
    dut->write_enable = 1;
    clockTick();

    // Write to register 2
    dut->write_addr = 2;
    dut->write_data = 0x2;
    clockTick();
    dut->write_enable = 0;

    // Read back from both registers
    dut->read_addr1 = 1;
    dut->read_addr2 = 2;
    evaluate();
    EXPECT_EQ(dut->read_data1, 0x1);
    EXPECT_EQ(dut->read_data2, 0x2);
}

TEST_F(reg_fileTest, WriteAndReadFromSameRegister) {
    dut->write_addr = 3;
    dut->write_data = 0xDEADBEEF;
    dut->write_enable = 1;
    clockTick();
    dut->write_enable = 0;

    dut->read_addr1 = 3;
    dut->read_addr2 = 3;
    evaluate();
    EXPECT_EQ(dut->read_data1, 0xDEADBEEF);
    EXPECT_EQ(dut->read_data2, 0xDEADBEEF);
}

TEST_F(reg_fileTest, WriteWithMultipleClocks) {
    dut->write_addr = 4;
    dut->write_data = 0x12345678;
    dut->write_enable = 1;
    clockTick();
    dut->write_enable = 0;

    dut->read_addr1 = 4;
    for (int i = 0; i < 3; i++) {
        evaluate();
        EXPECT_EQ(dut->read_data1, 0x12345678);
        clockTick();
    }
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
