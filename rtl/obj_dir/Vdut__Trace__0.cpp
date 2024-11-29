// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdut__Syms.h"


void Vdut___024root__trace_chg_sub_0(Vdut___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vdut___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_chg_top_0\n"); );
    // Init
    Vdut___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdut___024root*>(voidSelf);
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vdut___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vdut___024root__trace_chg_sub_0(Vdut___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+0,(vlSelf->datamem__DOT__ram_array[0]),32);
        bufp->chgIData(oldp+1,(vlSelf->datamem__DOT__ram_array[1]),32);
        bufp->chgIData(oldp+2,(vlSelf->datamem__DOT__ram_array[2]),32);
        bufp->chgIData(oldp+3,(vlSelf->datamem__DOT__ram_array[3]),32);
        bufp->chgIData(oldp+4,(vlSelf->datamem__DOT__ram_array[4]),32);
        bufp->chgIData(oldp+5,(vlSelf->datamem__DOT__ram_array[5]),32);
        bufp->chgIData(oldp+6,(vlSelf->datamem__DOT__ram_array[6]),32);
        bufp->chgIData(oldp+7,(vlSelf->datamem__DOT__ram_array[7]),32);
        bufp->chgIData(oldp+8,(vlSelf->datamem__DOT__ram_array[8]),32);
        bufp->chgIData(oldp+9,(vlSelf->datamem__DOT__ram_array[9]),32);
        bufp->chgIData(oldp+10,(vlSelf->datamem__DOT__ram_array[10]),32);
        bufp->chgIData(oldp+11,(vlSelf->datamem__DOT__ram_array[11]),32);
        bufp->chgIData(oldp+12,(vlSelf->datamem__DOT__ram_array[12]),32);
        bufp->chgIData(oldp+13,(vlSelf->datamem__DOT__ram_array[13]),32);
        bufp->chgIData(oldp+14,(vlSelf->datamem__DOT__ram_array[14]),32);
        bufp->chgIData(oldp+15,(vlSelf->datamem__DOT__ram_array[15]),32);
        bufp->chgIData(oldp+16,(vlSelf->datamem__DOT__ram_array[16]),32);
        bufp->chgIData(oldp+17,(vlSelf->datamem__DOT__ram_array[17]),32);
        bufp->chgIData(oldp+18,(vlSelf->datamem__DOT__ram_array[18]),32);
        bufp->chgIData(oldp+19,(vlSelf->datamem__DOT__ram_array[19]),32);
        bufp->chgIData(oldp+20,(vlSelf->datamem__DOT__ram_array[20]),32);
        bufp->chgIData(oldp+21,(vlSelf->datamem__DOT__ram_array[21]),32);
        bufp->chgIData(oldp+22,(vlSelf->datamem__DOT__ram_array[22]),32);
        bufp->chgIData(oldp+23,(vlSelf->datamem__DOT__ram_array[23]),32);
        bufp->chgIData(oldp+24,(vlSelf->datamem__DOT__ram_array[24]),32);
        bufp->chgIData(oldp+25,(vlSelf->datamem__DOT__ram_array[25]),32);
        bufp->chgIData(oldp+26,(vlSelf->datamem__DOT__ram_array[26]),32);
        bufp->chgIData(oldp+27,(vlSelf->datamem__DOT__ram_array[27]),32);
        bufp->chgIData(oldp+28,(vlSelf->datamem__DOT__ram_array[28]),32);
        bufp->chgIData(oldp+29,(vlSelf->datamem__DOT__ram_array[29]),32);
        bufp->chgIData(oldp+30,(vlSelf->datamem__DOT__ram_array[30]),32);
        bufp->chgIData(oldp+31,(vlSelf->datamem__DOT__ram_array[31]),32);
    }
    bufp->chgIData(oldp+32,(vlSelf->a),32);
    bufp->chgIData(oldp+33,(vlSelf->wd),32);
    bufp->chgBit(oldp+34,(vlSelf->clk));
    bufp->chgBit(oldp+35,(vlSelf->we));
    bufp->chgIData(oldp+36,(vlSelf->rd),32);
}

void Vdut___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_cleanup\n"); );
    // Init
    Vdut___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdut___024root*>(voidSelf);
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
