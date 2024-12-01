// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcontrol.h for the primary calling header

#include "verilated.h"

#include "Vcontrol___024root.h"

VL_INLINE_OPT void Vcontrol___024root___combo__TOP__0(Vcontrol___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcontrol__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcontrol___024root___combo__TOP__0\n"); );
    // Body
    vlSelf->RegWrite = 0U;
    vlSelf->ImmSrc = 0U;
    vlSelf->MemWrite = 0U;
    vlSelf->ResultSrc = 0U;
    vlSelf->ALUSrc = 0U;
    vlSelf->PCsrc = 0U;
    vlSelf->ALUcontrol = 0U;
    if ((0x40U & (IData)(vlSelf->op))) {
        if ((0x20U & (IData)(vlSelf->op))) {
            if ((1U & (~ ((IData)(vlSelf->op) >> 4U)))) {
                if ((8U & (IData)(vlSelf->op))) {
                    if ((4U & (IData)(vlSelf->op))) {
                        if ((2U & (IData)(vlSelf->op))) {
                            if ((1U & (IData)(vlSelf->op))) {
                                vlSelf->RegWrite = 1U;
                                vlSelf->ImmSrc = 3U;
                                vlSelf->MemWrite = 0U;
                                vlSelf->ResultSrc = 2U;
                                vlSelf->PCsrc = 1U;
                            }
                        }
                    }
                } else if ((4U & (IData)(vlSelf->op))) {
                    if ((2U & (IData)(vlSelf->op))) {
                        if ((1U & (IData)(vlSelf->op))) {
                            vlSelf->RegWrite = 1U;
                            vlSelf->ImmSrc = 0U;
                            vlSelf->MemWrite = 0U;
                            vlSelf->ResultSrc = 2U;
                            vlSelf->PCsrc = 1U;
                        }
                    }
                } else if ((2U & (IData)(vlSelf->op))) {
                    if ((1U & (IData)(vlSelf->op))) {
                        vlSelf->RegWrite = 0U;
                        vlSelf->ImmSrc = 2U;
                        vlSelf->MemWrite = 0U;
                        vlSelf->PCsrc = (1U & ((4U 
                                                & (IData)(vlSelf->funct3))
                                                ? (
                                                   (2U 
                                                    & (IData)(vlSelf->funct3))
                                                    ? 
                                                   ((1U 
                                                     & (IData)(vlSelf->funct3))
                                                     ? 
                                                    (~ (IData)(vlSelf->negative))
                                                     : (IData)(vlSelf->negative))
                                                    : 
                                                   ((1U 
                                                     & (IData)(vlSelf->funct3))
                                                     ? 
                                                    (~ (IData)(vlSelf->negative))
                                                     : (IData)(vlSelf->negative)))
                                                : (
                                                   (~ 
                                                    ((IData)(vlSelf->funct3) 
                                                     >> 1U)) 
                                                   & ((1U 
                                                       & (IData)(vlSelf->funct3))
                                                       ? 
                                                      (~ (IData)(vlSelf->zero))
                                                       : (IData)(vlSelf->zero)))));
                    }
                }
                if ((1U & (~ ((IData)(vlSelf->op) >> 3U)))) {
                    if ((4U & (IData)(vlSelf->op))) {
                        if ((2U & (IData)(vlSelf->op))) {
                            if ((1U & (IData)(vlSelf->op))) {
                                vlSelf->ALUSrc = 1U;
                                vlSelf->ALUcontrol = 0U;
                            }
                        }
                    } else if ((2U & (IData)(vlSelf->op))) {
                        if ((1U & (IData)(vlSelf->op))) {
                            vlSelf->ALUSrc = 0U;
                            vlSelf->ALUcontrol = 1U;
                        }
                    }
                }
            }
        }
    } else if ((0x20U & (IData)(vlSelf->op))) {
        if ((0x10U & (IData)(vlSelf->op))) {
            if ((1U & (~ ((IData)(vlSelf->op) >> 3U)))) {
                if ((4U & (IData)(vlSelf->op))) {
                    if ((2U & (IData)(vlSelf->op))) {
                        if ((1U & (IData)(vlSelf->op))) {
                            vlSelf->RegWrite = 1U;
                            vlSelf->ImmSrc = 4U;
                            vlSelf->MemWrite = 0U;
                            vlSelf->ResultSrc = 3U;
                            vlSelf->PCsrc = 0U;
                        }
                    }
                } else if ((2U & (IData)(vlSelf->op))) {
                    if ((1U & (IData)(vlSelf->op))) {
                        vlSelf->RegWrite = 1U;
                        vlSelf->MemWrite = 0U;
                        vlSelf->ResultSrc = 0U;
                        vlSelf->PCsrc = 0U;
                    }
                }
                if ((1U & (~ ((IData)(vlSelf->op) >> 2U)))) {
                    if ((2U & (IData)(vlSelf->op))) {
                        if ((1U & (IData)(vlSelf->op))) {
                            vlSelf->ALUSrc = 0U;
                            vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_7 
                                = vlSelf->funct7;
                            vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3 
                                = vlSelf->funct3;
                            vlSelf->__Vtask_control__DOT__get_ALU_control__0__op_code 
                                = vlSelf->op;
                            vlSelf->__Vtask_control__DOT__get_ALU_control__0__ALU_control 
                                = ((4U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3))
                                    ? ((2U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3))
                                        ? ((1U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3))
                                            ? 2U : 3U)
                                        : ((1U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3))
                                            ? ((IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_7)
                                                ? 6U
                                                : 7U)
                                            : 4U)) : 
                                   ((2U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3))
                                     ? ((1U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3))
                                         ? 9U : 8U)
                                     : ((1U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_3))
                                         ? 5U : ((0x13U 
                                                  == (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__op_code))
                                                  ? 0U
                                                  : 
                                                 ((IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__0__funct_7)
                                                   ? 1U
                                                   : 0U)))));
                            vlSelf->ALUcontrol = vlSelf->__Vtask_control__DOT__get_ALU_control__0__ALU_control;
                        }
                    }
                }
            }
        } else if ((1U & (~ ((IData)(vlSelf->op) >> 3U)))) {
            if ((1U & (~ ((IData)(vlSelf->op) >> 2U)))) {
                if ((2U & (IData)(vlSelf->op))) {
                    if ((1U & (IData)(vlSelf->op))) {
                        vlSelf->RegWrite = 0U;
                        vlSelf->ImmSrc = 1U;
                        vlSelf->MemWrite = 1U;
                        vlSelf->ALUSrc = 1U;
                        vlSelf->PCsrc = 0U;
                        vlSelf->ALUcontrol = 0U;
                    }
                }
            }
        }
    } else if ((0x10U & (IData)(vlSelf->op))) {
        if ((1U & (~ ((IData)(vlSelf->op) >> 3U)))) {
            if ((4U & (IData)(vlSelf->op))) {
                if ((2U & (IData)(vlSelf->op))) {
                    if ((1U & (IData)(vlSelf->op))) {
                        vlSelf->RegWrite = 1U;
                        vlSelf->ImmSrc = 4U;
                        vlSelf->MemWrite = 0U;
                        vlSelf->ResultSrc = 0U;
                        vlSelf->ALUSrc = 1U;
                        vlSelf->PCsrc = 0U;
                        vlSelf->ALUcontrol = 0U;
                    }
                }
            } else if ((2U & (IData)(vlSelf->op))) {
                if ((1U & (IData)(vlSelf->op))) {
                    vlSelf->RegWrite = 1U;
                    vlSelf->ImmSrc = 0U;
                    vlSelf->MemWrite = 0U;
                    vlSelf->ResultSrc = 0U;
                    vlSelf->ALUSrc = 1U;
                    vlSelf->PCsrc = 0U;
                    vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_7 
                        = vlSelf->funct7;
                    vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3 
                        = vlSelf->funct3;
                    vlSelf->__Vtask_control__DOT__get_ALU_control__1__op_code 
                        = vlSelf->op;
                    vlSelf->__Vtask_control__DOT__get_ALU_control__1__ALU_control 
                        = ((4U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3))
                            ? ((2U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3))
                                ? ((1U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3))
                                    ? 2U : 3U) : ((1U 
                                                   & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3))
                                                   ? 
                                                  ((IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_7)
                                                    ? 6U
                                                    : 7U)
                                                   : 4U))
                            : ((2U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3))
                                ? ((1U & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3))
                                    ? 9U : 8U) : ((1U 
                                                   & (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_3))
                                                   ? 5U
                                                   : 
                                                  ((0x13U 
                                                    == (IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__op_code))
                                                    ? 0U
                                                    : 
                                                   ((IData)(vlSelf->__Vtask_control__DOT__get_ALU_control__1__funct_7)
                                                     ? 1U
                                                     : 0U)))));
                    vlSelf->ALUcontrol = vlSelf->__Vtask_control__DOT__get_ALU_control__1__ALU_control;
                }
            }
        }
    } else if ((1U & (~ ((IData)(vlSelf->op) >> 3U)))) {
        if ((1U & (~ ((IData)(vlSelf->op) >> 2U)))) {
            if ((2U & (IData)(vlSelf->op))) {
                if ((1U & (IData)(vlSelf->op))) {
                    vlSelf->RegWrite = 1U;
                    vlSelf->ImmSrc = 0U;
                    vlSelf->MemWrite = 0U;
                    vlSelf->ResultSrc = 1U;
                    vlSelf->ALUSrc = 1U;
                    vlSelf->PCsrc = 0U;
                    vlSelf->ALUcontrol = 0U;
                }
            }
        }
    }
}

void Vcontrol___024root___eval(Vcontrol___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcontrol__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcontrol___024root___eval\n"); );
    // Body
    Vcontrol___024root___combo__TOP__0(vlSelf);
}

#ifdef VL_DEBUG
void Vcontrol___024root___eval_debug_assertions(Vcontrol___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcontrol__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcontrol___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->op & 0x80U))) {
        Verilated::overWidthError("op");}
    if (VL_UNLIKELY((vlSelf->funct3 & 0xf8U))) {
        Verilated::overWidthError("funct3");}
    if (VL_UNLIKELY((vlSelf->funct7 & 0xfeU))) {
        Verilated::overWidthError("funct7");}
    if (VL_UNLIKELY((vlSelf->zero & 0xfeU))) {
        Verilated::overWidthError("zero");}
    if (VL_UNLIKELY((vlSelf->negative & 0xfeU))) {
        Verilated::overWidthError("negative");}
}
#endif  // VL_DEBUG
