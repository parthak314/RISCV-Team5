.text
.globl main
main:
    li t1, -9000        # t1 = 0xFFFFDCD8 
    li t2, 10000        # t2 = 0x2710   
    sw t1, 4(t2)        # mem[10004] = 0xFFFFDCD8 (-9000)
    sh t1, 8(t2)        # mem[10008] = 0xDCD8 (65535)
    sb t1, 12(t2)       # mem[10012] = 0xD8 (255)
    lw t3, 4(t2)        # t3 = mem[10004] = 0xFFFFDCD8 =  4294958296
    lh t4, 8(t2)        # t4 = mem[10008] = 0xFFFFDCD8 =  4294958296 This happens because lh sign extends the word 
    lb t5, 12(t2)       # t5 = mem[100012] = 0xFFFFFFD8 = 4294967256
    addi t3 ,t3 , -1    # t4 = 4294958295
    sub t5, t5, t4      # t5 = 8960
    sub t6, t4, t3      # t6 = 4294958296 - 4294958295      (=1)
    add a0, t6, t5      # a0 = 8961     only t6,t1,t2 protected

    lw t3, 4(t2)       # t3 = mem[10004] = 0xFFFFDCD8 =  4294958296
    lhu t4, 8(t2)       # t4 = mem[10008] = 0xDCD8 =  56536 lhu doesn't extend!!!!! 
    lbu t5, 12(t2)      # t5 = mem[100012] = 0xD8 = 216
    sub t3, t3, t4      # t3 = 4294901760
    sub t4, t3, t5      # t4 = 4294901544
    sub a0, t4, a0     # a0 = 4294892583

    bne     a0, zero, finish    # enter finish state

finish:     # expected result is 4294892583
    bne     a0, zero, finish     # loop forever
