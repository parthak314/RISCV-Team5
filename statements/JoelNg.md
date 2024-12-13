# Joel Ng's Personal Statement
#### CID: 02193809, Github username: energy-in-joles

---

## Summary of contributions (in chronological order):

### Single-Cycle
1. [Created Fetch module and testbenches](#created-fetch-module-and-testbenches)
2. [Integrated single-cycle system and debugged system to pass testbenches](#integrated-single-cycle-system-and-debugged-system-to-pass-testbenches)
3. [Co-wrote the testbench scripts for f1_fsm with Kevin and wrote the testbench script for Vbuddy PDF](#co-wrote-the-testbench-scripts-for-f1_fsm-with-kevin-and-wrote-the-testbench-script-for-vbuddy-pdf)


### Pipelined
1. [Modified Fetch module and testbenches for pipelining](#modified-fetch-module-and-testbenches-for-pipelining)

### Cache (Single-Cycle)
1. [Design and implement two-way write-back cache implementation](#design-and-implement-two-way-write-back-cache-implementation)
2. Assisted in writing testbenches for cache system
3. Completed integration of cache with single-cycle system

### Pipelined + Cache (Final Version)
1. Implemented pipelining stall for cache miss

### Extension: Superscalar Processor
1. Designed out-of-order execution compiler extension with Partha
2. Implemented the script in Python and C++
3. Integrated compiler script with superscalar processor verilog system and debugged

---

## Single-Cycle

### Created Fetch module and testbenches

For the single-cycle part of the project, we worked in our individual branches, where I did most of the writing and testing in the `fetch` branch. Using Clarke's fetch module that he created for the RISC-V reduced processor, I tweaked the module design to fit within the full single-cycle processor. 

To test the functionality of the module, I wrote a comprehensive testbench script `./tb/our_tests/fetch_top_tb.cpp` with _GTEST_ that can be used with the script `./bash/fetch_top_test.sh`. It tests the functionality of the fetch module thoroughly, where I loaded the instructions in `/reference/pdf.hex` into `instr_mem.sv` and compared results against a ground truth array of the `pdf.hex` instructions. My tests covered the following:
1. **InitialStateTest:** Sanity check to test the instruction at the first position matches with the ground truth array
2. **IterationTest:** Check that the fetch module iterates through the entire `pdf.hex` correctly (with the PC+4 functionality, PCSrc = 0).
3. **BranchTest:** Check that the fetch module branches correctly (using PC + Imm functionality, PCSrc = 1). This was done by feeding the module with a vector of Imm positions to jump forward or backwards and to compare the instruction output with the ground truth array.
4. **JumpTest:** Check that the fetch module jumps to the Result value correctly (Using rs1 + imm for JALR, PCSrc = 2). This was done in a similar fashion to branch, comparing the post-jump instruction with the ground truth array.
5. **StallTest:** Check that the fetch module correctly stalls with PCSrc = 3 (This is implemented to stall with trigger).
6. **FullTest:** Finally, a test that mixes all the previous components to ensure they all work in tandem.

![fetch_tb](../images/joel/fetch_tb.png)

As expected, we receive a full score on the testbench.

### Integrated single-cycle system and debugged system to pass testbenches

After everyone had completed their parts, I led the team in integrating their various components together, double checking that their testbenches were accurate and that they were passing all required tests. I then built the `top.sv` for the single-cycle module and began to connect the various top modules together. As I was putting everything together, there were 3 major issues that we failed to address individually:
1. There was some discrepency in the understanding of LUI and JAL implementation (implicit 0 LSB bit in jump and 12 bit shifting in LUI). This led to the wrong data being sent from the decode block.
2. We had not considered the implementation of JALR properly and were lacking the required hardware to perform PC = rs1 + imm. This was resolved with point 3.
3. We had also not considered the implementation of trigger in the system. We required the ability to stall the system with the trigger input, and this was done by converting PCSrc to be 2 bits long. This accommodated additional cases: PCNext = rs1 + imm (PCSrc = 3) for JALR in point 2, and PCNext = PC (PCSrc = 4) for trigger stall.

With the help of Partha, point 1 and 2 were discovered by debugging the system with `GTKWave`, where we scrutinised each instruction waveform in the failed `2_li_add` and `4_jal_ret` tests from the `doit.sh`.

For point 3, we also encountered a bug where as the system stalled and instructions were repeated, instructions that involved register or memory write would continually write during the stall. This was an issue for an incremental instruction like `addi a0, a0, 5` because we would be continually adding 5 to `a0` during the stall. This was resolved by disabling write enables during stall to prevent unncessary overwrite.

After these considerations were made, the single-cycle system successfully passed all cases and the final schematic and implementation can be seen in the main [README.md](../README.md#single-cycle).

### Co-wrote the testbench scripts for f1_fsm with Kevin and wrote the testbench script for Vbuddy PDF

#### f1_fsm

While I was debugging the single-cycle system, Kevin wrote a rough outline of the `./tb/vbuddy_test/f1_fsm_tb.cpp` test. I then integrated the assembly that Partha had written in `./tb/asm/f1_fsm.s`, by building a temporary `program.hex` file with shell commands in the testbench cpp script (same as what was done for `doit.sh`). To show off the trigger implementation, I also connected it to the `vbdflag()` feature on Vbuddy, so that we could see the system stopping and sarting with the press of the rotary switch.

#### pdf

For the pdf implementation, I similarly loaded the `reference/pdf.hex` into a temporary `program.hex` file, along with string input for the appropriate distribution (gaussian, noisy, etc.) to load into a `data.hex` file for the RAM module. 

As it was only meaningful to display the waveform once the program was in its `display` loop, I had to come up with a way to discern when it was time to run `vbdplot()` to plot the waveform. Initially, since we knew the program loops forever, I created a long delay of about 1e6 cycles - long enough such that we know that we will definitely be in the `display loop`. However, this implementation seemed clumsy to me. Since we were plotting `a0` and it was only written to during the `display` loop, I decided to set a flag in the cpp that is triggered when the `a0` output differs from the recorded `a0` value at the start of the program.

```cpp
bool displaying = false;
int original_a0 = top->a0; // record the original a0 value. If it changes, means time to display
int j = 0; // vbudy display cycle counter (only starts incrementing when displaying)
```

This worked very effectively!

Another issue I noticed while I was running the program, was that the gaussian signal seemed to be stretched along the horizontal axis. On closer inspection of the code, I realised that this was due to the fact that within the display loop of the assembly code, the output `a0` is only updated every 3 cycles, as the other 2 clock cycles were used for fetching the next value in RAM and for looping:

```s
bfc00060 <_loop3> (File Offset: 0x1060):
_loop3():
bfc00060:	1005c503          	lbu	a0,256(a1) # a0 only updates here!
bfc00064:	00158593          	addi	a1,a1,1
bfc00068:	fec59ce3          	bne	a1,a2,bfc00060 <_loop3> (File Offset: 0x1060)
```

Hence, it was not useful to be plotting on every cycle, where I decided to instead plot every 3 cycles:

```cpp
if (!is_paused) {
    // we only plot every 3 steps because we only update a0 every 3 steps in the loop
    // BNE and ADDI don't make any direct changes to a0.
    j++;
    displaying = true;
    if (j % 3 == 0) {
    vbdCycle(j);
    vbdPlot(top->a0, 0, 255);
    }
}
```

I also added quality of life features such as:
- Displaying the distribution in the display header (so that we can photograph and identify the distributions)
- A simple interrupt listener to remove the temporary hex files when the program is interrupted (as seen below)

```cpp
void end_program(int signum) {
  std::cout << "\nShutting down..." << std::endl;
  std::ignore = system("rm -f program.hex data.hex");
  exit(signum);
};
```

## Pipelined

### Modified Fetch module and testbenches for pipelining

Much of the design considerations and planning for pipelining was done by Clarke and Kevin. I took charge of the fetch section of the processor again, adding a `fetch_pipeline_regfile.sv` to the fetch module. This register was to separate the instructions at the decode stage (denoted with `_o` suffix below) and the next instruction coming out of the fetch stage (denoted with `_i` suffix below):

```sv
always_ff @ (negedge clk) begin

    if (en & !clear) begin // regular operation
        Instr_o     <= Instr_i;
        PC_o        <= PC_i;
        PCPlus4_o   <= PCPlus4_i;    
    end

    else if (clear) begin // if cleared, set all to 0 (useful for flush and reset)
        Instr_o     <= 0;
        PC_o        <= 0;
        PCPlus4_o   <= 0;
    end

end
```

Note that we are writing to the register on the negative clock edge this time. This is to address timing issues, ensurirng that the pipeline register input is pushed to the next stage before the next positive clock edge.

Further, we also abstracted PCSrc back to being 1 bit, where instead of separating JALR (PCNext = rd1 + imm) and branch functions (PCNext = pc + imm), we decided to instead centralise them with a `PCTarget` wire that is updated outside the fetch module. Further, there is a dedicated `stall` wire, since stalling is now a core feature of our system (as part of the way pipelined systems are designed).

After changing the code, I updated my `./tb/our_tests/fetch_tb.cpp` file to include the new `fetch_pipeline_regfile.sv`, split into the following test:
1. **InitialStateTest:** Sanity check, same as above. However, this time we run an extra cycle to push the first instruction to `Instr_o`.
2. **IterationTest:** Test that the processor iterates through instructions correctly, same as before.
3. **TargetTest:** Test that pc goes to the `PCTarget` correctly on the following cycle.
4. **StallTest:** Test that the fetch module correctly stalls when `stall` is HIGH.

![fetch_tb_pipeline](../images/joel/fetch_tb_pipelined.png)

### Discussion about trigger stall implementation in pipelining

Although I did not play as big of a role in integrating the pipelining system, I discussed with the team how we could implement the trigger stall in the new system, where we finally came to the consenus of routing trigger to the pipeline registers to "freeze" and maintain the states at each stage by preventing anything being written to the registers during a stall. This worked perfectly!

## Cache

I took a major role in the design, creation and testing of the cache module. This discussion pertains specifically to our first iteration of cache (within `cache` branch), where we implemented cache on a single cycle system for simplicity. It was later integrated into the pipelined system in the `complete` branch, that will be discussed later.

Initially, Partha proposed a solution with a single cache controller script that implicity held an array to store the cache data. However, I decided to abstract the physical sram memory block into a separate module so that we could better debug the input and output of both modules.

We finally decided on the following system:
```
├── memory_top.sv
│   ├── ram2port.sv
│   ├── two_way_cache_top.sv
│   │   ├── two_way_cache_controller.sv
│   │   └── sram.sv
```

- `memory_top.sv`: No change to the way it interacts with the other external modules. This allows the cache system to be highly modular, as it makes no impact on the rest of the system.
- `ram2port.sv`: As we were working on the cache implementation, we recognised that we required a dual-port RAM, because a cache miss may require both writing to RAM (because of the write-back system), and reading from RAM (retrieving the missed word).
- `two_way_cache_top.sv`: This module was responsible for handling the input and outputs between RAM and the cache system, as well as input and outputs from memory_top.
- `two_way_cache_controller.sv`: This module houses the majority of logic for the cache system. This will be discussed next.
- `sram.sv`: This module just serves as a memory block (similar to the way the ram module is designed).

### Design and implement two-way write-back cache implementation

In this section, we will mostly be discussing the implementation the cache controller and sram. Since we are designing a two-way cache block to hold 4096 bytes (1k words), we are able to determine the number of sets it will store:
```
Number of bytes in word = 4 (8 bits * 4 in one word)
Hence, number of words = 4096 / 4 = 1024

Number of ways in one set = 2
Hence, number of sets = 1024 / 2 = 512.
```

Since we are storing 512 sets, we know that our number of set bits will be **log2(512) = 9**. We can then determine the number of bits in each word tag:

```
Number of address bits = 32 bits
Number of set bits = 9 bits
Byte offset = 2

Hence, number of bits in each tag = 32 - 9 - 2 = 21.
```

This allows us to calculate the total number of bits in one set (including all the overhead bits):
```
Number of LRU bits = 1 (0 = word0 and 1 = word1)
Number of V bits = 2 (1 for each word)
Number of dirty bits = 2 (1 for each word)
Number of tag bits = 42 (21 for each word)
Number of word bits = 64 (32 for each word)

Hence, total bits in a set = 1 + 2 + 2 + 42 + 64 = 111.

-------

Format for each way:
Way{n} = | V bit | dirty bit | 21-bit tag | 32-bit word |

Set format:
| LRU Bit | Way0 (55 bits) | Way1 (55 bits) |
```

Using this, we are able to create our cache system. The biggest challenge I faced was the complicated sequential logic that was completed in one cycle. When we encounter a cache miss, there is a long sequence of information to update, including reading and writing back to RAM. When poorly handled, updates along the way could lead to circular logic.

To simplify the process, I created a copy of each set variable (v bit, dirty bit, tag, word) within the `always_comb` block that I updated during the cache retrieval process. This way, I could complete all updates without modifying the original set data. After all logic had been updated, I wrote back to the set block with the updated variables.

### Assisted in writing testbenches for cache system

While I was writing the cache system, Partha helped me write a series of tests for the cache, testing that our system correctly read via byte/word addressing, and that the write-back feature and RAM data retrieval process was valid during a cache miss.

This test can be found in `cache branch -> ./tb/our_tests/cache_top_tb_p2.cpp` that can be run with the script found in `cache branch -> ./tb/bash/cache_top_test_p2.sh`.



