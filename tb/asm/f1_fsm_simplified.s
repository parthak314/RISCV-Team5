.text
.globl main

# Registers:
# a0 - Current state
# t0 - Temporary register for random delay
# t1 - Target value for state 8 (11111111)
# t2 - LFSR register for random delay

main:
    # Initialize state and LFSR
    addi    a0, zero, 0x0           # Set initial state to S_0 (00000000)
    addi    t1, zero, 0b11111111    # Target state value for S_8 (11111111)
    addi    t2, zero, 0b10110101    # Initialize LFSR seed value

reset_check:
    # Check for reset (pseudo-reset in this version)
    # Replace with an actual input check if reset input is available
    addi    t0, zero, 1            # Simulate a reset signal being high
    beq     t0, zero, state_update # If reset signal is low, skip reset logic
    addi    a0, zero, 0x0          # Reset state to S_0
    jal     ra, random_delay       # Call random delay routine
    beq     zero, zero, reset_check # Restart the loop after reset

state_update:
    # Update state by shifting left and adding 1
    slli    a0, a0, 1              # Shift state left
    ori     a0, a0, 0b1            # Insert 1 to update state
    bne     a0, t1, continue_loop  # Check if state reached S_8
    addi    a0, zero, 0x0          # Reset to S_0 if S_8 is reached

continue_loop:
    # Add random delay before next state transition
    jal     ra, random_delay
    beq     zero, zero, reset_check # Continue the state machine loop

random_delay:
    # Generate pseudo-random delay using LFSR
    andi    t0, t2, 1              # Extract LSB of LFSR
    srli    t2, t2, 1              # Shift LFSR right
    beq     t0, zero, lfsr_skip    # Skip XOR if LSB is 0
    xori    t2, t2, 0b10100101     # XOR with a feedback polynomial
lfsr_skip:
    addi    t0, t2, 0              # Use LFSR value as delay
delay_loop:
    addi    t0, t0, -1             # Decrement delay counter
    bnez    t0, delay_loop         # Loop until delay counter is 0
    ret                            # Return from delay routine
