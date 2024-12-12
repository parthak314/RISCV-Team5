# Complete Implementation

In this complete implementation, we integrated a 1k word (4096 bytes) two-way set associative cache with our pipelined processor, running a full RV32I ISA. We also implemented cache miss stall to simulate the delay that comes with reading from RAM on a cache miss.

To demonstrate the full RV32I implementation, we have included `6_shift.s`, `7_logic.s`, `8_load.s` in `./tb/asm` which tests the remaining RV32I instructions. These scripts are run along with the provided test cases in `doit.sh`.

#### Quick Start - GTest Testing

To run the provided tests within the target branch,
```bash
 cd ./tb
 ./doit.sh
```

To run the tests we wrote for individual components (while in `./tb/`),
```
./run_our_tests.sh
```

The script above runs all of our tests. However, the individual C++ testbenches can be found in `./tb/our_tests` and are written with GTest. The scripts to run them are found in `./tb/bash`, where they are named similarly.

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