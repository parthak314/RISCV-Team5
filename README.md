# Two-Way Set Associative Write-Back Cache Implementation

This branch implements a 1k word (4096 byte) two-way set associative write-back cache on the base single-cycle processor. It was later modified and combined with the pipelined implementation in our complete processor.

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