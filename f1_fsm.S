.text
.globl main
# a0 is the current state
main:
    addi    a0, zero, 0x0        # a0 = 0         -  initialise a0 for value at State 0
    addi    t1, zero, 0b11111111 # a1 = 11111111  -  Value at State 8
shift_loop:
    slli    a0, a0, 1
    ori     a0, a0, 0b1         # Shift left and replace the gap with a 1 (increment states)
    bne     a0, t1, iloop       # if a0 != 1111 1111 (State 8) then repeat again from iloop
mloop:
    addi    a0, zero, 0x0       # reinitialise a0 to 0 if it hasn't branched 
    beq     zero, zero, shift_loop   # unconditional branch
