#include <utility>
#include <csignal>
#include <iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdut.h"
#include "../tests/cpu_testbench.h"
#include "vbuddy.cpp"     // include vbuddy code

#define MAX_SIM_CYC 1e9
#define MAX_FUNC_CYC 1e6

// remove hex files on ctrl + c
void end_program(int signum) {
  std::cout << "\nShutting down..." << std::endl;
  std::ignore = system("rm -f program.hex data.hex");
  exit(signum);
}

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges

  signal(SIGINT, end_program); // detect ctrl + c

  std::ignore = system("./assemble.sh reference/pdf.s");
  std::ignore = system("touch data.hex");
  std::ignore = system("cat ./reference/noisy.mem > data.hex");

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
  vbdHeader("PDF");
  //vbdSetMode(1);        // Flag mode set to one-shot

  // initialize simulation inputs
  top->clk = 0;
  top->rst = 0;
  top->trigger = 0;

  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }
    // only plot after the signal generating function is done
    if (simcyc > MAX_FUNC_CYC) {
      vbdCycle(simcyc);
      vbdPlot(top->a0, 0, 255);
    }

    // either simulation finished, or 'q' is pressed
    if ((Verilated::gotFinish()) || (vbdGetkey()=='q'))
      break;                // ... exit if finish OR 'q' pressed
  }

  vbdClose();     // ++++
  tfp->close(); 
  
  // Remove program.hex and data.hex
  std::ignore = system("rm -f program.hex data.hex");

  exit(0);
}