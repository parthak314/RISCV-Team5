#include <utility>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdut.h"
#include "../tests/cpu_testbench.h"
#include "vbuddy.cpp"     // include vbuddy code

#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges

  std::ignore = system("./assemble.sh asm/f1_fsm.s");
  std::ignore = system("touch data.hex");

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vdut* top = new Vdut;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("f1_fsm.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader("F1 FSM");
  //vbdSetMode(1);        // Flag mode set to one-shot

  // initialize simulation inputs
  top->clk = 0;
  top->rst = 0;
  top->trigger = 1;

  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }
    
    top->trigger = vbdFlag(); // toggle trigger with rotary push button
    vbdBar(top->a0 & 0xFF);
    vbdCycle(simcyc);

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