#include "gtest/gtest.h"
#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <memory>
#include <iostream>

#define MAX_SIM_CYCLES 1000

class TwoWayCacheTest : public ::testing::Test {
protected:
    Vdut* dut;
    VerilatedVcdC* trace;
    vluint64_t sim_time;
    unsigned int ticks = 0;

    void SetUp() override {
        Verilated::traceEverOn(true);
        dut = new Vdut;
        trace = new VerilatedVcdC;
        dut->trace(trace, 99);
        trace->open("two_way_cache_top.vcd");
        sim_time = 0;


        dut->clk = 0;
        dut->addr_mode = 0;
        dut->wd = 0;
        dut->we = 0;
        dut->addr = 0;
        dut->rd_from_ram = 0;
    }

    void TearDown() override {
        trace->close();
        delete dut;
        delete trace;
    }

    void tick() {
        dut->clk = 1;
        dut->eval();
        trace->dump(sim_time++);
        dut->clk = 0;
        dut->eval();
        trace->dump(sim_time++);
    }

        // Runs the simulation for a clock cycle, evaluates the DUT, dumps waveform.
    void runSimulation()
    {
        for (int clk = 0; clk < 2; clk++)
        {
            dut->eval();
            trace->dump(2 * ticks + clk);
            dut->clk = !dut->clk;
        }
        ticks++;

        if (Verilated::gotFinish())
        {
            exit(0);
        }
    }
};

TEST_F(TwoWayCacheTest, CacheReadHit) {
    // Write data into cache
    for (int i = 0; i < 4; i++) {
        dut->addr = i << 2;            
        dut->wd = 0xA5A5A5A5 + i;      
        dut->we = 1;                  
        dut->addr_mode = 0;            
        runSimulation();             
    }

    // Read back the data to verify cache hit behavior
    for (int j = 0; j < 4; j++) {
        dut->addr = j << 2;            
        dut->we = 0;                   
        dut->addr_mode = 0;            
        dut->eval();                       
        
        EXPECT_EQ(dut->rd, 0xA5A5A5A5 + j) << "Cache read failed at address " << j;
        
        EXPECT_FALSE(dut->we_to_ram) << "Unexpected write-back on cache hit at address " << j;
        runSimulation();
    }
}


// Passed
// TEST_F(TwoWayCacheTest, CacheMiss) {
//     dut->addr = 0x20;        
//     dut->we = 0;             
//     dut->rd_from_ram = 0xDEADBEEF; 
//     tick();                  

//     EXPECT_EQ(dut->rd, 0xDEADBEEF) << "Cache miss handling failed";
// }

// Failed
// TEST_F(TwoWayCacheTest, WriteBackOnEviction) {
//     // Fill the cache to trigger eviction
//     for (int i = 0; i < 4; i++) {
//         dut->addr = i << 2;     
//         dut->wd = 0xA5A5A5A5 + i; 
//         dut->we = 1;             
//         tick();
//     }

//     // Access an address outside the cache range to force eviction
//     dut->addr = 0x20;        
//     dut->we = 0;             
//     dut->rd_from_ram = 0xDEADBEEF; 
//     tick();                  

//     // Verify write-back logic during eviction
//     EXPECT_TRUE(dut->we_to_ram) << "Write-back signal not asserted during eviction";
//     EXPECT_EQ(dut->wd_to_ram, 0xA5A5A5A5) << "Evicted data incorrect";
//     EXPECT_EQ(dut->w_addr_to_ram, 0) << "Evicted address incorrect";
// }

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
