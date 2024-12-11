# Joel Ng's Personal Statement
#### CID: 02193809, Github username: energy-in-joles

---

## Summary of contributions (in chronological order):

### Single-Cycle
1. [Created Fetch module and testbenches](#created-fetch-module-and-testbenches)
2. [Co-wrote the testbench scripts for f1_fsm with Kevin and wrote the testbench script for Vbuddy PDF](#co-wrote-the-testbench-scripts-for-f1_fsm-with-kevin-and-wrote-the-testbench-script-for-vbuddy-pdf)
3. Integrated single-cycle system and debugged system to pass testbenches

### Pipelined
1. Modified Fetch module and testbenches for pipelining

### Cache (Single-Cycle)
1. Design and implement two-way write-back cache implementation
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

For the single-cycle part of the project, we worked in our individual branches, where I did most of the writing and testing in the `fetch` branch. Using Clarke's Fetch module that he created for the RISC-V reduced processor, I tweaked the module design to fit within the full single-cycle processor. 

To test the functionality of the module, I wrote a comprehensive testbench script `./tb/our_test/fetch_tb.cpp` with _GTEST_ that can be used with the script `./bash/fetch_test.sh`. It tests the functionality of the fetch module thoroughly, where I loaded the instructions in `/reference/pdf.hex` into `instr_mem.sv` and compared results against a ground truth array of the `pdf.hex` instructions. My tests covered the following:
1. Sanity check to test the instruction at the first position matches with the ground truth array
2. Check that the fetch module iterates through the entire `pdf.hex` correctly (with the PC+4 functionality, PCSrc = 0).
3. Check that the fetch module branches correctly (using PC + Imm functionality, PCSrc = 1). This was done by feeding the module with a vector of Imm positions to jump forward or backwards and to compare the instruction output with the ground truth array.
4. Check that the fetch module correctly stalls with PCSrc = 3 (This is implemented to stall with trigger).
5. Finally, a test that mixes all the previous components to ensure they all work in tandem.

![fetch_tb](../images/joel/fetch_tb.png)

As expected, we receive a full score on the testbench.

### Co-wrote the testbench scripts for f1_fsm with Kevin and wrote the testbench script for Vbuddy PDF