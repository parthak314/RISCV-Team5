// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vsignextend.h for the primary calling header

#ifndef VERILATED_VSIGNEXTEND___024ROOT_H_
#define VERILATED_VSIGNEXTEND___024ROOT_H_  // guard

#include "verilated.h"

class Vsignextend__Syms;

class Vsignextend___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(ImmSrc,2,0);
    VL_IN(instr,31,0);
    VL_OUT(ImmOp,31,0);

    // INTERNAL VARIABLES
    Vsignextend__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vsignextend___024root(Vsignextend__Syms* symsp, const char* name);
    ~Vsignextend___024root();
    VL_UNCOPYABLE(Vsignextend___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
