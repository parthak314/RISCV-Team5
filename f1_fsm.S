.text
.globl main
# a0 is the current state
# t1 is a temporary register to store the value at state 8 (1111 1111)
main:
    addi    a0, zero, 0x0                # a0 = 0         -  Value at State 0
    addi    t1, zero, 0b11111111         # a1 = 11111111  -  Value at State 8
shift_loop:
    slli    a0, a0, 1
    ori     a0, a0, 0b1                  # Shift left and replace the gap with a 1 (increment states)
    bne     a0, t1, mloop                # if a0 != 1111 1111 (State 8) then reset to 0 
reset_loop: 
    addi    a0, zero, 0x0                # Reset to state 0 if at State 8
    beq     zero, zero, shift_loop       # if a0 != 1111 1111 (State 8) then cycle through