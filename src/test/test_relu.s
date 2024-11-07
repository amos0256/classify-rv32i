.import ../relu.s

.data
matrix:
    .word -2, 0, 3, -1, 5
matrix_len:
    .word 5
before_msg:
    .string "Before ReLU:\n"
after_msg:
    .string "After ReLU:\n"
space:
    .string " "
newline:
    .string "\n"

.text
.globl main_test

main_test:
    # print matrix before applying ReLU
    la   a0, before_msg      # a0 = address of before_msg
    jal  print_string        # print "Before ReLU:"

    la   a0, matrix          # a0 = address of matrix
    lw   a1, matrix_len      # a1 = number of elements in matrix
    jal  print_matrix        # print matrix

    # call the ReLU function
    la   a0, matrix          # a0 = address of matrix
    lw   a1, matrix_len      # a1 = number of elements in matrix
    jal  relu                # apply ReLU to matrix

    mv   t0, a0              # t0 = address of return array 

    # print matrix after applying ReLU
    la   a0, after_msg
    jal  print_string        # print "After ReLU:"
    
    mv   a0, t0
    lw   a1, matrix_len      # a1 = number of elements in matrix
    jal  print_matrix        # print matrix

    # exit program
    li   a0, 17
    mv   a1, x0
    ecall

# print specify string function
print_string:
    # a0 is address of output string
    mv   a1, a0
    li   a0, 4
    ecall

    ret

# print matrix
print_matrix:
    li   t1, 0
    mv   t2, a0              # t2 = address of matrix
    mv   t3, a1              # t3 = length of matrix

print_element:
    bge  t1, t3, end_print_matrix # end if all elements printed
    
    # print element
    li   a0, 1
    lw   a1, 0(t2)           # load next element
    ecall

    li   a0, 4
    la   a1, space
    ecall

    addi t2, t2, 4           # move to next matrix element
    addi t1, t1, 1           # increment counter
    j    print_element

end_print_matrix:
    li   a0, 4
    la   a1, newline
    ecall

    ret