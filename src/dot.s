.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    addi sp, sp, -8
    sw   s0, 0(sp)
    sw   s1, 4(sp)

    li   t0, 1
    blt  a2, t0, error_terminate
    blt  a3, t0, error_terminate
    blt  a4, t0, error_terminate

    li   t0, 0               # t0 is result of dot
    li   t1, 0               # i counter

    slli t2, a3, 2           # t2 = stride0 * 4, 4 bytes for each array element
    slli t3, a4, 2           # t3 = stride1 * 4

loop_start:
    bge  t1, a2, end_dot     # for loop elements times
    
    lw   t4, 0(a0)           # t4 = arr0[i * stride0]
    lw   t5, 0(a1)           # t5 = arr1[i * stride1]

    li   s0, 0               # s0 is accumulator for the product
    li   s1, 1               # s1 is used to identify positive(1)/negative(-1)

    # check the sign of t4
    bltz t4, t4_negative     # if t4 < 0, goto t4_negative
    j    t5_check            # else goto t5_check

t4_negative:
    # ==========
    # TODO: modify to abs function
    # ==========
    neg  t4, t4              # abs of t4
    neg  s1, s1              # record negative

    # check the sign of t5
t5_check:
    bltz t5, t5_negative     # if t5 < 0, goto t5_negative
    j    multiply            # else goto multiply

t5_negative:
     # ==========
    # TODO: modify to abs function
    # ==========
    neg  t4, t4              # abs of t4
    neg  s1, s1              # record negative

multiply:
    beqz t5, accumulate      # if t5 == 0, goto accumulate
    add  s0, s0, t4          # s0 += t4
    addi t5, t5, -1          # t5--
    j    multiply

accumulate:
    bltz s1, negate_result   # if s1 is -1(negative), goto negate_result
    j    add_to_result

negate_result:
    neg  s0, s0

add_to_result:
    add  t0, t0, s0

    add  a0, a0, t2
    add  a1, a1, t3
    addi t1, t1, 1
    j    loop_start

loop_end:
    mv   a0, t0
    
    lw   s0, 0(sp)
    lw   s1, 4(sp)
    addi sp, sp, 8

    jr   ra

error_terminate:
    blt  a2, t0, set_error_36
    li   a0, 37
    j    exit

set_error_36:
    li   a0, 36
    j    exit

exit:
    li   a7, 10
    ecall