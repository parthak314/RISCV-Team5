.text
.globl main

main:
    # Initialize state and output registers
    li      a0, 0x0                # a0 holds the current state (S_0 initially)
    li      a2, 0                  # a2 is used for cmd_delay
    li      a3, 0                  # a3 is used for cmd_seq
    addi    t1, zero, 0b11111111   # t1 = 11111111 (Value at State 8)

shift_loop:
    # State machine logic with shifting
    slli    a0, a0, 1              # Shift left
    ori     a0, a0, 0b1            # Replace the gap with a 1 (increment states)
    bne     a0, t1, state_output   # If not at State 8, jump to output logic

state_S8:
    li      a2, 1                  # Set cmd_delay to 1 in S_8
    li      a0, 0x0                # Reset state to S_0
    j       shift_loop             # Restart the state sequence

state_output:
    # Output control
    beqz    a0, output_reset       # If state is S_0, reset outputs
    li      a3, 1                  # Set cmd_seq to 1 in non-S_0 states
    j       shift_loop             # Continue the sequence

output_reset:
    li      a2, 0                  # Reset cmd_delay
    li      a3, 0                  # Reset cmd_seq
    j       shift_loop             # Restart the process
