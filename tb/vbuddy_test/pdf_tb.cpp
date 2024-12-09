#include <utility>
#include <csignal>
#include <string>
#include <cstdlib>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdut.h"
#include "../tests/cpu_testbench.h"
#include "vbuddy.cpp"     // include vbuddy code

#define MAX_SIM_CYC 1e9
#define MAX_FUNC_CYC 1000650 // script needs time to generate the pdf function
const std::string distribution = "gaussian"; // set the distribution type here

// remove hex files on ctrl + c
void end_program(int signum) {
  std::cout << "\nShutting down..." << std::endl;
  std::ignore = system("rm -f program.hex data.hex");
  exit(signum);
};

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges
  std::string data_command = "cat ./reference/" + distribution + ".mem > data.hex";
  std::string header = "PDF: " + std::string(1, std::toupper(distribution[0])) + distribution.substr(1);

  signal(SIGINT, end_program); // detect ctrl + c

  std::ignore = system("./assemble.sh reference/pdf.s");
  std::ignore = system("touch data.hex");
  std::ignore = system(data_command.c_str());

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vdut* top = new Vdut;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("test_out/pdf/pdf.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader(header.c_str());

  // initialize simulation inputs
  top->clk = 0;
  top->rst = 0;
  top->trigger = 0;
  
  bool displaying = false;
  int original_a0 = top->a0; // record the original a0 value. If it changes, means time to display
  int j = 0; // display cycle counter (only starts incrementing when displaying)

  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }

    // when top->a0 changes value, it means the function has entered the display loop
    // this functions on the basis that the program only mutates a0 during the display phase
    if (!displaying && top->a0 != original_a0) {
      displaying = true;
    }

    // only plot after the signal generating function is done
    if (displaying) {

      // during the display phase, the plot can be paused with the rotary push button
      bool is_paused = vbdFlag();
      top->trigger = is_paused;
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
    }

    // either simulation finished, or 'q' is pressed
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q'))
      break;                // ... exit if finish OR 'q' pressed
  };

  vbdClose();     // ++++
  tfp->close(); 
  
  // Remove program.hex and data.hex
  std::ignore = system("rm -f program.hex data.hex");

  exit(0);
}