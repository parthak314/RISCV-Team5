// TEST HISTORY
// TEST #  |              Desc.             |  Outcome  |   Last tested   |   Commit #
//   1        Cache read hit (single/word)     Failed      19:30 8/12/24    fixed latency issue (bc84b8aa2999d5cb99191b277d57ad88f071a9c1)
//   2        Cache read hit (single/byte)     Failed
//   3        Cache read hit (multiple)        Passed
//   4        Cache Read Miss                  Passed
//   5        Cache Write Hit                  Passed
//   6        Cache Write Miss                 Failed
//   7        Cache Eviction                   Failed
//   8        Cache Eviction 2                 Failed
//   9        Complete Cache Test              Failed


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
};

// TEST 1: Cache Read Hit (Single with word addressing)
TEST_F(TwoWayCacheTest, CacheReadHit_Single_Word) {
    dut->addr = 0x0004;
    dut->addr_mode = 0; 
    dut->we = 0;        
    tick();

    EXPECT_EQ(dut->rd, 0xFACEFACE) << "Cache read hit failed to retrieve correct data";
    EXPECT_FALSE(dut->we_to_ram) << "Write to RAM should not occur on a cache hit";
}

// TEST 2: Cache Read Hit (Single with byte addressing)
TEST_F(TwoWayCacheTest, CacheReadHit_Single_Byte) {
    dut->addr = 0x0004;
    dut->addr_mode = 1; 
    dut->we = 0;        
    tick();

    EXPECT_EQ(dut->rd, 0xFACEFACE) << "Cache read hit failed to retrieve correct data";
    EXPECT_FALSE(dut->we_to_ram) << "Write to RAM should not occur on a cache hit";
}

// TEST 3: Cache Read Hit (Multiple)
TEST_F(TwoWayCacheTest, CacheReadHit_Multiple) {
    for (int i = 0; i < 4; i++) {
        dut->addr = i << 2;            
        dut->wd = 0xA5A5A5A5 + i;      
        dut->we = 1;                  
        dut->addr_mode = 0;            
        tick();                       
    }

    for (int j = 0; j < 4; j++) {
        dut->addr = j << 2;            
        dut->we = 0;                   
        dut->addr_mode = 0;            
        tick();                        
        
        EXPECT_EQ(dut->rd, 0xA5A5A5A5 + j) << "Cache read failed at address " << j;
        
        EXPECT_FALSE(dut->we_to_ram) << "Unexpected write-back on cache hit at address " << j;
    }
}

// TEST 4: Cache Read Miss
TEST_F(TwoWayCacheTest, CacheReadMiss) {
    dut->addr = 0x0020;       
    dut->addr_mode = 0;      
    dut->we = 0;            
    dut->rd_from_ram = 0x12345678;
    tick();

    EXPECT_EQ(dut->rd, 0x12345678) << "Cache read miss failed to fetch data from RAM";
}

// TEST 5: Cache Write Hit
TEST_F(TwoWayCacheTest, CacheWriteHit) {
    dut->addr = 0x0008;  
    dut->wd = 0xCA7490EF; 
    dut->addr_mode = 0;
    dut->we = 1;     
    tick();

    EXPECT_FALSE(dut->we_to_ram) << "Write to RAM should not occur on a write hit";
}

// TEST 6: Cache Write Miss
TEST_F(TwoWayCacheTest, CacheWriteMiss) {
    dut->addr = 0x0030;    
    dut->wd = 0xDEADBEEF;  
    dut->addr_mode = 0;   
    dut->we = 1;           
    tick();

    EXPECT_TRUE(dut->we_to_ram) << "Write to RAM should occur on a write miss";
}

