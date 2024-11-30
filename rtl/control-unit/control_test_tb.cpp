#include "gtest/gtest.h"
#include "Vcontrol.h"  // Include the correct Verilated header for the module
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <memory>

class controlTest : public ::testing::Test
{
public:

protected:
    Vcontrol* dut; 

    virtual void SetUp() override {
        dut = new Vcontrol;
    }

    virtual void TearDown() override {
        delete dut;
    }

    void evaluate() {
        dut->eval(); 
    }
};


TEST_F(controlTest, ) {
    // inputs
    evaluate();
    EXPECT_EQ(); // expected outputs 
}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}
