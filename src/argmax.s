.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li   t6, 1
    blt  a1, t6, handle_error

    lw   t0, 0(a0)           # t0 = array[i]

    li   t1, 0               # t1 is first index of maximum number
    li   t2, 1               # t2 = 1, i counter

    mv   t3, t0              # t3 is maximum number

    addi a0, a0, 4           # comparation start from index 1

loop_start:
    beq  t2, a1, end_argmax  # if t2 == a1, goto end_argmax

    lw   t0, 0(a0)           # t0 = array[i]
    addi a0, a0, 4           # next element in array

    bgt  t0, t3, update_max  # if t0 > t3, update maximum and index
    j    loop_continue       # next loop
    
update_max:
    mv   t3, t0              # update maximum
    mv   t1, t2              # update index of maximum

loop_continue:
    addi t2, t2, 1           # increment index
    j    loop_start

end_argmax:
    mv   a0, t1              # return maximum Index
    ret

handle_error:
    li   a0, 36
    j    exit

exit:
    mv   a1, a0
    li   a0, 17
    ecall