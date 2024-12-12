# Superscalar

For our superscalar processor, we implemented a dual-ALU superscalar processor that runs a full ALU RV32I ISA. We also wrote a `cpp` script that does assembly optimisation to create an out-of-order execution assembly file. We did not have time to implement other operations, namely branching/jumping and memory load/store.

To test the functionality of the script and processor, we modified the `doit.sh` script to test our processor with 3 regular in-order assembly files (containing ALU only operations), found in `./tb/asm/`. The `doit.sh` script will then optimise and re-order the content of the assembly files, before assembling and running GTest with them.

### Quick Start
To run the tests we created,
```bash
cd ./tb
./doit.sh
```
