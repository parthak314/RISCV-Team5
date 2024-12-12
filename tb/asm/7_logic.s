.text
.globl main
main:
    li t1, 2    # t1 = 010
    li t2, 7    # t2 = 111
    and t3, t1, t2  # t3 = 010 & 111        (=010 //2) check and
    or t4, t1, t2   # t4 = 010 | 111        (=111 //7) check or 
    add t5, t3, t4  # t1 = 010 + 111                                    (=1001 //9) And & Or
    xor t3, t1, t2  # t3 = 010 ^ 111        (=101 //5) check xor
    xori t4, t1, 10 # t4 = 0010 ^ 1010      (=1000 //8) check xori 
    add t6, t3, t4  # t2 = 0101 + 1000                                  (=1101 //13) xor Xori 
    ori t3, t1, 5   # t3 = 010 | 101        (=111 /7) check ori
    andi t4, t2, 10 # t4 = 0111 & 1010      (=0010 /2) check andi
    add t1, t3, t4  # t3 = 111 + 0010                                   (=1001 /9) ori andi
    add t5, t5, t6  # t5 = 1001 + 1101      (=10110 /22)
    add a0, t5, t1  # a0 = 22 + 9 = 31        (01 1111)
    bne     a0, zero, finish    # enter finish state

finish:     # expected result is 31
    bne     a0, zero, finish     # loop forever
