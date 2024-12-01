// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vreg_file.h for the primary calling header

#include "verilated.h"

#include "Vreg_file__Syms.h"
#include "Vreg_file___024root.h"

void Vreg_file___024root___ctor_var_reset(Vreg_file___024root* vlSelf);

Vreg_file___024root::Vreg_file___024root(Vreg_file__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vreg_file___024root___ctor_var_reset(this);
}

void Vreg_file___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vreg_file___024root::~Vreg_file___024root() {
}
