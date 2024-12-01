// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vreg_file.h for the primary calling header

#ifndef VERILATED_VREG_FILE___024ROOT_H_
#define VERILATED_VREG_FILE___024ROOT_H_  // guard

#include "verilated.h"

class Vreg_file__Syms;

class Vreg_file___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    VL_IN8(write_enable,0,0);
    VL_IN8(read_addr1,4,0);
    VL_IN8(read_addr2,4,0);
    VL_IN8(write_addr,4,0);
    CData/*0:0*/ __Vclklast__TOP__clk;
    CData/*0:0*/ __Vclklast__TOP__reset;
    VL_IN(write_data,31,0);
    VL_OUT(read_data1,31,0);
    VL_OUT(read_data2,31,0);
    IData/*31:0*/ reg_file__DOT__unnamedblk1__DOT__i;
    VlUnpacked<IData/*31:0*/, 32> reg_file__DOT__registers;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;

    // INTERNAL VARIABLES
    Vreg_file__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vreg_file___024root(Vreg_file__Syms* symsp, const char* name);
    ~Vreg_file___024root();
    VL_UNCOPYABLE(Vreg_file___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
