.text
.globl main

main:
    li      a0, 0x0                # a0 holds the current state (S_0 initially)
    li      a2, 0                  # a2 is used for cmd_delay
    li      a3, 0                  # a3 is used for cmd_seq
    li      t1, 0b11111111          # t1 = 1111111 (Value at State 8 for 7-bit state)
    li      t4, 0b1011010          # Seed for 7-bit LFSR (pseudo-random generator)

shift_loop:
# delay
    li      t2, 10                 # Set delay counter to 10 (1-second equivalent for 1 MHz clock)
delay_loop:
    addi    t2, t2, -1             # Decrement the counter
    bnez    t2, delay_loop         # Repeat until counter reaches 0

    slli    a0, a0, 1              # Shift left
    ori     a0, a0, 0b1            # Replace the gap with a 1 (increment states)
    bne     a0, t1, state_output   # If not at State 8, jump to output logic

state_S8:
    li      a2, 1                  # Set cmd_delay to 1 in S_8

    # Generate random delay using 7-bit LFSR
    andi    t5, t4, 1              # Extract LSB of LFSR
    srli    t4, t4, 1              # Shift LFSR right by 1
    beqz    t5, lfsr_skip          # If LSB is 0, skip XOR
    xori    t4, t4, 0b10100000     # XOR with feedback polynomial for 7-bit LFSR (x^7 + x^6 + 1)
lfsr_skip:
    addi    t6, zero, 10           # Cap delay to 10
    rem     t5, t4, t6             # Compute random delay between 0 and 9
    addi    t5, t5, 1              # Ensure delay is between 1 and 10

random_delay:
    addi    t5, t5, -1             # Decrement random delay counter
    bnez    t5, random_delay       # Loop until delay reaches 0

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
