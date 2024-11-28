// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsignextend.h for the primary calling header

#include "verilated.h"

#include "Vsignextend___024root.h"

VL_ATTR_COLD void Vsignextend___024root___eval_initial(Vsignextend___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root___eval_initial\n"); );
}

void Vsignextend___024root___combo__TOP__0(Vsignextend___024root* vlSelf);

VL_ATTR_COLD void Vsignextend___024root___eval_settle(Vsignextend___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root___eval_settle\n"); );
    // Body
    Vsignextend___024root___combo__TOP__0(vlSelf);
}

VL_ATTR_COLD void Vsignextend___024root___final(Vsignextend___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root___final\n"); );
}

VL_ATTR_COLD void Vsignextend___024root___ctor_var_reset(Vsignextend___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->instr = VL_RAND_RESET_I(32);
    vlSelf->ImmSrc = VL_RAND_RESET_I(3);
    vlSelf->ImmOp = VL_RAND_RESET_I(32);
}
