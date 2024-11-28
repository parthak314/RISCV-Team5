// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsignextend.h for the primary calling header

#include "verilated.h"

#include "Vsignextend___024root.h"

VL_INLINE_OPT void Vsignextend___024root___combo__TOP__0(Vsignextend___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root___combo__TOP__0\n"); );
    // Body
    vlSelf->ImmOp = ((4U & (IData)(vlSelf->ImmSrc))
                      ? ((2U & (IData)(vlSelf->ImmSrc))
                          ? (((- (IData)((vlSelf->instr 
                                          >> 0x1fU))) 
                              << 0xcU) | (vlSelf->instr 
                                          >> 0x14U))
                          : ((1U & (IData)(vlSelf->ImmSrc))
                              ? (((- (IData)((vlSelf->instr 
                                              >> 0x1fU))) 
                                  << 0xcU) | (vlSelf->instr 
                                              >> 0x14U))
                              : (((- (IData)((vlSelf->instr 
                                              >> 0x1fU))) 
                                  << 0x14U) | ((0x80000U 
                                                & (vlSelf->instr 
                                                   >> 0xcU)) 
                                               | ((0x7f800U 
                                                   & (vlSelf->instr 
                                                      >> 1U)) 
                                                  | ((0x400U 
                                                      & (vlSelf->instr 
                                                         >> 0xaU)) 
                                                     | (0x3ffU 
                                                        & (vlSelf->instr 
                                                           >> 0x15U))))))))
                      : ((2U & (IData)(vlSelf->ImmSrc))
                          ? ((1U & (IData)(vlSelf->ImmSrc))
                              ? (((- (IData)((vlSelf->instr 
                                              >> 0x1fU))) 
                                  << 0x14U) | (vlSelf->instr 
                                               >> 0xcU))
                              : (((- (IData)((vlSelf->instr 
                                              >> 0x1fU))) 
                                  << 0xcU) | ((0x800U 
                                               & (vlSelf->instr 
                                                  << 4U)) 
                                              | ((0x7e0U 
                                                  & (vlSelf->instr 
                                                     >> 0x14U)) 
                                                 | (0x1eU 
                                                    & (vlSelf->instr 
                                                       >> 7U))))))
                          : ((1U & (IData)(vlSelf->ImmSrc))
                              ? (((- (IData)((vlSelf->instr 
                                              >> 0x1fU))) 
                                  << 0xcU) | ((0xfe0U 
                                               & (vlSelf->instr 
                                                  >> 0x14U)) 
                                              | (0x1fU 
                                                 & (vlSelf->instr 
                                                    >> 7U))))
                              : (((- (IData)((vlSelf->instr 
                                              >> 0x1fU))) 
                                  << 0xcU) | (vlSelf->instr 
                                              >> 0x14U)))));
}

void Vsignextend___024root___eval(Vsignextend___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root___eval\n"); );
    // Body
    Vsignextend___024root___combo__TOP__0(vlSelf);
}

#ifdef VL_DEBUG
void Vsignextend___024root___eval_debug_assertions(Vsignextend___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->ImmSrc & 0xf8U))) {
        Verilated::overWidthError("ImmSrc");}
}
#endif  // VL_DEBUG