// TEST 7: Cache Eviction
TEST_F(TwoWayCacheTest, CacheEviction) {
    dut->addr = 0x0004;   
    dut->wd = 0xAAAAAAA;  
    dut->we = 1;         
    tick();

    dut->addr = 0x0014;   
    dut->wd = 0xBBBBBBB;
    dut->we = 1;         
    tick();

    dut->addr = 0x0024;   
    dut->wd = 0xCCCCCCC;  
    dut->we = 1;          
    tick();

    EXPECT_TRUE(dut->we_to_ram) << "Eviction write-back not triggered";
    EXPECT_EQ(dut->w_addr_to_ram, 0x0004) << "Evicted address incorrect";
    EXPECT_EQ(dut->wd_to_ram, 0xAAAAAAA) << "Evicted data incorrect";
}

// TEST 8: Cache Eviction 2
TEST_F(TwoWayCacheTest, CacheEviction2) {
    for (int i = 0; i < 4; i++) {
        dut->addr = i << 2;     
        dut->wd = 0xA5A5A5A5 + i; 
        dut->we = 1;             
        tick();
    }

    dut->addr = 0x20;        
    dut->we = 0;             
    dut->rd_from_ram = 0xDEADBEEF; 
    tick();                  

    EXPECT_TRUE(dut->we_to_ram) << "Write-back signal not asserted during eviction";
    EXPECT_EQ(dut->wd_to_ram, 0xA5A5A5A5) << "Evicted data incorrect";
    EXPECT_EQ(dut->w_addr_to_ram, 0) << "Evicted address incorrect";
}

// TEST 9: Complete cache test
TEST_F(TwoWayCacheTest, EndToEndCacheBehavior) {
    // Write to cache (1)
    dut->addr = 0x0004;    
    dut->wd = 0x11111111;  
    dut->we = 1;            
    dut->addr_mode = 0;    
    tick();

    // Another write to cache (2)
    dut->addr = 0x0024;  
    dut->wd = 0x22222222;
    dut->we = 1;
    tick();

    // Cache read (1)
    dut->addr = 0x0004;
    dut->we = 0;        
    tick();
    EXPECT_EQ(dut->rd, 0x11111111) << "Read from cache (way 0) failed";

    // Cache Read (2)
    dut->addr = 0x0024;
    dut->we = 0;           
    tick();
    EXPECT_EQ(dut->rd, 0x22222222) << "Read from cache (way 1) failed";

    // Read miss
    dut->addr = 0x0044;         
    dut->rd_from_ram = 0x33333333; 
    dut->we = 0;                
    tick();

    // Verify - cache eviction and write back to sram
    EXPECT_TRUE(dut->we_to_ram) << "Eviction should trigger write-back to RAM";
    EXPECT_EQ(dut->w_addr_to_ram, 0x0004) << "Incorrect address written back to RAM on eviction";
    EXPECT_EQ(dut->wd_to_ram, 0x11111111) << "Incorrect data written back to RAM on eviction";

    // Verify - data fetched from sram and written to cache
    EXPECT_EQ(dut->rd, 0x33333333) << "Data read from cache after miss is incorrect";

    // Read Miss
    dut->addr = 0x0064;     // Another new address in the same set
    dut->wd = 0x44444444;   // Write data
    dut->we = 1;            // Write operation
    tick();

    // Verify - cache eviction of lru block
    EXPECT_TRUE(dut->we_to_ram) << "Eviction should trigger write-back to RAM";
    EXPECT_EQ(dut->w_addr_to_ram, 0x0024) << "Incorrect address written back to RAM on eviction";
    EXPECT_EQ(dut->wd_to_ram, 0x22222222) << "Incorrect data written back to RAM on eviction";

    // data fetched from sram and written to cache
    dut->we = 0;
    dut->addr = 0x0064;
    tick();
    EXPECT_EQ(dut->rd, 0x44444444) << "Data written to cache is incorrect";

    // Verify LRU update
    dut->addr = 0x0044;
    tick();
    EXPECT_EQ(dut->rd, 0x33333333) << "LRU update failed for recently accessed block";
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
