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



// test ADD with RA and RB
TEST_F(TestDut, testALU)
{
    verifyALU(0, 0b000, 62, 97, 62+97); // ADD
    verifyALU(0, 0b001, 45, 87, 45-87); // SUB
    verifyALU(0, 0b010, 0b1111'0000, 0b1010'1010, 0b1010'0000); // AND
    verifyALU(0, 0b011, 0b1111'0000, 0b1010'1010, 0b1111'1010); // OR
    verifyALU(0, 0b100, 0b1111'0000, 0b1010'1010, 0b0101'1010); // XOR

    top->ImmExtE = 0b1101'0100; // decimal 212

    verifyALU(1, 0b000, 69, 0, 69+212); // ADD IMM
    verifyALU(1, 0b001, 69, 0, 69-212); // SUB IMM
    verifyALU(1, 0b010, 0b1111'0000, 0, 0b1101'0000); // AND IMM
    verifyALU(1, 0b011, 0b1111'0000, 0, 0b1111'0100); // OR IMM
    verifyALU(1, 0b100, 0b1111'0000, 0, 0b0010'0100); // XOR IMM
}


int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}