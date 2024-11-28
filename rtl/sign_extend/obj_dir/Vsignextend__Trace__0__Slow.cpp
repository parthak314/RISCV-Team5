// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vsignextend__Syms.h"


VL_ATTR_COLD void Vsignextend___024root__trace_init_sub__TOP__0(Vsignextend___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBus(c+1,"instr", false,-1, 31,0);
    tracep->declBus(c+2,"ImmSrc", false,-1, 2,0);
    tracep->declBus(c+3,"ImmOp", false,-1, 31,0);
    tracep->pushNamePrefix("signextend ");
    tracep->declBus(c+4,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBus(c+1,"instr", false,-1, 31,0);
    tracep->declBus(c+2,"ImmSrc", false,-1, 2,0);
    tracep->declBus(c+3,"ImmOp", false,-1, 31,0);
    tracep->popNamePrefix(1);
}

VL_ATTR_COLD void Vsignextend___024root__trace_init_top(Vsignextend___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root__trace_init_top\n"); );
    // Body
    Vsignextend___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vsignextend___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsignextend___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsignextend___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vsignextend___024root__trace_register(Vsignextend___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vsignextend___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vsignextend___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vsignextend___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vsignextend___024root__trace_full_sub_0(Vsignextend___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vsignextend___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root__trace_full_top_0\n"); );
    // Init
    Vsignextend___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsignextend___024root*>(voidSelf);
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vsignextend___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vsignextend___024root__trace_full_sub_0(Vsignextend___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsignextend___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->instr),32);
    bufp->fullCData(oldp+2,(vlSelf->ImmSrc),3);
    bufp->fullIData(oldp+3,(vlSelf->ImmOp),32);
    bufp->fullIData(oldp+4,(0x20U),32);
}
