// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vreg_file.h for the primary calling header

#include "verilated.h"

#include "Vreg_file___024root.h"

VL_ATTR_COLD void Vreg_file___024root___eval_initial(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
    vlSelf->__Vclklast__TOP__reset = vlSelf->reset;
}

void Vreg_file___024root___combo__TOP__0(Vreg_file___024root* vlSelf);

VL_ATTR_COLD void Vreg_file___024root___eval_settle(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___eval_settle\n"); );
    // Body
    Vreg_file___024root___combo__TOP__0(vlSelf);
}

VL_ATTR_COLD void Vreg_file___024root___final(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___final\n"); );
}

VL_ATTR_COLD void Vreg_file___024root___ctor_var_reset(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->write_enable = VL_RAND_RESET_I(1);
    vlSelf->read_addr1 = VL_RAND_RESET_I(5);
    vlSelf->read_addr2 = VL_RAND_RESET_I(5);
    vlSelf->write_addr = VL_RAND_RESET_I(5);
    vlSelf->write_data = VL_RAND_RESET_I(32);
    vlSelf->read_data1 = VL_RAND_RESET_I(32);
    vlSelf->read_data2 = VL_RAND_RESET_I(32);
    for (int __Vi0=0; __Vi0<32; ++__Vi0) {
        vlSelf->reg_file__DOT__registers[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->reg_file__DOT__unnamedblk1__DOT__i = 0;
    for (int __Vi0=0; __Vi0<2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }
}
