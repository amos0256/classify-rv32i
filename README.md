# Assignment 2: Classify
contributed by <[`amos0256`](https://github.com/amos0256/classify-rv32i)>

###### tags: `Computer Architecture 2024 Fall`

## `abs.s`
### Functionality Overview
The `abs` function takes an integer pointer as input and modifies the value it points to, converting it into its absolute value.
* If the value is negative, the function negates it to make it positive.
* If the value is already positive, it remains unchanged.
### Challenges
1. Handling Negative Value
    Using `neg` instruction to negate negative value, and no action is taken for non-negative value.
2. In-Place Modification
    This function modifies the value in place, which requires direct memory manipulation. It uses the `lw` instruction to retrieve the value from the given address, checks if it's negative, and if so, negates it before storing it back to the same memory address using the `sw` instruction.

## `relu.s`
### Functionality Overview
The `relu` function processes an array of integers and applies the following transformation to each element `a`
$$
\rm{ReLU}(a) = \max{(0, \ x)}
$$
* If the element is negative, it is replaced by zero.
* If the element is non-negative, it remains unchanged.

### Challenges
1. Loop and Index Management
    The function loops through the array, processing each element in turn and ensuring the correct number of elements are processed. It updates the pointer after each element and reduces the count (`a1`) accordingly. The function uses the pointer (`t2`) to traverse the array and the `addi` instruction to move to the next element after each operation.
2. In-Place Modification
    This is similar to the 2. In-Place Modification in `abs.s`.
    
## `argmax.s`
### Functionality Overview
The `argmax` function processes an array of integers and returns the index of the first occurrence of the maximum value. If the array contains multiple maximum values, the function returns the index of the first one.
* It compares each element of the array and keeps track of the maximum value and its index.
* The comparison starts from the second element and continues through the array until the maximum value is found.

### Challenges
1. Finding the Maximum Value
    The function scans the array to identify the maximum value while keeping track of its index. It compares each element to the current maximum, updating both the maximum value and its index when a larger value is found. If an element is equal to the current maximum, the function continues without modifying the index.

## `dot.s`
### Functionality Overview
The `dot` function computes the sum of the products of corresponding elements from two arrays with specified strides
$$
\sum(\rm{arr0}[\it{i} \times \rm{stride0}] \times \rm{arr1}[\it{i} \times \rm{stride1}])
$$
where $i$ ranges from `0` to `element_count - 1`.

### Challenges
1. Handling Negative Values
    To handle the dot product, we track whether the multiplicand and multiplier have the same sign using a variable. This simplifies processing of negative values by converting them to their absolute values in the loop. The variable ensures the sign of the final product is correctly adjusted based on the initial signs, negating the result if necessary.
2. Strided Access
    The function handles strided access by dynamically adjusting memory address calculations for each array, ensuring correct elements are accessed and multiplied. Stride values are pre-shifted by multiplying them by 4 (as each element is 4 bytes), and memory pointers are updated during each iteration to optimize performance.
3. Multiplication
   To optimize multiplication without directly accumulating the multiplicand, the function leverages bitwise operations such as `slli`, `srli`, and `andi`. By manipulating the values through shifts and masking, the multiplication process is streamlined, reducing the need for repetitive additions.
   This method ensures efficient computation. When using the accumulating multiplicand method, it takes approximately 70 seconds to run all the test files, but with the improved multiplication method, it only takes about 38 seconds.
    * example
       ```
        10 * 7
       ```
    * multiplication
        ```
        initial:
        multiplier: 1010
        multiplicand: 111
        product: 0
        
        1st:
        multiplier: 1010
        multiplicand: 111
        product: 1010
        
        2nd:
        multiplier: 1 0100
        multiplicand: 11
        product: 1 1110
        
        3rd:
        multiplier: 10 1000
        multiplicand: 1
        product: 100 0110 -> 70 in DEC
        ```
4. Incorrect Import
    Importing functions from `abs.s` into `dot.s` will cause test errors. To resolve this, replace all uses of the `abs` function with a conditional check to determine if the value is negative, and if so, negate the value.

## `matmul.s`
### Functionality Overview
The matmul function calculates
$$
C[i][j] = \rm{dot}(A[{\it i}], B[:, \ {\it j}])
$$
where
* $A$ is a $n \times m$ matrix
* $B$ is a $m \times k$ matrix
* $C$ is a $n \times k$ matrix

### Challenges
1. Computation
To compute $C[i][j]$, the dot product of the i-th row of A and the j-th column of B is required. This is achieved through a nested loop structure that iterates over the rows of A and columns of B, utilizing the dot function to efficiently calculate the result.

## `read_matrix.s` & `write_matrix.s`
### Functionality Overview
The read_matrix function reads a matrix from a binary file with the following format:
* Header (8 bytes):
    Bytes 0-3: Number of rows (int32).
    Bytes 4-7: Number of columns (int32).
* Data:
    Matrix elements (int32), stored in row-major order.
### Challenges
1. Multiplication
    Since the number of rows and columns is always positive, there is no need to check for negative values. The computation is similar to the 3. Multiplication in `dot.s`.
2. Incorrect Import
    If I import `dot.s`, it will result in duplicate dot labels because the `test.sh` script automatically imports the `dot.s` file. Therefore, there is no need to import it again.

## `classify.s`
### Functionality Overview
This code implements a neural network classifier in assembly that reads two pre-trained matrices and an input matrix, performs matrix multiplication and ReLU activation, then computes and writes the classification result to an output file. It includes error handling for invalid arguments and memory issues.

### Challenges
1. Multiplication
The computation is similar to the 3. Multiplication in `dot.s`.

## Reference
1. [Assignment2: Complete Applications](https://hackmd.io/@sysprog/2024-arch-homework2#Assignment2-Complete-Applications)
2. [classify-rv32i](https://github.com/sysprog21/classify-rv32i)
3. [CS 61C Fall 2024-Lab 3: RISC-V, Venus](https://cs61c.org/fa24/labs/lab03/)
4. [Environmental Calls](https://github.com/ThaumicMekanism/venus/wiki/Environmental-Calls)