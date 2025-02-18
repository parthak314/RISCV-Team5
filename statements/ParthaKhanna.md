# Personal Statement of Contributions

***Partha Khanna***

This document provides a comprehensive overview of my contributions to the RISC-V project. It outlines the completed work, the methodologies employed, the rationale behind key design decisions, the strategies used to address challenges, any mistakes encountered along the way and their subsequent resolution, as well as the insights and lessons learned from this experience.

---

## Overview
- [Single Cycle RISCV-32I Design](#single-cycle-riscv-32i-design) 
	- [Sign Extension Unit](#sign-extension-unit)
	- [Control Unit](#control-unit)
	- [Register File](#register-file)
	- [Data Memory](#data-memory)
	- [Single cycle CPU assembling and testing](#single-cycle-cpu-assembling-and-testing)
		- [F1 Assembly](#f1-assembly)
		- [Probability Distribution Function](#probability-distribution-function)
		- [System Debugging](#system-debugging)
- [Pipelined RISCV-32I Design](#pipelined-riscv-32i-design)
- [Data Memory Cache Implementation](#data-memory-cache-implementation) 
- [Complete RISCV-32I Design](#complete-riscv-32i-design)
- [Superscalar Model](#superscalar-model-of-riscv-32i)
- [Learnings and Project Summary](#learnings-and-project-summary)

---

# Single Cycle RISCV-32I Design

## Sign Extension Unit
[System Verilog](../rtl/decode/signextend.sv) | [Testbench with test cases](../tb/our_tests/signextend_test_tb.cpp) | [Shell script for testing](../tb/bash/sign_extend_test.sh)
### Aims
- Create a module that will sign extend the immediate value.
- However, the problem we face here is that there are many types of instructions, each with a different arrangement for the immediate to be sign extended

### Implementation
Using what I created in the reduced RISC-V CPU (lab 4), I extended this to include all other instruction types. This meant using `ImmSrc` for 5 different instruction types (excluding R-type since it has no immediate).

The following structure was used for each of the instruction types:

![Instruction types](../images/partha/instruction-types.png)

We can do this by using a `select case` statement which concatenates different parts of the instruction to form the immediate.
The `ImmSrc` is taken from the control unit which send the value of this as per the opcode.

Considering that there are 5 instructions `I-type`, `S-type`, `B-type`, `U-type`, `J-type`, we have 2 options - therefore requiring 3 bits for `ImmSrc` as shown below.

| **`ImmSrc`** | **Instruction Type** |
| --- | --- |
| `000` | Immediate |
| `001` | Store |
| `010` | Branch |
| `011` | Jump |
| `100` | Upper Immediate |
### Testing
Using G-test to check whether this works following the basic framework along with a test block for each of the instruction types and by manually finding an expected solution.
An example for this is for U-type:

```cpp
TEST_F(SignExtensionTest, Utype) {    
		dut->instr = 0xff600313;
		dut->ImmSrc = 0b011;    
		evaluate();    
		EXPECT_EQ(dut->ImmOp, 0xFFFFF600);
}
```

---
## Control Unit
[System Verilog](../rtl/decode/control.sv) | [Testbench with test cases](../tb/our_tests/control_test_tb.cpp) | [Shell script for testing](../tb/bash/control_test.sh)
### Aims
- Create a module that will take in the 32 bit instruction and produce the required signals that depend on the `op` (opcode), `funct3`, `funct7` (part of instruction) and the flags `zero` and `negative`.
### Implementation
The inputs and outputs of the system are:
- Inputs
    - `op` - The 7 bit opcode that is the classification for the instructions
    - `funct3` - defining the type of instruction under the classification (within `op`)
    - `funct7` - More specific instruction classification (not always required) - 2nd MSB of instr
    - `zero` - flag for when 2 entities are equal
    - `negative` - flag for when a value is less than 0 (MSB is 1 for signed 2s complement values)
- Outputs
    - `PCsrc` - immediate (0) vs pc + 4 (1) for program counter increment
    - `ResultSrc` - data to store in register file
    - `MemWrite` - write enable to data mem
    - `ALUcontrol` - controls the operation to perform in the ALU
    - `ALUSrc` - immediate vs register operand for ALU
    - `ImmSrc` - Type of sign extend performed based on instruction type
    - `RegWrite` - enable for when to write to a register

The image below shows the structure for this and the table below shows the value for each of the control bits:

![Untitled(10).png](../images/partha/control-unit.png)

| **Instruction Type** |   **`PCSrc`**   | **`ResultSrc`** | **`MemWrite`** |  **`ALUcontrol`**   | **`ALUSrc`** | **`ImmSrc`** | **`RegWrite`** |
| -------------------- | :-------------: | :-------------: | :------------: | :-----------------: | :----------: | :----------: | :------------: |
| R-type               |       `0`       |      `00`       |      `0`       | `get_ALU_control()` |     `0`      |    `XXX`     |      `1`       |
| I-type (ALU)         |       `0`       |      `00`       |      `0`       | `get_ALU_control()` |     `1`      |    `000`     |      `1`       |
| I-type (load)        |       `0`       |      `01`       |      `0`       |       `0000`        |     `1`      |    `000`     |      `1`       |
| I-type (`jalr`)      |       `1`       |      `10`       |      `0`       |       `0000`        |     `1`      |    `000`     |      `1`       |
| S-type               |       `0`       |      `XX`       |      `1`       |       `0000`        |     `1`      |    `001`     |      `0`       |
| B-type               | as per `funct3` |      `XX`       |      `0`       |       `0001`        |     `0`      |    `010`     |      `0`       |
| J-type (`jal`)       |       `1`       |      `10`       |      `0`       |       `XXXX`        |     `X`      |    `011`     |      `1`       |
| U-type (`lui`)       |       `0`       |      `11`       |      `0`       |       `XXXX`        |     `X`      |    `100`     |      `1`       |
| U-type (`auipc`)     |       `0`       |      `00`       |      `0`       |       `0000`        |     `1`      |    `100`     |      `1`       |

**PCSrc:**
The value for `PCSrc` in the branch instruction type depends on the value for `funct3` which can be implemented with the flags `zero` and `negative` 

```verilog
case (funct3)
	    3'b000: PCsrc = zero; // beq
	    3'b001: PCsrc = ~zero; // bne
	    3'b100: PCsrc = negative; // blt 
	    3'b101: PCsrc = ~negative; // bge
	    3'b110: PCsrc = negative; // bltu
	    3'b111: PCsrc = ~negative; // bgeu
	    default: PCsrc = 1'b0; // Default case
endcase
```

If `PCSrc` is 0, the program counter increments to the next instruction (with byte addressing this is PC + 4). If `PCSrc` is 1, the program counter increments to PC + immediate.

**ALUcontrol:**
The value for `ALUcontrol` is determined by `get_ALU_control()` for R-type and I-type (alu) instructions. When designing this it is important that we have parameters addressed by reference, but it is not critical to return a value making a systemVerilog task better in this scenario than a function.

```systemVerilog
case (funct_3)
      3'd0: if (op_code == 7'b0010011) ALU_control = 4'b0000;
            else                       ALU_control = funct_7 ? 4'b0001 : 4'b0000; // add | addi (funct7 = 0) or sub (funct7 = 1)
      3'd1: ALU_control = 4'b0101; // sll | slli
      3'd2: ALU_control = 4'b1000; // slt | slti
      3'd3: ALU_control = 4'b1001; // sltu | sltiu
      3'd4: ALU_control = 4'b0100; // xor | xori
      3'd5: ALU_control = funct_7 ? 4'b0110 : 4'b0111; // srl | slri (funct7 = 0) or sra | srai (funct7 = 1)
      3'd6: ALU_control = 4'b0011; // or | ori
      3'd7: ALU_control = 4'b0010; // and | andi
      default: ALU_control = 4'b0000; // undefined
  endcase
```

Which satisfies the following implementation as per the RISC-V 32I base instructions:

![image.png](../images/partha/alucontrol-instructions.png)

**ResultSrc:**
`ResultSrc` was initially defined as 1 bit as the select signal for the result which is written into the regfile on the next clock cycle. When this is:

- `0`, `ALUResult` is written back for R-type, I-type (ALU) and branch comparisons.
- `1`, `ReadData` is written back for I-type (load) instructions.

However this poses a problem since jump instructions cannot be implemented. therefore, we make use of this revised model with a 2-bit value:

- `00` and `01` are equivalent to previous
- `10`, PC + 4 is stored for jump instructions like `jal` and `jalr` to store the return address in the register before jumping to a new target address
- `11`, when storing upper immediate values into the registers for `lui` and `auipc`

### Testing
Using G-test for the following test cases:
- R-type Instruction
    - inputs: opcode `0110011`, `funct3` = `000`, `funct7` = `0`
    - outputs: `RegWrite = 1`, `ALUSrc = 0`, `MemWrite = 0`, `ResultSrc = 00`, `PCsrc = 0`, `ALUcontrol = 0000` (Add)
- I-Type Addi Instruction
    - inputs: opcode `0010011`, `funct3` = `000`, `funct7` = `0`
    - outputs: `RegWrite = 1`, `ALUSrc = 1`, `MemWrite = 0`, `ResultSrc = 00`, `PCsrc = 0`, `ALUcontrol = 0000` (Add immediate)
- I-Type Load Instruction
    - inputs: opcode `0000011`, `funct3` = `010`, `funct7` = `0`
    - outputs: `RegWrite = 1`, `ALUSrc = 1`, `MemWrite = 0`, `ResultSrc = 01`, `PCsrc = 0`, `ALUcontrol = 0000` (Add for address calculation)
- B-Type Branch Equal
    - inputs: opcode `1100011`, `funct3` = `000`, `zero` = `1`
    - outputs: `RegWrite = 0`, `MemWrite = 0`, `PCsrc = 1` (Branch taken), `ALUcontrol = 001` (Subtraction)
- J-Type Jal
    - inputs: opcode `1101111`
    - outputs: `RegWrite = 1`, `MemWrite = 0`, `PCsrc = 1` (Jump), `ResultSrc = 10` (PC + 4)
- Default Case
    - inputs: opcode `1111111`
    - outputs: `RegWrite = 0`, `MemWrite = 0`, `ResultSrc = 00`, `PCsrc = 0`, `ALUcontrol = 0000` (Default)

---

## Register File
[System Verilog](../rtl/decode/reg_file.sv) | [Testbench with test cases](../tb/our_tests/reg_file_test_tb.cpp) | [Shell script for testing](../tb/bash/reg_file_test.sh)
### Aims
- Design an array to store 32 32-bit registers including the zero register (x0) hardwired to 0.
- Asynchronous Reads and Synchronous Writes to minimise delays
### Implementation
Inputs, outputs and Parameters used here are:

- Parameters:
    - `DATA_WIDTH = 32` to specify the bit width of the registers
    - `ADDR_WIDTH = 5` to specify the number of registers.
- Inputs:
    - `clk` to synchronise writes
    - `reset` used to clear all registers
    - `write_enable` (`WE3`) control signal to enable writing to a register
    - `read_addr1` (`A1`) and `read_addr2` (`A2`) addresses for the read ports
    - `write_addr` (`A3`) write port address
    - `write_data` (`WD3`) Data to write into the register specified by `write_addr`
- Outputs:
    - `read_data1` (`RD1`) and `read_data2` (`RD2`) contains the data read from the specified registers
    - `a0` - debug the output for monitoring register 10

![Register File Schematic](../images/partha/regfile-schematic.png)

The registers are first created as an array by:

```systemVerilog
logic [DATA_WIDTH-1:0] registers [2**ADDR_WIDTH-1:0];
```

The entire RISC-V CPU makes use of all 32 32-bit registers with some kept for a specific purpose and others for temporary and other usage as described here:

![registers](../images/partha/registers.png)

This is also specified here: [https://en.wikichip.org/wiki/risc-v/registers](https://en.wikichip.org/wiki/risc-v/registers)

**Reading:**

```systemVerilog
assign read_data1 = registers[read_addr1];
assign read_data2 = registers[read_addr2];
```

**Writing:**

This is in sequential logic, on the positive/rising clock edge, values are written to the specified register as long as write enable is high and the write address is not 0 (pointing to x0 which is hardwired to 0)

This encourages efficient operand access with dual read ports, useful for R-type instructions, compliant with RISC-V standard since x0 is not modified, reset functionality exists to provide a clean initial state for the processor and in case it needs to be reinitialised at any point, produces an output `a0` which may be utilised for debugging.

### Testing
- Reset Test
    - inputs: `reset = 1`, then `reset = 0`
    - outputs: All registers are `0`
- Write and Read Valid Register
    - inputs: `write_addr = 1`, `write_data = 0xA5A5A5A5`, `write_enable = 1`, `clk ↑`; then `read_addr1 = 1`
    - outputs: `read_data1 = 0xA5A5A5A5`
- Write and Read Another Register
    - inputs: `write_addr = 2`, `write_data = 0xDEADBEEF`, `write_enable = 1`, `clk ↑`; then `read_addr2 = 2`
    - outputs: `read_data2 = 0xDEADBEEF`
- Write to Register 0 Should Not Change
    - inputs: `write_addr = 0`, `write_data = 0x12345678`, `write_enable = 1`, `clk ↑`; then `read_addr1 = 0`
    - outputs: `read_data1 = 0`
- Reset After Write Operations
    - inputs: `write_addr = 1`, `write_data = 0xA5A5A5A5`, `write_enable = 1`, `clk ↑`; then `reset = 1`, `clk ↑`, `reset = 0`
    - outputs: All registers are `0`
- Write and Read Multiple Registers
    - inputs: `write_addr = 1`, `write_data = 0x1`, `write_enable = 1`, `clk ↑`; then `write_addr = 2`, `write_data = 0x2`, `clk ↑`; then `read_addr1 = 1`, `read_addr2 = 2`
    - outputs: `read_data1 = 0x1`, `read_data2 = 0x2`
- Write and Read From Same Register
    - inputs: `write_addr = 3`, `write_data = 0xDEADBEEF`, `write_enable = 1`, `clk ↑`; then `read_addr1 = 3`, `read_addr2 = 3`
    - outputs: `read_data1 = 0xDEADBEEF`, `read_data2 = 0xDEADBEEF`
- Write With Multiple Clocks
    - inputs: `write_addr = 4`, `write_data = 0x12345678`, `write_enable = 1`, `clk ↑`; then `read_addr1 = 4`
    - outputs: For 3 cycles after the write, `read_data1 = 0x12345678`

### Potential Enhancements
- Clock gating for Power efficiency. In a low power concept, clock gating (disabling the clock) can be added to disable write operations for when `write_enable` is low.
- Verify that the address is less than 32 for writing
- Use other addresses for output as defined above - registers which return a value are also `a1`, `f10`, `f11`

---

## Data Memory
[System Verilog](../rtl/memory/datamem.sv)

Whilst Kevin provided the basic framework for this section, I helped to add byte and word addressing.
### Implementation

In the single cycle model, we only require the word and byte wise addressing. This include `sb` `sw` `lbu` `lw`. The full loading and storing is implemented in the completed model.
#### Loading
This was implemented by combinational logic for loading (since this is effectively reading a value from the data memory):
``` systemVerilog
if (addr_mode) rd = {24'b0, ram_array[a[16:0]]}; // load unsigned byte
else begin // load word
   rd = {ram_array[a[16:0] + 3], 
		 ram_array[a[16:0] + 2], 
		 ram_array[a[16:0] + 1], 
		 ram_array[a[16:0]]};
end
```

Since a byte is the same width as the data stored in `ram_array`, we can simply extend this value with `0` at the front for the initial 3 bytes since the value we are to output is 32 bits or 4 bytes.
Noting that a word is 32 bits/4 bytes itself, we can follow a similar approach by extracting consecutive bytes from the data memory and concatenating this into a 32 bit value as opposed to setting the most significant 3 Bytes as 0.

#### Storing
For storing, since we only store a value on the positive edge of a clock cycle (for the purpose of synchronisation and timing control), we need to have sequential logic here which will only execute if the write enable is high (as a safety measure to prevent inadvertent overwriting).

```systemVerilog
if (we) begin
	if (addr_mode) begin // store byte
		ram_array[a[16:0]] <= wd[7:0];
	end else begin // store word
		ram_array[a[16:0]] <= wd[7:0];
		ram_array[a[16:0] + 1] <= wd[15:8];
		ram_array[a[16:0] + 2] <= wd[23:16];
		ram_array[a[16:0] + 3] <= wd[31:24];
	end
end
```

For storing a byte, since the data memory has a width of 1 byte, we can simply store in the value from the incoming write data variable. For storing a word, we can follow a similar approach to load word by storing in each byte of the incoming data in consecutive bytes of the data memory.

### Testing
These instructions were implemented and tested alongside tests provided. 

## Single cycle CPU assembling and testing
After the individual components had been designed and tested, I assembled them into the `data_top.sv` file which is the top module for the control unit, sign extension and register file.

This was then incorporated by Joel into the `top.sv` which is the model of the CPU at this stage.

This was then tested through the following test cases (assembly, shell scripts and testbench) that were already provided:
1. `addi bne`: initialising registers, incrementing values, comparing values with conditional branching
2. `li add`: handling loading large signed and unsigned values and performing addition
3. `lbu sb`: storing bytes, loading unsigned bytes and adding the loaded values
4. `jal ret`: using `jal`(jump and link) and `ret` (a special case of `jalr x0, ra, 0`) to add numbers and output a result
5. `pdf`: counting occurrences of data values  and computing the sum  for different probability distribution functions.
There were 2 tests for which extra work was done by @Joel and myself:
### F1 Assembly
[RISC-V Assembly](../tb/asm/f1_fsm.s) | [Test bench](../tb/vbuddy_test/f1_fsm_tb.cpp) | [Bash Script](../tb/f1_test.sh)
I created the program to test the F1 lights as per previous lab work. The basic version tests the lights sequences whereas a more advanced version tests this using a random delay (the pseudorandom binary value generated by the LFSR module).

This project builds a finite state machine (FSM) with 9 states (`S_0` to `S_8`), where each state represents the number of LEDs lit on the VBuddy, visualised using the `vbdBar()` function. The FSM transitions between states using binary left-shifted values, updated through `slli` and `ori` operations.

The FSM starts in `S_0` and progresses through all states until reaching `S_8`, where it resets back to `S_0`. A fixed 1-second delay is implemented between state transitions using a counter (`t2`) and a delay loop, ensuring consistent timing. At `S_8`, the FSM introduces a pseudo-random delay generated by a Linear Feedback Shift Register (LFSR), seeded with `0b10110101` and updated using XOR (`xori`) and shift operations. This delay is capped at 10 cycles using modulo (`rem`) to maintain control.

The system manages two key outputs based on the current state. The `cmd_seq` output is activated during states `S_1` to `S_7` and reset in `S_0`. Meanwhile, `cmd_delay` is triggered in `S_8` to indicate the random delay is in progress. Conditional branching (`beqz` and `bne`) dynamically handles state-specific behaviours, ensuring smooth transitions.

The FSM operates in a continuous loop, efficiently managing transitions and outputs. The integration of bitwise operations and the LFSR ensures low computational overhead while adding controlled randomness during `S_8`. This makes the design ideal for embedded systems requiring synchronised state transitions and variable delays.

The execution involved creating a test bench and a shell script. 

A video demonstrating the FSM execution is provided in the team statement.
### Probability Distribution Function
[RISC-V Assembly](../tb/asm/5_pdf.s) | [Test bench](../tb/vbuddy_test/pdf_tb.sh) | [Bash Script](../tb/pdf_test.sh)
We then tested the system by creating a test bench for various `*.mem` files provided as the input for `pdf.s`. This included `noisy.mem`, `gaussian.mem` and `triangle.mem`. 

The execution involved creating a test bench and a shell script. 

The videos can be found on the team statement.
### System Debugging
As a result of testing and debugging (using gtkwave), we found out that there were certain issues which were debugged, with the following being the notable changes:
- `jal` uses byte addressing so has an assumed `0` at the LSB position, which was implemented.
- `a0` needed to be an output register.
- `PCSrc` currently increments to either the next instruction or branches to another instruction. However, for jumping the target is the immediate field. However by using a 4x2 mux, it not only uses extra hardware but also results in a vacant space for `PCSrc = 11`. This is useful later on for when a stall is required, which can be pre-emptively addressed here:

| `PCSrc` | Program counter    | Action                                                       |
| ------- | ------------------ | ------------------------------------------------------------ |
| `00`    | `PC = PC + 4`      | Go to next instruction                                       |
| `01`    | `PC = PC + Target` | Branch to another instruction (relative to current position) |
| `10`    | `PC = imm`         | Jumping to another position regardless of current position   |
| `11`    | `PC = PC`          | PC stall (repeat current PC cycle)                           |

- `Trigger` was also used but the current implementation would stall at the current program counter, but this implementation is not sufficient for all opcodes as it will continue adding/subtracting during the stall. This can be solved by routing trigger through the control unit to ensure that the default values are instated (with no writing to registers/memory).

---
# Pipelined RISCV-32I Design

## Aims
Developing a pipelined version of the single cycle model by:
-  Adding a pipeline register to store Instruction fields, such as opcodes and operands
- Control signals propagation
- Connection to the Hazard Unit for hazard handling such as stalling, data forwarding and flushing.
## Implementation
The decode section contains the following file structure:
```
├── control_unit.sv
├── decode_pipeline_regfile.sv
├── decode_top.sv
├── register_file.sv
└── sign_ext.sv
```
There are no changes to the sign extension and register file modules.
However, for the control unit, since the `zero` and `negative` flags can no longer be used (since they cannot loop back from the execute section into the decode section), we make use of the `branch` and `jump` control signals which are implemented as:

| `branch` | logic     |
| -------- | --------- |
| `000`    | No branch |
| `001`    | beq       |
| `010`    | bne       |
| `100`    | blt       |
| `101`    | bge       |
| `110`    | bltu      |
| `111`    | bgeu      |
`branch` value `011` is not used since this implementation uses the logic:
- if `branch` = `0` then no branching
- if `branch` != `0`:
	- `branch[2]` = 0: use zero flag
	- `branch[2]` = 1: use negative flag
Similarly with jump:

| `jump` | logic         |
| ------ | ------------- |
| `00`   | no jump       |
| `01`   | `jal`         |
| `10`   | `jalr`        |
| `11`   | trigger/stall |

For the `decode_pipeline_regfile.sv`, this acts a the bridge between the decode and execute stages by holding the intermediate values and control signals.
It has the specifications:
- Inputs: Control Signals, Register operands, Immediate Values, Program counter.
- Outputs: Propagated signals and operands to execute stage/
Implementing the control logic:
- On a negative clock edge, data is latched into pipeline register
- Enable signal (`en`) determines if data is written into the register, `clear` signal resets/flushes the register such as when jumping or branching

For the top module integration, we can then combine these together - as can be seen in `decode_top.sv`

## Testing
In this case, Testing can quite simple since we can check to ensure that the values are reverted back to 0 if there is a clear, no value is written if there is a low enable and the entire unit operates as intended with slight modifications to the tests conducted with the decode section in the single cycle.

This can be verified with gtkwave.

Looking at the first test case, `1_addi_bne.s`, We can see that there is a branch that occurs. which means that we expect clear to be high when the branch is performed (which means that the output values from the decode pipeline register is `0`. However, at other times (since there are no jumps) for any other instruction implemented, we expect the values to be the same.

![](../images/partha/pipeline-addibne-waveform.png)
## Potential Enhancements and Learnings

Whilst branch prediction could be implemented in the future to anticipate control flow changes, this is not required for the complete RISC-V model.

In terms of technical learnings from this stage, I have been able to understand the principles of pipeline synchronisation,  use of modular design during implementing and testing and Read-After-Write hazards (RAW) that are addressed through stalling and forwarding.

---
# Data Memory Cache Implementation
[System Verilog (top level)](../rtl/) | [Testbench with test cases](../tb/our_tests/signextend_test_tb.cpp) | [Shell script for testing](../tb/bash/sign_extend_test.sh)
This was a team effort between Joel and myself.
## Aims
Implementing a 2-way set associative cache system which can:
- Reduce memory access time by leveraging temporal and spatial locality
- Minimise cache misses by associating multiple blocks with each set
- Implement an LRU replacement policy for evictions
- Uses dirty bit tracking for optimising memory writes.

## Implementation
Using what is provided on the lecture slides, 2 way cache associative means that the number of sets is 512, with each set containing 2 data blocks, containing the valid, dirty and tag bits and 1 LRU bit.

| Bits per Set | Description                                   | Size               |
| ------------ | --------------------------------------------- | ------------------ |
| LRU Bit      | Tracks which block to evict                   | 1 bit              |
| Valid Bit    | Indicate whether blocks are valid             | 2 bits (1 per way) |
| Dirty Bit    | Indicate modified blocks requiring write-back | 2 bits (1 per way) |
| Tags         | Distinguish memory addresses                  | 21 bits * 2        |
| Data Words   | Actual data stored in the cache               | 32 bits * 2        |
The address is 32 bits which is divided into:

| Bits        | Purpose                                    | Size |
| ----------- | ------------------------------------------ | ---- |
| Tag Bits    | Distinguishes blocks across sets           | 21   |
| Set Index   | Identifies the target set within the cache | 9    |
| Byte Offset | Identifies the byte within a word          | 2    |

Now that cache design parameterisation is complete, we can focus on the key areas of this:

**Hit Detection**: Checks if the requested tag matches any block in the set and if the valid bit is set. For each way (`0` and `1`): 
```systemVerilog
hits[way] = v_bits[way] && (tags[way] == target_tag)
```

**Miss Handling**: If no hit occurs then:
- **Eviction**: Select the block to evict based on LRU bit and if it is valid and dirty then it writes back to memory.
- **Replacement**: Reads the requested data from RAM and updates the evicted block with the new data and resets the dirty bit.

**Writing**: When a cache write occurs, the data is updated in the cache, thus marking the block as dirty and indicating that it differs from memory.

**Reading**: This returns the data based on the address mode which is implemented as Word addressing or Byte addressing initially (then changed to include half addressing)
## Testing
Before beginning testing, we nee to establish performance metrics. These are:
1. **Hit and Miss Rates**: $HR$, $MR = 1-HR$ 
2. **Average Memory Access times**: $= t_{cache} + t_{MM} \cdot MR_{cache}$ .
		Given a miss rate of $20\%$ for this implementation of cache, it means that $AMAT =  1+(100*0.2) = 21 cycles$
3. **Eviction Behaviour**

The strategy here is to perform unit testing by simulating individual cache operations, such as verifying hit and miss detection logic. 
Then continue with Integration testing by connecting the cache with the sram and main memory modules, testing the section.
Then finally testing the entire system's performance with the new changes put in place. (the evidence for this is seen in the Team statement).

1. Cache Read Hit (Single with Word Addressing)
   - Inputs: `addr = 0x0004` `wd = 0xFACEFACE` `we = 1` `addr_mode = 0`
   - Outputs: `rd = 0xFACEFACE` `we_to_ram = 0`

2. Cache Read Hit (Single with Byte Addressing)
   - Inputs: `addr = 0x0004` `wd = 0x000000FF` `we = 1` `addr_mode = 1`
   - Outputs: `rd = 0x000000FF` `we_to_ram = 0`

3. Cache Read Miss (Single with Word Addressing)
   - Inputs: `addr = 0x0008` `we = 0` `addr_mode = 0` `rd_from_ram = 0xDEADBEEF`
   - Outputs: `rd = 0xDEADBEEF` `we_to_ram = 0`

4. Cache Read Hit with Multiple Words
   - Inputs: 
     - Write: `addr = 0x0000`, `wd = 0xA5A5A5A5` `addr = 0x0004`, `wd = 0xA5A5A5A6`
       `addr = 0x0008`, `wd = 0xA5A5A5A7` `addr = 0x000C`, `wd = 0xA5A5A5A8` 
       `we = 1` `addr_mode = 0`
     - Read: `addr = 0x0000` `addr = 0x0004` `addr = 0x0008` `addr = 0x000C`
       `we = 0` `addr_mode = 0`
   - Outputs: 
     - `rd = {0xA5A5A5A5, 0xA5A5A5A6, 0xA5A5A5A7, 0xA5A5A5A8}`
     - `we_to_ram = 0`

5. Cache Read Hit with Multiple Bytes
   - Inputs: 
     - Write: `addr = 0x0000`, `wd = 0xA5A5A5A5` `addr = 0x0010`, `wd = 0xA5A5A5A6`
       `addr = 0x0020`, `wd = 0xA5A5A5A7` `addr = 0x0030`, `wd = 0xA5A5A5A8`
       `we = 1` `addr_mode = 1`
     - Read: `addr = 0x0000` `addr = 0x0010` `addr = 0x0020` `addr = 0x0030`
       `we = 0` `addr_mode = 1`
   - Outputs: 
     - `rd = {0xA5A5A5A5, 0xA5A5A5A6, 0xA5A5A5A7, 0xA5A5A5A8}`
     - `we_to_ram = 0`

6. Cache Write Hit
   - Inputs: `addr = 0x0008` `wd = 0xCA7490EF` `we = 1` `addr_mode = 0`
   - Outputs: `we_to_ram = 0`

7. Cache Write Miss
   - Inputs: `addr = 0x0030` `wd = 0xDEADBEEF` `we = 1` `addr_mode = 0`
   - Outputs: 
     - `we_to_ram = 1`
     - `wd_to_ram = 0xDEADBEEF`
     - `w_addr_to_ram = 0x0030`

8. Cache Eviction
   - Inputs: 
     - Write: `addr = 0x0004`, `wd = 0xAAAAAAA1` `addr = 0x20004`, `wd = 0xBBBBBBB2`
       `we = 1` `addr_mode = 0`
     - Trigger Eviction: `addr = 0x40004` `rd_from_ram = 0x12345678` `we = 0` `addr_mode = 0`
   - Outputs: 
     - Eviction: 
       - `we_to_ram = 1`
       - `w_addr_to_ram = 0x0004`
       - `wd_to_ram = 0xAAAAAAA1`
     - New Data: `rd = 0x12345678`

9. Complete Cache Behaviour
   - Inputs: 
     - Write: `addr = 0x0004`, `wd = 0x11111111` `addr = 0x0014`, `wd = 0x22222222`
       `we = 1` `addr_mode = 0`
     - Read: `addr = 0x0004`, `we = 0` `addr = 0x0014`, `we = 0`
     - Trigger Eviction: `addr = 0x0024` `rd_from_ram = 0x33333333` `we = 0`
   - Outputs: 
     - Reads: `rd = 0x11111111` `rd = 0x22222222`
     - Eviction: 
       - `we_to_ram = 1`
       - `w_addr_to_ram = 0x0004`
       - `wd_to_ram = 0x11111111`
     - New Data: `rd = 0x33333333`

## Summary and Learnings

While Implementing Cache, I implemented set associativity, used LRU replacement, utilised valid and dirty bits, with byte and word addressing and this is done inside a cache controller.

There were several mistakes made in the initial model that were rectified later:
- Using independent registers instead of a packed/combined set which was useful for debugging initially but is not scalable or correct as an ideal implementation
- The testing cases don't cover multiple misses and similar edge cases

The learnings from this include:
- Understanding Temporal and Spatial locality, effectively exploiting locality to reduce access latency for repeated and sequential memory access, aligning with lecture content, especially for loops and arrays
- Increasing associativity to 2 ways which reduces conflict misses without lots of complexity of fully associative cache, balancing performance and design overhead.
- Cache misses that can trigger costly memory accesses, so implementing the design that handles write-back and read-through strategies that minimise coherence issues and miss latency.

In the future, we can enhance this model by implementing:
- Prefetching: Add a system to anticipate and load likely-to-be-accessed data during misses to reduce future miss rates (further to spatial locality) which is a similar concept to dynamic branch prediction.
- Dynamic Block Sizing
- Multi Level cache with varying speeds and sizes.

---
# Complete RISCV-32I Design

The main alterations for this section were checking over and making minor adjustments to `decode_top.sv`. 
Further, I assisted in debugging and testing.

---
# Superscalar Model of RISCV-32I

## Implementation

Looking at the schematic, we see that there are 2 major areas for development. This is the Out-of-order processor and changing all the hardware. 

### Out-of-order processor
Note: The initial implementation was done in rust, but a different implementation was put in place by Joel (a more efficient alternative) which is available in both Python and C++.
The initial implementation in rust is available here: 
https://gist.github.com/parthak314/32b124b0622381cd2cc28686a15ba2fe

This module reorders instructions to avoid hazards while maximizing parallelism, respecting dependencies and therefore preventing race conditions.
First, to understand the dependencies, we have 
- RAW (Read After Write): A later instruction reads a value written by an earlier one.
- WAR (Write After Read): A later instruction writes to a register read by an earlier one.
- WAW (Write After Write): Two instructions write to the same register.

One potential implementation is to use a Hash map with keys as instruction indices and values are dependant instructions. We then count the incoming dependencies for each instruction and add the instructions with no dependencies to the queue for execution.
This allows us to build a dependency graph and reorder the instructions, removing them from the queue and reducing their dependents' indegree.

Then outputting the result.

However, now we face issues such as:
- Higher dependency by using nested loops for error checking
- Using a static dependency graph that doesn't dynamically adapt to changes when instructions are issued
- No verification for valid inputs

These issues are addressed in Joel's personal statement where a better model was developed.

### Hardware
Many changes were made in order to pass through 2 instructions simultaneously.
This is a brief overview of them:
- Duplicate ALU
- Enhanced Data Memory to support 2 separate sets of inputs and outputs for parallel memory operation
- Additional Register File ports for 2 instructions
- Fetching 2 instructions per cycle
- PC increment multiplexing
- Control unit changes
- Control signals changes - now implemented as 2 bit values with the Most significant bit(s) for instruction A and the least significant for instruction B.
- Sign Extension enhancement for 2 inputs and 2 outputs
This effectively implements 2 data paths and this can be visually seen on the schematic I created below:

![Super Scalar processor](../images/superscalar-model.png)

## Testing
Since only selected instructions were implemented, we were required to develop our own test cases.
This can be seen on the Team statement.

---
# Learnings and Project Summary
My involvement in the RISC-V project encompassed diverse areas, allowing me to contribute significantly while developing both technical and non-technical skills. 

On the technical front, I designed and implemented essential modules, including the Control Unit, Sign Extension Unit, and Register File, ensuring their adherence to RISC-V architecture standards. I played a key role in the Data Memory Cache implementation, introducing features such as two-way set associativity, LRU replacement, and dirty bit tracking to enhance performance. I contributed to integrating the single-cycle processor components and advancing to the pipelined processor, understanding hazards with effective stalling and forwarding techniques and making upgrades to the decode section. Additionally, I was involved in the superscalar processor model's development, adapting hardware structures and control logic for parallel instruction execution.

Testing and debugging were integral to my role, where I crafted detailed test cases and employed tools like SystemVerilog, G-Test, and shell scripting to validate functionality. Using gtkwave, I identified and resolved issues in jump address calculations, output configurations, and PC stall mechanisms. I also contributed to innovative problem-solving, such as optimising cache performance and managing dependencies in superscalar execution, enhancing both the system's efficiency and reliability.

Beyond the technical domain, this project was a significant opportunity for personal growth in non-technical areas. Collaborating with teammates to manage tasks effectively and ensuring milestones were met taught me the value of teamwork and communication. I honed my ability to articulate design decisions, document progress clearly when working on both team documentation (with visual representation such as schematics) and personal, and adapt to feedback, ensuring alignment within the team. Problem-solving extended beyond technical challenges, including balancing deadlines with quality work and navigating project management complexities. Additionally, presenting ideas in an accessible manner helped make the project comprehensible and scalable for future development.

This project has been a profound learning journey. Technically, it deepened my understanding of processor design, pipelining, memory hierarchies, and parallel execution, while refining my skills in SystemVerilog, assembly programming, and debugging tools. On a broader level, it strengthened my analytical thinking, adaptability, and ability to work cohesively within a team. I look forward to exploring advanced topics like branch prediction and multi-level caching or even implement a functioning RISCV-32I based processor on more advanced microcontrollers for scalability, building on the foundations established through this experience.
