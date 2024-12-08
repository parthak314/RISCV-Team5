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

// TEST 1: Cache Read Hit (Single with word addressing)
TEST_F(TwoWayCacheTest, CacheReadHit_Single_Word) {
    // Preload the cache with valid data at address 0x0004
    dut->addr = 0x0004;  
    dut->wd = 0xFACEFACE;  
    dut->we = 1;           
    dut->addr_mode = 0;    
    tick();                

    // Read from the same address
    dut->addr = 0x0004;    
    dut->we = 0;           
    dut->addr_mode = 0;    
    tick();

    // Check data read matches preloaded data
    EXPECT_EQ(dut->rd, 0xFACEFACE) << "Cache read hit failed to retrieve correct data";

    // Check no write-back to sram occurred
    EXPECT_FALSE(dut->we_to_ram) << "Write to RAM should not occur on a cache hit";
}

// TEST 2: Cache Read Hit (Single with byte addressing)
TEST_F(TwoWayCacheTest, CacheReadHit_Single_Byte) {
    dut->addr = 0x0004;      
    dut->wd = 0x000000FF;    
    dut->we = 1;           
    dut->addr_mode = 1;     
    tick();                   

    dut->addr = 0x0004;       
    dut->we = 0;              
    dut->addr_mode = 1;     
    tick();                   

    EXPECT_EQ(dut->rd, 0x000000FF) << "Cache read hit failed to retrieve correct byte data";
    EXPECT_FALSE(dut->we_to_ram) << "Write to RAM should not occur on a cache hit";
}

// TEST 3: Cache Read Miss (Single with word addressing)
TEST_F(TwoWayCacheTest, CacheReadMiss_SingleWord) {
    dut->addr = 0x0008;         
    dut->we = 0;                
    dut->addr_mode = 0;         
    dut->rd_from_ram = 0xDEADBEEF; 
    tick(); 

    EXPECT_EQ(dut->rd, 0xDEADBEEF) << "Cache read miss failed to fetch data from memory";

    EXPECT_FALSE(dut->we_to_ram) << "Unexpected write-back during read miss";
}

// TEST 4: Cache Read Hit with Multiple Words
TEST_F(TwoWayCacheTest, CacheReadHit_MultipleWords) {
    // Write 4 sequential words to the cache
    for (int i = 0; i < 4; i++) {
        dut->addr = i << 2;         
        dut->wd = 0xA5A5A5A5 + i; 
        dut->we = 1;                
        dut->addr_mode = 0;        
        tick();                    
    }

    // Read back the written words to verify cache hit
    for (int i = 0; i < 4; i++) {
        dut->addr = i << 2;          
        dut->we = 0;                 
        dut->addr_mode = 0;          
        tick();                      

        EXPECT_EQ(dut->rd, 0xA5A5A5A5 + i) << "Cache read hit failed for address " << i;
        EXPECT_FALSE(dut->we_to_ram) << "Unexpected write-back during cache hit at address " << i;
    }
}

// TEST 5: Cache Read Hit with Multiple Bytes
TEST_F(TwoWayCacheTest, CacheReadHit_MultipleBytes) {
    // Write to Cache
    for (int i = 0; i < 4; i++) {
        dut->addr = i << 4;       
        dut->wd = 0xA5A5A5A5 + i;  
        dut->we = 1;            
        dut->addr_mode = 0;   
        runSimulation();
    }

    // Read from Cache and test
    for (int j = 0; j < 4; j++) {
        dut->addr = j << 4;       
        dut->we = 0;               
        dut->addr_mode = 0;    
        dut->eval();

        EXPECT_EQ(dut->rd, 0xA5A5A5A5 + j) << "Cache read failed at address " << j;

        EXPECT_FALSE(dut->we_to_ram) << "Unexpected write-back on cache hit at address " << j;
        runSimulation();
    }
}

// TEST 6: Cache Write Hit
TEST_F(TwoWayCacheTest, CacheWriteHit) {
    dut->addr = 0x0008;        
    dut->wd = 0xCA7490EF;       
    dut->addr_mode = 0;         
    dut->we = 1;        
    tick();

    EXPECT_FALSE(dut->we_to_ram) << "Unexpected write-back during cache write hit";
}

// TEST 7: Cache Write Miss -- Fails
TEST_F(TwoWayCacheTest, CacheWriteMiss) {
    // Write to address not in cache
    dut->addr = 0x0030;          
    dut->wd = 0xDEADBEEF;        
    dut->addr_mode = 0;       
    dut->we = 1;               
    tick();

    // Verify that the write-back to RAM is triggered due to a write miss
    EXPECT_TRUE(dut->we_to_ram) << "Write-back signal not asserted during write miss";

    // Verify the address and data being written back
    EXPECT_EQ(dut->wd_to_ram, 0xDEADBEEF) << "Incorrect data written back during write miss";
    EXPECT_EQ(dut->w_addr_to_ram, 0x0030) << "Incorrect address written back during write miss";
}

// TEST 8: Cache Eviction
TEST_F(TwoWayCacheTest, CacheEviction) {
    // Fill the same set with more than two blocks to trigger eviction
    dut->addr = 0x00000004; 
    dut->wd = 0xAAAAAAA1;
    dut->we = 1;             
    dut->addr_mode = 0;     
    tick();

    dut->addr = 0x00200004;  
    dut->wd = 0xBBBBBBB2;    
    dut->we = 1;            
    dut->addr_mode = 0;      
    tick();

    // trigger eviction
    dut->addr = 0x00400004;  
    dut->rd_from_ram = 0x12345678;  
    dut->we = 0;           
    dut->addr_mode = 0;      
    tick();

    // Verify eviction behavior
    EXPECT_TRUE(dut->we_to_ram) << "Eviction did not trigger write-back to RAM";
    EXPECT_EQ(dut->w_addr_to_ram, 0x00000004) << "Incorrect address written back during eviction"; // Evicts the least recently used block
    EXPECT_EQ(dut->wd_to_ram, 0xAAAAAAA1) << "Incorrect data written back during eviction";

    // Verify the new data is loaded
    EXPECT_EQ(dut->rd, 0x12345678) << "Data read from memory after eviction failed";
}

// TEST 9: Complete Cache Behaviour
TEST_F(TwoWayCacheTest, EndToEndCacheBehavior) {
    // Write multiple values to cache
    dut->addr = 0x0004;       
    dut->wd = 0x11111111;        
    dut->we = 1;                 
    dut->addr_mode = 0;          
    tick();
    dut->addr = 0x0014;          
    dut->wd = 0x22222222;        
    dut->we = 1;                
    dut->addr_mode = 0;          
    tick();

    // Read back values
    dut->addr = 0x0004;        
    dut->we = 0;                
    tick();
    EXPECT_EQ(dut->rd, 0x11111111) << "Read from cache failed for way 0";
    dut->addr = 0x0014;          
    dut->we = 0;   
    tick();
    EXPECT_EQ(dut->rd, 0x22222222) << "Read from cache failed for way 1";

    // Trigger eviction
    dut->addr = 0x0024;           
    dut->rd_from_ram = 0x33333333; 
    dut->we = 0;            
    tick();

    // Verify eviction behavior
    EXPECT_TRUE(dut->we_to_ram) << "Eviction did not trigger write-back";
    EXPECT_EQ(dut->w_addr_to_ram, 0x0004) << "Incorrect address written back during eviction";
    EXPECT_EQ(dut->wd_to_ram, 0x11111111) << "Incorrect data written back during eviction";

    // Verify the new data is loaded into the cache
    EXPECT_EQ(dut->rd, 0x33333333) << "Data read from memory after eviction failed";
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
