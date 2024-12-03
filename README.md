
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
![alt text](images/pipelined.png)
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

