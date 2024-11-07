.import ../argmax.s

.data
matrix:
    .word 4, 0, 5, -3, 5
matrix_len:
    .word 5
output_msg:
    .string "Index of the largest element: "
newline:
    .string "\n"

.text
.globl main_test

main_test:
    la   a0, matrix
    lw   a1, matrix_len
    jal  argmax

    mv   t0, a0

    # print output string
    li   a0, 4
    la   a1, output_msg      # a1 = address of output message
    ecall
  
    # print argmax result
    li   a0, 1
    mv   a1, t0
    ecall

    # print newline
    li   a0, 4
    la   a1, newline
    ecall

    # exit program
    li   a0, 17
    li   a1, 0
    ecall