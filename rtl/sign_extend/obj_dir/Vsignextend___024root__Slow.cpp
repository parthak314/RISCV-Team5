// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsignextend.h for the primary calling header

#include "verilated.h"

#include "Vsignextend__Syms.h"
#include "Vsignextend___024root.h"

void Vsignextend___024root___ctor_var_reset(Vsignextend___024root* vlSelf);

Vsignextend___024root::Vsignextend___024root(Vsignextend__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vsignextend___024root___ctor_var_reset(this);
}

void Vsignextend___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vsignextend___024root::~Vsignextend___024root() {
}
