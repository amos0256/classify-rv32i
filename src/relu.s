.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li   t0, 1
    blt  a1, t0, error
    li   t1, 0

    mv   t2, a0              # t2 = address of input array

loop_start:
    beq  a1, x0, end_relu    # if a1 == 0, goto end_relu

    lw   t3, 0(t2)           # t3 = array[i]
    bge  t3, t1, skip_set_zero # if t3 >= 0, goto skip_set_zero

    # set 0
    li   t3, 0
    sw   t3, 0(t2)

skip_set_zero:
    addi t2, t2, 4           # next element in array
    addi a1, a1, -1          # update remaining number of elements
    j    loop_start

end_relu:
    ret

error:
    li   a0, 36
    j    exit

exit:
    li   a7, 10
    ecall