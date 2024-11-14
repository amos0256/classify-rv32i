# wrong file!!!
# There are some errors.

.import ../abs.s

.data
positive_num:
    .word 5
zero_num:
    .word 0
negative_num:
    .word -6
output_msg_1:
    .string "Absolute value of "
output_msg_2:
    .string " is: "
newline:
    .string ".\n"

.text
.globl main_test

main_test:
    # test for positive number
    la   a0, positive_num
    jal  abs

    # a0 is result of abs
    lw   a0, 0(a0)
    la   a1, positive_num
    lw   a1, 0(a1)
    j    print_result

    # test for zero number
    la   a0, zero_num
    jal  abs

    # a0 is result of abs
    lw   a0, 0(a0)
    la   a1, zero_num
    lw   a1, 0(a1)
    j    print_result

    # test for negative number
    la   a0, negative_num
    jal  abs

    # a0 is result of abs
    lw   a0, 0(a0)
    la   a1, negative_num
    lw   a1, 0(a1)
    j    print_result

    # exit program
    li   a0, 10
    ecall

print_result:
    # a0 is result of abs
    # a1 is original number
    mv   t0, a0
    mv   t1, a1

    # print output string
    li   a0, 4
    la   a1, output_msg_1
    ecall

    # print original number
    li   a0, 1
    mv   a1, t1
    ecall

    # print output string
    li   a0, 4
    la   a1, output_msg_2
    ecall

    # print abs result
    li   a0, 1
    mv   a1, t0
    ecall

    # print newline
    li   a0, 4
    la   a1, newline
    ecall

    ret
