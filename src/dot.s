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
    li   t0, 1
    blt  a2, t0, error_terminate
    blt  a3, t0, error_terminate
    blt  a4, t0, error_terminate

    li   t0, 0
    li   t1, 0

loop_start:
    bge  t1, a2, loop_end
    
    # load arr0[i * stride0] and arr1[i * stride1]
    mul  t2, t1, a3          # t2 = i * stride0, offset for arr0
    mul  t3, t1, a4          # t3 = i * stride1, offset for arr1
    add  t4, a0, t2          # t4 = arr0 base address + offset
    add  t5, a1, t3          # t5 = arr1 base address + offset
    lw   t6, 0(t4)           # Load element from arr0
    lw   t7, 0(t5)           # Load element from arr1

    # calculate product and accumulate
    mul  t8, t6, t7          # t8 = arr0[i] * arr1[i]
    add  t0, t0, t8          # sum += t8

    addi t1, t1, 1           # t1 += 1, increment index
    j    loop_start

end_loop:
    mv   a0, t0
    jr   ra

error_terminate:
    blt  a2, t0, set_error_36
    li   a0, 37
    j    exit

set_error_36:
    li   a0, 36
    j    exit