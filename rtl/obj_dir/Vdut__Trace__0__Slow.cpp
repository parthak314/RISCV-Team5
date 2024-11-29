// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdut__Syms.h"


VL_ATTR_COLD void Vdut___024root__trace_init_sub__TOP__0(Vdut___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBus(c+33,"a", false,-1, 31,0);
    tracep->declBus(c+34,"wd", false,-1, 31,0);
    tracep->declBit(c+35,"clk", false,-1);
    tracep->declBit(c+36,"we", false,-1);
    tracep->declBus(c+37,"rd", false,-1, 31,0);
    tracep->pushNamePrefix("datamem ");
    tracep->declBus(c+38,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBus(c+33,"a", false,-1, 31,0);
    tracep->declBus(c+34,"wd", false,-1, 31,0);
    tracep->declBit(c+35,"clk", false,-1);
    tracep->declBit(c+36,"we", false,-1);
    tracep->declBus(c+37,"rd", false,-1, 31,0);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+1+i*1,"ram_array", true,(i+0), 31,0);
    }
    tracep->popNamePrefix(1);
}

VL_ATTR_COLD void Vdut___024root__trace_init_top(Vdut___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_init_top\n"); );
    // Body
    Vdut___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vdut___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vdut___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vdut___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vdut___024root__trace_register(Vdut___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vdut___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vdut___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vdut___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vdut___024root__trace_full_sub_0(Vdut___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vdut___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_full_top_0\n"); );
    // Init
    Vdut___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdut___024root*>(voidSelf);
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vdut___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vdut___024root__trace_full_sub_0(Vdut___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vdut__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdut___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->datamem__DOT__ram_array[0]),32);
    bufp->fullIData(oldp+2,(vlSelf->datamem__DOT__ram_array[1]),32);
    bufp->fullIData(oldp+3,(vlSelf->datamem__DOT__ram_array[2]),32);
    bufp->fullIData(oldp+4,(vlSelf->datamem__DOT__ram_array[3]),32);
    bufp->fullIData(oldp+5,(vlSelf->datamem__DOT__ram_array[4]),32);
    bufp->fullIData(oldp+6,(vlSelf->datamem__DOT__ram_array[5]),32);
    bufp->fullIData(oldp+7,(vlSelf->datamem__DOT__ram_array[6]),32);
    bufp->fullIData(oldp+8,(vlSelf->datamem__DOT__ram_array[7]),32);
    bufp->fullIData(oldp+9,(vlSelf->datamem__DOT__ram_array[8]),32);
    bufp->fullIData(oldp+10,(vlSelf->datamem__DOT__ram_array[9]),32);
    bufp->fullIData(oldp+11,(vlSelf->datamem__DOT__ram_array[10]),32);
    bufp->fullIData(oldp+12,(vlSelf->datamem__DOT__ram_array[11]),32);
    bufp->fullIData(oldp+13,(vlSelf->datamem__DOT__ram_array[12]),32);
    bufp->fullIData(oldp+14,(vlSelf->datamem__DOT__ram_array[13]),32);
    bufp->fullIData(oldp+15,(vlSelf->datamem__DOT__ram_array[14]),32);
    bufp->fullIData(oldp+16,(vlSelf->datamem__DOT__ram_array[15]),32);
    bufp->fullIData(oldp+17,(vlSelf->datamem__DOT__ram_array[16]),32);
    bufp->fullIData(oldp+18,(vlSelf->datamem__DOT__ram_array[17]),32);
    bufp->fullIData(oldp+19,(vlSelf->datamem__DOT__ram_array[18]),32);
    bufp->fullIData(oldp+20,(vlSelf->datamem__DOT__ram_array[19]),32);
    bufp->fullIData(oldp+21,(vlSelf->datamem__DOT__ram_array[20]),32);
    bufp->fullIData(oldp+22,(vlSelf->datamem__DOT__ram_array[21]),32);
    bufp->fullIData(oldp+23,(vlSelf->datamem__DOT__ram_array[22]),32);
    bufp->fullIData(oldp+24,(vlSelf->datamem__DOT__ram_array[23]),32);
    bufp->fullIData(oldp+25,(vlSelf->datamem__DOT__ram_array[24]),32);
    bufp->fullIData(oldp+26,(vlSelf->datamem__DOT__ram_array[25]),32);
    bufp->fullIData(oldp+27,(vlSelf->datamem__DOT__ram_array[26]),32);
    bufp->fullIData(oldp+28,(vlSelf->datamem__DOT__ram_array[27]),32);
    bufp->fullIData(oldp+29,(vlSelf->datamem__DOT__ram_array[28]),32);
    bufp->fullIData(oldp+30,(vlSelf->datamem__DOT__ram_array[29]),32);
    bufp->fullIData(oldp+31,(vlSelf->datamem__DOT__ram_array[30]),32);
    bufp->fullIData(oldp+32,(vlSelf->datamem__DOT__ram_array[31]),32);
    bufp->fullIData(oldp+33,(vlSelf->a),32);
    bufp->fullIData(oldp+34,(vlSelf->wd),32);
    bufp->fullBit(oldp+35,(vlSelf->clk));
    bufp->fullBit(oldp+36,(vlSelf->we));
    bufp->fullIData(oldp+37,(vlSelf->rd),32);
    bufp->fullIData(oldp+38,(0x20U),32);
}
