
## Table of contents:

## Evidence 



## Team members:

```
Chong, Clarke 
Khanna, Partha
Ng, Joel
Aubeeluck,Kevin 
```

## Contribution Tables

### Single Cycle CPU
![RISC-V 32I single cycle CPU implementation](images/single-cycle.jpg)

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
### Design:
- Cache Parameters:
    - Capacity: 4096 Bytes; Block size: 4 words (16 bytes); Associativity: 2-way set associate; Sets: S = C/(bN) = 4096/32 = 128 sets each of 2 blocks
- Fields:
    - Tag (identify memory block for where the cache block is)
    - Index (Identifies set where block is stored)
    - Offset (Identifies word in a block)
    - Valid Bit (V) (if cache block contains valid data)
    - Dirty Bit (D) (if block has been modified or an update)
- Using Least recently used to decide which block to evict
- Writing:
    - Updates block in memory only when evicted, write-through writes data to both cache and memory immediately

### Pipeline modifications:
- Replace single cycle memory access in memory stage with cache controller
- Hit detection
- Replacement on miss (laod from memory)
- Write-back to memory on eviction

### Cache data path:
- Index and Offset extraction: bits of memory offset for index (select the set) and offset (word within a block)
- Tag comparison (compare tag in addresswith tags stored in cache set)
- If a miss occurs and set is full, evict a block and replace with new data based on LRU
- Cache hit: use the offset to select the word in a block
- Cache controller: handles miss logic by fetching blocks frrom main memory and updating cache

   
## Stretch Goal 3: Full RV32I Design

