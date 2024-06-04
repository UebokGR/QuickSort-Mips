# QuickSort-Mips

Two quicksort files are provided TimedQuicksort displays only time. SwapsTimeQuicksort displays time and swaps.

This MIPS assembly code, developed in MARS IDE, implements the quick sort algorithm to sort an array of integers. The program follows these steps:

1. Initializes an array integers.
2. Calls the `quicksort` function to sort the array.
3. The array is sorted; can be observed in the data section of MIPS IDE.
4. Time taken for array to be sorted and number of swaps is displayed.

## Code Explanation

- The program initializes an array of integers.
- It uses the quick sort algorithm to sort the array in ascending order.
- The `partition` function is used to find the pivot and divide the array.
- The `swap` function swaps elements in the array as needed during the sorting process.
- The number of swaps is tracked by $t8
- The number of swaps and time is displayed through system calls

## IN DEPTH Code Explanation
Partiton
This program chooses the pivot to be the first element of the given array. It takes advantage of the fact that at any given point there will be two pointers one has the
'Most Recent Less Than(MRLT)' address and the other  'Least Recent Greater Than(LRGT)' address. The are represented by $t4 and $t5 respectively. 
To understand the significance of these addresses see the diagram below 
```
Array 8 digits

5 2 4 1 7 0 6 3  // initiliazation
____________________________________________________________________________________________________

5 2 4 1 7 0 6 3 // 1st step: 2 considered, it is less than 5 becomes MRLT (represented by | )
  |
____________________________________________________________________________________________________

5 2 4 1 7 0 6 3 // 2nd step: 4 considered, it is less than 5 becomes new MRLT (represented by | )
    |
____________________________________________________________________________________________________
5 2 4 1 7 0 6 3 // 3rd step: 1 considered, it is less than 5 becomes new MRLT (represented by | )
      |
____________________________________________________________________________________________________
5 2 4 1 7 0 6 3 // 4th step: 7 considered, it is more than 5 LRGT is initiliazed (represented by / )
      | /
____________________________________________________________________________________________________
5 2 4 1 7 0 6 3 // 5th step: 0 considered, it is less than 5 becomes new MRLT and is swapped with LRGT
        / |

5 2 4 1 0 7 6 3   // LRGT is increased by 4 to point to the next element
          |
          /

5 2 4 1 0 7 6 3 // 6th step: 6 considered, it is more than 5 LRGT DOES NOT CHANGE because it tracks the LEAST RECENT greater value
          |
          /

5 2 4 1 0 7 6 3 // 7th step: 3 considered, it is less than 5 becomes new MRLT and is swapped with LRGT
          /   |
5 2 4 1 0 3 6 7 // 8th step: LRGT is increased by 4 to point to the next element (THIS NO LONGER MATTERS AS WE ARE DONE PARTITIONING)
            / |
```
So what happened?
The program takes advantage of the fact that after the first swap between the first LRGT and MRLT we will always know the position of the LRGT because it will be the next element after the swap. The result is that from LRGT to the end of the array contains the elements greater than the pivot. 
```
5 2 4 1 0 3 6 7 
            /
            ->>
so 6 and 7
```
From LRGT (Not including LRGT) to the beginning of the array contains elements less than the pivot (not including the pivot). 
```
5 2 4 1 0 3 6 7 
            /
  <<<<<<<<<-o
so 3 0 1 4 2 
```
The final step is to put the pivot into the correct position. The register $t0 tracks the number of times that we considered a element less than the pivot which in turn represents the index of where we will be placing the pivot. In this case we considered 5 elements less than the pivot the result is 
```
3 2 4 1 0 5 6 7 
```
Partition index is preserved and used in the quicksort call. 

