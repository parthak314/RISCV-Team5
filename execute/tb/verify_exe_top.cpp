#include "gtest/gtest.h"
#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#include <memory>

class TestDut : public ::testing::Test
{
public:
    void SetUp() override
    {
        top = std::make_unique<Vdut>();
        tfp = std::make_unique<VerilatedVcdC>();

        Verilated::traceEverOn(true);
        top->trace(tfp.get(), 99);
        initializeInputs();
    }

    void TearDown() override
    {
        top->final();
        tfp->close();
    }

    void initializeInputs()
    {
        top->clk = 1;
        
    }

    // Runs the simulation for a clock cycle, evaluates the DUT, dumps waveform.
    void runSimulation()
    {
        for (int clk = 0; clk < 2; clk++)
        {
            // printf("evaluate at %d\n", clk);
            top->eval();
            tfp->dump(2 * ticks + clk);
            top->clk = !top->clk;
        }
        ticks++;

        if (Verilated::gotFinish())
        {
            exit(0);
        }
    }

    void verifyALU( uint8_t ALUSrc,
                    uint8_t ALUControl, 
                    uint32_t RD1, 
                    uint32_t RD2,
                    uint32_t expected_result)
    {
    top->ALUSrcE = ALUSrc;
    top->ALUControlE = ALUControl;
    top->RD1E = RD1;
    top->RD2E = RD2;
    runSimulation();
    EXPECT_EQ(top->ALUResultM, expected_result) << "Failed for ALU control: " << std::bitset<3>(ALUControl);
    }

protected:
    unsigned int ticks = 0;
    std::unique_ptr<Vdut> top;
    std::unique_ptr<VerilatedVcdC> tfp;
};

// test all currently implemented ALU functions
TEST_F(TestDut, testALU)
{
    verifyALU(0, 0b0000, 62, 97, 62+97); // ADD
    verifyALU(0, 0b0001, 45, 87, 45-87); // SUB
    verifyALU(0, 0b0010, 0b1111'0000, 0b1010'1010, 0b1010'0000); // AND
    verifyALU(0, 0b0011, 0b1111'0000, 0b1010'1010, 0b1111'1010); // OR
    verifyALU(0, 0b0100, 0b1111'0000, 0b1010'1010, 0b0101'1010); // XOR

    top->ImmExtE = 0b1101'0100; // decimal 212

    verifyALU(1, 0b0000, 69, 0, 69+212); // ADD IMM
    verifyALU(1, 0b0001, 69, 0, 69-212); // SUB IMM
    verifyALU(1, 0b0010, 0b1111'0000, 0, 0b1101'0000); // AND IMM
    verifyALU(1, 0b0011, 0b1111'0000, 0, 0b1111'0100); // OR IMM
    verifyALU(1, 0b0100, 0b1111'0000, 0, 0b0010'0100); // XOR IMM
}

// verify PCSrc flag functions as intended
TEST_F(TestDut, testPCSrc)
{
    // enable PCSrc if: JumpE = 1, OR (BranchE AND ZeroE) 
    top->JumpE = 1;
    top->BranchE = 0b000;
    runSimulation();
    EXPECT_EQ(top->PCSrcE, 1) << "Failed for JumpE test";


    // imitate control unit BNE, where branch = 1, ALUSrc = 0, ALUControl = 0001 (subtraction)
    // and we are branching if not EQ (i.e. if zero flag not true)

    top->JumpE = 0;
    top->BranchE = 0b010;
    top->ALUSrcE = 0;
    top->ALUControlE = 0b0001;
    top->RD1E = 1;


    top->RD2E = 1; // equal, expect no branch
    runSimulation();
    EXPECT_EQ(top->PCSrcE, 0) << "Failed for BNE testcase when equal";

    top->RD2E = 2; // not equal, expect branch
    runSimulation();
    EXPECT_EQ(top->PCSrcE, 1) << "Failed for BNE test when not equal";

}

int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}