# Personal Statement of Contributions

***Partha Khanna***

---

## Overview

- [Sign Extension Unit](#sign-extension-unit)

---

## Sign Extension Unit
*([link to section](../rtl/sign_extend))*

#### **Aims:**
- Create a module that will sign extend the immediate value.
- However, the problem we face here is that there are many types of instructions, each with a different arrangement for the immediate to be sign extended

#### **Implementation:**
Using what I created in the reduced RISC-V CPU (lab 4), I extended this to include all other instruction types. This meant using `ImmSrc` for 5 different instruction types (excluding R-type since it has no immediate).

The following structure was used for each of the instruction types:

![Instruction types](../images/Instruction%20types.png)

We can do this by using a `select case` statement which concatenates different parts of the instruction to form the immediate.
The `ImmSrc` is taken from the control unit which send the value of this as per the opcode. 

#### **Issues:**
- Considering that there are 5 instructions `I-type`, `S-type`, `B-type`, `U-type`, `J-type`, we have 2<sup>3</sup> options - therefore requiring 3 bits for `ImmSrc` as shown below.

| ImmSrc | Instruction Type |
| ------ | ---------------- |
| `000`  | Immediate        |
| `001`  | Store            |
| `010`  | Branch           |
| `011`  | Jump             |
| `100`  | Upper Immediate  |

#### **Testing:**
Using G-test to check whether this works following the basic framework along with a test block for each of the instruction types and by manually finding an expected solution.
An example for this is for U-type:
```cpp
TEST_F(SignExtensionTest, Utype) {
    dut->instr = 0xff600313;  
    dut->ImmSrc = 0b011;
    evaluate();
    EXPECT_EQ(dut->ImmOp, 0xFFFFF600);
}
```
