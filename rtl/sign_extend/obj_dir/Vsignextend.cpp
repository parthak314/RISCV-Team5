// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vsignextend.h"
#include "Vsignextend__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vsignextend::Vsignextend(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vsignextend__Syms(contextp(), _vcname__, this)}
    , ImmSrc{vlSymsp->TOP.ImmSrc}
    , instr{vlSymsp->TOP.instr}
    , ImmOp{vlSymsp->TOP.ImmOp}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vsignextend::Vsignextend(const char* _vcname__)
    : Vsignextend(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vsignextend::~Vsignextend() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void Vsignextend___024root___eval_initial(Vsignextend___024root* vlSelf);
void Vsignextend___024root___eval_settle(Vsignextend___024root* vlSelf);
void Vsignextend___024root___eval(Vsignextend___024root* vlSelf);
#ifdef VL_DEBUG
void Vsignextend___024root___eval_debug_assertions(Vsignextend___024root* vlSelf);
#endif  // VL_DEBUG
void Vsignextend___024root___final(Vsignextend___024root* vlSelf);

static void _eval_initial_loop(Vsignextend__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    Vsignextend___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    vlSymsp->__Vm_activity = true;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        Vsignextend___024root___eval_settle(&(vlSymsp->TOP));
        Vsignextend___024root___eval(&(vlSymsp->TOP));
    } while (0);
}

void Vsignextend::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vsignextend::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vsignextend___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    vlSymsp->__Vm_activity = true;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        Vsignextend___024root___eval(&(vlSymsp->TOP));
    } while (0);
    // Evaluate cleanup
}

//============================================================
// Utilities

const char* Vsignextend::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vsignextend::final() {
    Vsignextend___024root___final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vsignextend::hierName() const { return vlSymsp->name(); }
const char* Vsignextend::modelName() const { return "Vsignextend"; }
unsigned Vsignextend::threads() const { return 1; }
std::unique_ptr<VerilatedTraceConfig> Vsignextend::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vsignextend___024root__trace_init_top(Vsignextend___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vsignextend___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsignextend___024root*>(voidSelf);
    Vsignextend__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    Vsignextend___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void Vsignextend___024root__trace_register(Vsignextend___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vsignextend::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vsignextend___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
