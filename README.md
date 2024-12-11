
## Table of contents:

- Single Cycle CPU Implementation
- Pipelined CPU Implementation
- Cached Implementation
- Complete RISC-V
- Superscalar Processor
==TODO: Add links==
## Repository Structure
 ==TODO: Add the repo tree with branches==

### Top Level Contributions

| Section               | Clarke | Joel | Kevin | Partha |
| --------------------- | ------ | ---- | ----- | ------ |
| Single cycle          |        |      |       |        |
| Pipelining            |        |      |       |        |
| Cache                 |        |      |       |        |
| Integration           |        |      |       |        |
| Superscalar Processor |        |      |       |        |

## Team members and Statements:

| Team Member     | GitHub                                                | CID      | Email           | Link to Personal Statement                     |
| --------------- | ----------------------------------------------------- | -------- | --------------- | ---------------------------------------------- |
| Clarke Chong    | [clarkechong](https://github.com/clarkechong)         | 02395382 | cc1823@ic.ac.uk | [Clarke's Statement](statements/ClarkeChong.md)   |
| Joel Ng         | [energy-in-joles](https://github.com/energy-in-joles) | 0219309  | zjn22@ic.ac.uk  | [Joel's Statement](statements/JoelNg.md)          |
| Kevin Aubeeluck | [Kevinaubeeluck](https://github.com/Kevinaubeeluck)   |          |                 | [Kevin's Statement](statements/KevinAubeeluck.md) |
| Partha Khanna   | [parthak314](https://github.com/parthak314)           | 02374670 | pk1223@ic.ac.uk | [Partha's Statement](statements/ParthaKhanna.md)  |
## Single Cycle
### Schematic

![RISC-V 32I single cycle CPU implementation](images/single-cycle-model.png)

![RISC-V 32I single cycle CPU implementation](images/single-cycle.jpg)
### Overview
This single cycle implementation covers the basic requirements for most CPU operations, this implements the following instructions: `R-type`, `I-type (immediate)`, `lbu`, `sb`, `beq`, `bne`, `jal`, `jalr`, `lui`.

### Contributions

| Module                       | Clarke | Joel | Kevin | Partha |
| ---------------------------- | ------ | ---- | ----- | ------ |
| alu                          |        |      |       |        |
| instr_mem                    |        |      |       |        |
| pc_register                  |        |      |       |        |
| datamem                      |        |      |       |        |
| control                      |        |      |       |        |
| reg_file                     |        |      |       |        |
| signextend                   |        |      |       |        |
| top (system integration)     |        |      |       |        |
| F1 Assembly.s                |        |      |       |        |
| System Testing and Debugging |        |      |       |        |
`X` - Lead Contributor   `*` - Partial Contributor

### Pipelined CPU
![alt text](images/pipelined-schematic.png)

Fetch - Joel \
Data - Partha\
Execute - Clarke\
Memory - Kevin

Key: * = Created ** = Edited

| Task | Files| Clarke | Partha | Joel | Kevin |
| ---- | ---- | ---- | ---- | ---- | ---- |
| <u>**Single cycle** | ---- | ---- | ---- | ---- | ---- |
| Fetch | instr_mem.sv,<br>pc_register.sv,<br>adder.sv,<br>mux.sv,<br>  | ---- | ---- | ---- | ---- |
| Data | control.sv,<br>reg_file,<br>signextend.sv | ---- | ---- | ---- | ---- |
| Execute | alu.sv,<br>mux.sv | ---- | ---- | ---- | ---- |
| Memory/Write | datamem.sv,<br>mux_4x2.sv  | ---- | ---- | ---- | ---- |
| Integration | top.sv,<br>sim_execute.cpp | ---- | ---- | ---- | ---- |
| <u>**Pipelining** | ---- | ---- | ---- | ---- | ---- |
| <u>**Cache** | ---- | ---- | ---- | ---- | ---- |
| Git | ---- | ---- | ---- | ---- | ---- |




## Joint Statement of Contribution



Below we have tasks at a glance
#### Clarke: 

Tasks:
- Task 1 
	- Explanation
- Task 2 
	- Explanation

#### Partha: 

Tasks:
- Task 1 
	- Explanation
- Task 2 
	- Explanation

#### Joel: 

Tasks:
- Task 1 
	- Explanation
- Task 2 
	- Explanation

#### Kevin: 

Tasks:
- Task 1 
	- Explanation
- Task 2 
	- Explanation




## Project Goalposts 

## Goal 1: Single-Cycle RV321 implentation of F1 lights 
## Stretch Goal 1: Pipelined RV321 Design

### Actions:
- Pipeline Stages
    - Pipeling registers
- Hazard detection Unit
    - Data Hazards
    - Control Hazards
        - Stall pipeling if data required is unavailable
        - Issue Nops or flush instructions for control hazards
        - Decide if forwarding/bypassing is possible
- Forwarding Logic
    - Multiplexers for input to ALU
    - Implement forwarding paths that verify:
         - if destination register of an earlier instruction matches source register of current ins
         - If data is available in memory/writeback, forward it to execute
    - Add forwarding control logic to determine source of operands (reg file or forwarded data)
- Stalling
    - Hold instructions in fetch and decode stages if data is unavailable
    - freeze updates in pipeline registers for affected stages
    e.g. lw followed by dependant instr
- branch handling
    - control hazards:
        - flush pipeline stages when a branch is taken
        - *branch prediction here*
- contrrol signal pipelining
    - ensure all control signals are pipelined.


### Implementation:
- Pipeline Registers between all stages
    - storing instruction data, intermediate data, control signals
- control unit
    - generate pipelined control signals
    - hazard detection and forwarding controls, data dependencies and when to forward or stall
- Hazard detection unit
    - compare source reg of current instr in decode with destination reg in execute, mem and writeback
    - stall/forward signals as needed
- Multiplexers for forwarding
    - at ALU inputs to choose between reg file vs forwarded data from Execute/memory or memory/writeback pipeline reg
- Flushing
    - if a branch is taken, clear instr in pipeline that have not been executed -> replace with nop

## Stretch Goal 2: Adding Data Memory Cache


   
## Stretch Goal 3: Full RV32I Design

## Superscalar Model Implementation
![](images/superscalar-model.png)
### Hardware
Structural design modifications:
- <span style="color:#eaa19f">Fetch</span>: No change from previous model, output is now `dataA` and `dataB` - selecting consecutive instructions from the Out-Of-Order Processor.
- <span style="color:#e9b76e">Decode</span>: Doubled inputs for each block
- <span style="color:red">Execute</span>: Replicated models for ALU
- <span style="color:#a9caf2">Writeback</span>: Doubled inputs for Data Memory with Load store separate to the data memory to reflect changes in the pipelining section. This is the load store parsing unit. A separate mux for `ResultSrc`. 
Given the time available, this model implements the instructions for `R-type`, `I-type (imm)`

### Out-of-order Processor
The key change here is the Out-Of-Order Processor which is a python script. It is simply called in the main bash script.
The High level requirements for this file are to:
- Break down the instruction set into 
- Reorder the instructions such that the same register is not accessed in consecutive instructions
- Reassemble this into the instruction set
This then follows the same procedure to assemble the instruction set (by `assemble.sh` via the `riscv gnu toolchain`) before inputting this into instruction memory, as shown above.

Further details can be seen in individual reports.
