.import ../dot.s

.data
vector_1:
    .word 2, -1, 4, 5, -3
vector_2:
    .word 1, 3, -2, 4, 6
element:
    .word 3
stride_1:
    .word 2
stride_2:
    .word 2
output_msg:
    .string "Result of dot: "
newline:
    .string "\n"

.text
.globl main_test

main_test:
    la   a0, vector_1
    la   a1, vector_2
    lw   a2, element
    lw   a3, stride_1
    lw   a4, stride_2

    jal  dot
    
    mv   t0, a0

    # print output string
    li   a0, 4
    la   a1, output_msg
    ecall

    # print dot result
    li   a0, 1
    mv   a1, t0
    ecall

    # exit program
    li   a0, 17
    li   a1, 0
    ecall
