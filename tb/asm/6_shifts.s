.text
.globl main
main:
    li t1, 200      # t1 = 200
    li t2, 2        # t2 = 2
    srl t3, t1, t2  # t3 = t1 >> t2 (200 >> 2 = 50)
    sll t4, t1, t2  # t4 = t1 << t2 (200 << 2 = 800)
    srli t4, t4, 2  # t4 = t4 >> 2  (800 >> 2 = 200)
    slli t3, t3, 2  # t3 = t3 << 2  (50  << 2 = 200)
    li t5, 15      # t5 = 15
    slli t5, t5 , 28    # t5 = F0000000
    srl t6, t5, t2 # t6 = FC000000
    sra t5, t5, t2 # t5 = 3C000000
    #   srai t5, t5, t2 # t5 = 3C000000 # srai doesn't pass gives a 0 output
    sub a0 , t6 , t5 # This should be FC000000 - 3C000000 = C0000000 but instead this outputs 0
    bne a0, zero, finish # enter finish state

finish:             # expected result is 100
    bne a0, zero, finish # loop forever
 


 # DOES NOT PASS SRAI, SRA
 # PASSES SRL, SLLI, SRLI, SLL