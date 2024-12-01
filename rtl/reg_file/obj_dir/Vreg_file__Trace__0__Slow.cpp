// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vreg_file__Syms.h"


VL_ATTR_COLD void Vreg_file___024root__trace_init_sub__TOP__0(Vreg_file___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+34,"clk", false,-1);
    tracep->declBit(c+35,"reset", false,-1);
    tracep->declBit(c+36,"write_enable", false,-1);
    tracep->declBus(c+37,"read_addr1", false,-1, 4,0);
    tracep->declBus(c+38,"read_addr2", false,-1, 4,0);
    tracep->declBus(c+39,"write_addr", false,-1, 4,0);
    tracep->declBus(c+40,"write_data", false,-1, 31,0);
    tracep->declBus(c+41,"read_data1", false,-1, 31,0);
    tracep->declBus(c+42,"read_data2", false,-1, 31,0);
    tracep->pushNamePrefix("reg_file ");
    tracep->declBus(c+43,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBus(c+44,"ADDR_WIDTH", false,-1, 31,0);
    tracep->declBit(c+34,"clk", false,-1);
    tracep->declBit(c+35,"reset", false,-1);
    tracep->declBit(c+36,"write_enable", false,-1);
    tracep->declBus(c+37,"read_addr1", false,-1, 4,0);
    tracep->declBus(c+38,"read_addr2", false,-1, 4,0);
    tracep->declBus(c+39,"write_addr", false,-1, 4,0);
    tracep->declBus(c+40,"write_data", false,-1, 31,0);
    tracep->declBus(c+41,"read_data1", false,-1, 31,0);
    tracep->declBus(c+42,"read_data2", false,-1, 31,0);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+1+i*1,"registers", true,(i+0), 31,0);
    }
    tracep->pushNamePrefix("unnamedblk1 ");
    tracep->declBus(c+33,"i", false,-1, 31,0);
    tracep->popNamePrefix(2);
}

VL_ATTR_COLD void Vreg_file___024root__trace_init_top(Vreg_file___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root__trace_init_top\n"); );
    // Body
    Vreg_file___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vreg_file___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vreg_file___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vreg_file___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vreg_file___024root__trace_register(Vreg_file___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vreg_file___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vreg_file___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vreg_file___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vreg_file___024root__trace_full_sub_0(Vreg_file___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vreg_file___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root__trace_full_top_0\n"); );
    // Init
    Vreg_file___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vreg_file___024root*>(voidSelf);
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vreg_file___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vreg_file___024root__trace_full_sub_0(Vreg_file___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreg_file___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->reg_file__DOT__registers[0]),32);
    bufp->fullIData(oldp+2,(vlSelf->reg_file__DOT__registers[1]),32);
    bufp->fullIData(oldp+3,(vlSelf->reg_file__DOT__registers[2]),32);
    bufp->fullIData(oldp+4,(vlSelf->reg_file__DOT__registers[3]),32);
    bufp->fullIData(oldp+5,(vlSelf->reg_file__DOT__registers[4]),32);
    bufp->fullIData(oldp+6,(vlSelf->reg_file__DOT__registers[5]),32);
    bufp->fullIData(oldp+7,(vlSelf->reg_file__DOT__registers[6]),32);
    bufp->fullIData(oldp+8,(vlSelf->reg_file__DOT__registers[7]),32);
    bufp->fullIData(oldp+9,(vlSelf->reg_file__DOT__registers[8]),32);
    bufp->fullIData(oldp+10,(vlSelf->reg_file__DOT__registers[9]),32);
    bufp->fullIData(oldp+11,(vlSelf->reg_file__DOT__registers[10]),32);
    bufp->fullIData(oldp+12,(vlSelf->reg_file__DOT__registers[11]),32);
    bufp->fullIData(oldp+13,(vlSelf->reg_file__DOT__registers[12]),32);
    bufp->fullIData(oldp+14,(vlSelf->reg_file__DOT__registers[13]),32);
    bufp->fullIData(oldp+15,(vlSelf->reg_file__DOT__registers[14]),32);
    bufp->fullIData(oldp+16,(vlSelf->reg_file__DOT__registers[15]),32);
    bufp->fullIData(oldp+17,(vlSelf->reg_file__DOT__registers[16]),32);
    bufp->fullIData(oldp+18,(vlSelf->reg_file__DOT__registers[17]),32);
    bufp->fullIData(oldp+19,(vlSelf->reg_file__DOT__registers[18]),32);
    bufp->fullIData(oldp+20,(vlSelf->reg_file__DOT__registers[19]),32);
    bufp->fullIData(oldp+21,(vlSelf->reg_file__DOT__registers[20]),32);
    bufp->fullIData(oldp+22,(vlSelf->reg_file__DOT__registers[21]),32);
    bufp->fullIData(oldp+23,(vlSelf->reg_file__DOT__registers[22]),32);
    bufp->fullIData(oldp+24,(vlSelf->reg_file__DOT__registers[23]),32);
    bufp->fullIData(oldp+25,(vlSelf->reg_file__DOT__registers[24]),32);
    bufp->fullIData(oldp+26,(vlSelf->reg_file__DOT__registers[25]),32);
    bufp->fullIData(oldp+27,(vlSelf->reg_file__DOT__registers[26]),32);
    bufp->fullIData(oldp+28,(vlSelf->reg_file__DOT__registers[27]),32);
    bufp->fullIData(oldp+29,(vlSelf->reg_file__DOT__registers[28]),32);
    bufp->fullIData(oldp+30,(vlSelf->reg_file__DOT__registers[29]),32);
    bufp->fullIData(oldp+31,(vlSelf->reg_file__DOT__registers[30]),32);
    bufp->fullIData(oldp+32,(vlSelf->reg_file__DOT__registers[31]),32);
    bufp->fullIData(oldp+33,(vlSelf->reg_file__DOT__unnamedblk1__DOT__i),32);
    bufp->fullBit(oldp+34,(vlSelf->clk));
    bufp->fullBit(oldp+35,(vlSelf->reset));
    bufp->fullBit(oldp+36,(vlSelf->write_enable));
    bufp->fullCData(oldp+37,(vlSelf->read_addr1),5);
    bufp->fullCData(oldp+38,(vlSelf->read_addr2),5);
    bufp->fullCData(oldp+39,(vlSelf->write_addr),5);
    bufp->fullIData(oldp+40,(vlSelf->write_data),32);
    bufp->fullIData(oldp+41,(vlSelf->read_data1),32);
    bufp->fullIData(oldp+42,(vlSelf->read_data2),32);
    bufp->fullIData(oldp+43,(0x20U),32);
    bufp->fullIData(oldp+44,(5U),32);
}
