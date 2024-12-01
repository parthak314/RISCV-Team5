// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcontrol.h for the primary calling header

#include "verilated.h"

#include "Vcontrol__Syms.h"
#include "Vcontrol___024root.h"

void Vcontrol___024root___ctor_var_reset(Vcontrol___024root* vlSelf);

Vcontrol___024root::Vcontrol___024root(Vcontrol__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vcontrol___024root___ctor_var_reset(this);
}

void Vcontrol___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vcontrol___024root::~Vcontrol___024root() {
}
