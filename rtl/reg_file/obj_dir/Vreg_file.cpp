// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vreg_file.h"
#include "Vreg_file__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vreg_file::Vreg_file(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vreg_file__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , reset{vlSymsp->TOP.reset}
    , write_enable{vlSymsp->TOP.write_enable}
    , read_addr1{vlSymsp->TOP.read_addr1}
    , read_addr2{vlSymsp->TOP.read_addr2}
    , write_addr{vlSymsp->TOP.write_addr}
    , write_data{vlSymsp->TOP.write_data}
    , read_data1{vlSymsp->TOP.read_data1}
    , read_data2{vlSymsp->TOP.read_data2}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vreg_file::Vreg_file(const char* _vcname__)
    : Vreg_file(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vreg_file::~Vreg_file() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void Vreg_file___024root___eval_initial(Vreg_file___024root* vlSelf);
void Vreg_file___024root___eval_settle(Vreg_file___024root* vlSelf);
void Vreg_file___024root___eval(Vreg_file___024root* vlSelf);
#ifdef VL_DEBUG
void Vreg_file___024root___eval_debug_assertions(Vreg_file___024root* vlSelf);
#endif  // VL_DEBUG
void Vreg_file___024root___final(Vreg_file___024root* vlSelf);

static void _eval_initial_loop(Vreg_file__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    Vreg_file___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    vlSymsp->__Vm_activity = true;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        Vreg_file___024root___eval_settle(&(vlSymsp->TOP));
        Vreg_file___024root___eval(&(vlSymsp->TOP));
    } while (0);
}

void Vreg_file::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vreg_file::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vreg_file___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    vlSymsp->__Vm_activity = true;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        Vreg_file___024root___eval(&(vlSymsp->TOP));
    } while (0);
    // Evaluate cleanup
}

//============================================================
// Utilities

const char* Vreg_file::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vreg_file::final() {
    Vreg_file___024root___final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vreg_file::hierName() const { return vlSymsp->name(); }
const char* Vreg_file::modelName() const { return "Vreg_file"; }
unsigned Vreg_file::threads() const { return 1; }
std::unique_ptr<VerilatedTraceConfig> Vreg_file::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vreg_file___024root__trace_init_top(Vreg_file___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vreg_file___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vreg_file___024root*>(voidSelf);
    Vreg_file__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    Vreg_file___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void Vreg_file___024root__trace_register(Vreg_file___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vreg_file::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vreg_file___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
