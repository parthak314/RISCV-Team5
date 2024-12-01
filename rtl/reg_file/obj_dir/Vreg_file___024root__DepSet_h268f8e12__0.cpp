// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vreg_file.h for the primary calling header

#include "verilated.h"

#include "Vreg_file___024root.h"

VL_INLINE_OPT void Vreg_file___024root___sequent__TOP__0(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___sequent__TOP__0\n"); );
    // Init
    CData/*0:0*/ __Vdlyvset__reg_file__DOT__registers__v0;
    CData/*4:0*/ __Vdlyvdim0__reg_file__DOT__registers__v32;
    IData/*31:0*/ __Vdlyvval__reg_file__DOT__registers__v32;
    CData/*0:0*/ __Vdlyvset__reg_file__DOT__registers__v32;
    // Body
    __Vdlyvset__reg_file__DOT__registers__v0 = 0U;
    __Vdlyvset__reg_file__DOT__registers__v32 = 0U;
    if (vlSelf->reset) {
        vlSelf->reg_file__DOT__unnamedblk1__DOT__i = 0x20U;
        __Vdlyvset__reg_file__DOT__registers__v0 = 1U;
    } else if (((IData)(vlSelf->write_enable) & (0U 
                                                 != (IData)(vlSelf->write_addr)))) {
        __Vdlyvval__reg_file__DOT__registers__v32 = vlSelf->write_data;
        __Vdlyvset__reg_file__DOT__registers__v32 = 1U;
        __Vdlyvdim0__reg_file__DOT__registers__v32 
            = vlSelf->write_addr;
    }
    if (__Vdlyvset__reg_file__DOT__registers__v0) {
        vlSelf->reg_file__DOT__registers[0U] = 0U;
        vlSelf->reg_file__DOT__registers[1U] = 0U;
        vlSelf->reg_file__DOT__registers[2U] = 0U;
        vlSelf->reg_file__DOT__registers[3U] = 0U;
        vlSelf->reg_file__DOT__registers[4U] = 0U;
        vlSelf->reg_file__DOT__registers[5U] = 0U;
        vlSelf->reg_file__DOT__registers[6U] = 0U;
        vlSelf->reg_file__DOT__registers[7U] = 0U;
        vlSelf->reg_file__DOT__registers[8U] = 0U;
        vlSelf->reg_file__DOT__registers[9U] = 0U;
        vlSelf->reg_file__DOT__registers[0xaU] = 0U;
        vlSelf->reg_file__DOT__registers[0xbU] = 0U;
        vlSelf->reg_file__DOT__registers[0xcU] = 0U;
        vlSelf->reg_file__DOT__registers[0xdU] = 0U;
        vlSelf->reg_file__DOT__registers[0xeU] = 0U;
        vlSelf->reg_file__DOT__registers[0xfU] = 0U;
        vlSelf->reg_file__DOT__registers[0x10U] = 0U;
        vlSelf->reg_file__DOT__registers[0x11U] = 0U;
        vlSelf->reg_file__DOT__registers[0x12U] = 0U;
        vlSelf->reg_file__DOT__registers[0x13U] = 0U;
        vlSelf->reg_file__DOT__registers[0x14U] = 0U;
        vlSelf->reg_file__DOT__registers[0x15U] = 0U;
        vlSelf->reg_file__DOT__registers[0x16U] = 0U;
        vlSelf->reg_file__DOT__registers[0x17U] = 0U;
        vlSelf->reg_file__DOT__registers[0x18U] = 0U;
        vlSelf->reg_file__DOT__registers[0x19U] = 0U;
        vlSelf->reg_file__DOT__registers[0x1aU] = 0U;
        vlSelf->reg_file__DOT__registers[0x1bU] = 0U;
        vlSelf->reg_file__DOT__registers[0x1cU] = 0U;
        vlSelf->reg_file__DOT__registers[0x1dU] = 0U;
        vlSelf->reg_file__DOT__registers[0x1eU] = 0U;
        vlSelf->reg_file__DOT__registers[0x1fU] = 0U;
    }
    if (__Vdlyvset__reg_file__DOT__registers__v32) {
        vlSelf->reg_file__DOT__registers[__Vdlyvdim0__reg_file__DOT__registers__v32] 
            = __Vdlyvval__reg_file__DOT__registers__v32;
    }
}

VL_INLINE_OPT void Vreg_file___024root___combo__TOP__0(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___combo__TOP__0\n"); );
    // Body
    vlSelf->read_data1 = vlSelf->reg_file__DOT__registers
        [vlSelf->read_addr1];
    vlSelf->read_data2 = vlSelf->reg_file__DOT__registers
        [vlSelf->read_addr2];
}

void Vreg_file___024root___eval(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___eval\n"); );
    // Body
    if ((((IData)(vlSelf->clk) & (~ (IData)(vlSelf->__Vclklast__TOP__clk))) 
         | ((IData)(vlSelf->reset) & (~ (IData)(vlSelf->__Vclklast__TOP__reset))))) {
        Vreg_file___024root___sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
    Vreg_file___024root___combo__TOP__0(vlSelf);
    // Final
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
    vlSelf->__Vclklast__TOP__reset = vlSelf->reset;
}

#ifdef VL_DEBUG
void Vreg_file___024root___eval_debug_assertions(Vreg_file___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((vlSelf->write_enable & 0xfeU))) {
        Verilated::overWidthError("write_enable");}
    if (VL_UNLIKELY((vlSelf->read_addr1 & 0xe0U))) {
        Verilated::overWidthError("read_addr1");}
    if (VL_UNLIKELY((vlSelf->read_addr2 & 0xe0U))) {
        Verilated::overWidthError("read_addr2");}
    if (VL_UNLIKELY((vlSelf->write_addr & 0xe0U))) {
        Verilated::overWidthError("write_addr");}
}
#endif  // VL_DEBUG
