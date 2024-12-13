# Complete Implementation

In this complete implementation, we integrated a 1k word (4096 bytes) two-way set associative cache with our pipelined processor, running a full RV32I ISA. We also implemented cache miss stall to simulate the delay that comes with reading from RAM on a cache miss.

To demonstrate the full RV32I implementation, we have included `6_shift.s`, `7_logic.s`, `8_load.s` in `./tb/asm` which tests the remaining RV32I instructions. These scripts are run along with the provided test cases in `doit.sh`.

#### Quick Start - GTest Testing

To run the provided tests within the target branch,
```bash
 cd ./tb
 ./doit.sh
```

For unit testing each module top (fetch_top, decode_top, execute_top, memory_top), we wrote individual C++ testbenches written with GTest that can be found in `./tb/our_tests`. The scripts to run them are found in `./tb/bash`, where they are named similarly. However, please run them while in `./tb` and not in `./tb/bash`. To run the tests we wrote for individual components (while in `./tb/`):

```bash
sudo chmod +x ./bash/<unit_test>.sh
./bash/<unit_test>.sh
```

#### Quick Start - Vbuddy Tests

##### **Windows only**: remember to include `~/Documents/iac/lab0-devtools/tools/attach_usb.sh` command to connect Vbuddy.

To run the f1 light test within the `./tb/` folder,

```bash
sudo chmod +x f1_test.sh
./f1_test.sh
```

To run the pdf test within the `./tb/` folder,
```bash
sudo chmod +x pdf_test.sh
./pdf_test.sh
```

Both `cpp` scripts can be found in `./tb/vbuddy_test`. The distribution for the pdf test can be changed by overwriting the distribution name in `./tb/vbuddy_test/pdf_tb.cpp` in line 13.
```cpp
// can change to "noisy" or "triangle"
const std::string distribution = "gaussian"; 
```