.text
.globl main
# a0 is the current state
main:
    addi    t1, zero, 0x0        # a0 = 0         -  Value at State 0
    addi    a0, zero, 0x0        # a0 = 0         -  Value at State 0
    addi    a1, zero, 0b11111111 # a1 = 11111111  -  Value at State 8
mloop:
    addi    a0, zero, 0x0        # a0 = 0 
iloop:
    slli    a0, a0, 1
    ori     a0, a0, 0b1         # Shift left and replace the gap with a 1 (increment states)
    beq     a0, a1, mloop       # if a0 != 1111 1111 (State 8) then reset to 0 
    bne     a0, a1, iloop       # if a0 != 1111 1111 (State 8) then cycle through
