#################################################################
# David Valdez 
# CSC21000 
# QUICKSORT in ASM
# SPRING 2024
#################################################################
.macro printW(%reg)
    la $a0, %reg       # Load message address
    li $v0, 4         # Print string syscall
    syscall
.end_macro
.macro printR(%reg)
    move $a0, %reg       # Load message address
    li $v0, 1         # Print string syscall
    syscall
.end_macro

.macro getTime(%timeVar)
li $v0, 30
syscall
move %timeVar, $a0
.end_macro
.macro swap
	lw   $t6, 0($t4)
	lw   $t7, 0($t5)
	sw   $t7, 0($t4)
	sw   $t6, 0($t5)
	addi $t5, $t5, 4
	addi $t8,$t8,1
.end_macro
.macro partition 			#partition method
	move $s1, $a1		#s1 = low
	move $s2, $a2		#s2 = high

	sll  $t1, $s1, 2	# t1 = 4*low
	add  $t1, $a0, $t1	# t1 = arr + 4*low
	lw   $t2, 0($t1)	# t2 = arr[low] //pivot value
	move $t0, $zero		#initialize index
	sub  $t3, $s2, $s1	#calculate loops needed high - low 
	move $t5, $zero		#initlialize LRGT
	#$t0 index
	#$t1 addy array[low]// array pointer 
	#$t2 value array[low]// pivot value
	#$t3 i high - low = n total loops
	#$t4 most recentLT
	#$t5 least recentGT
	#$t6 next val
for:
	beqz $t3, endSwap	#when loops = 0, put pivot into place
	addi $t1, $t1,4		#increase array pointer to next element 
	lw $t6, 0($t1)		#load the value at array pointer
	ble $t6,$t2,lessBranch	#if less than or equal to go to less than branch
	bgt $t6,$t2,greatBranch	#if greater than go to greatBranch
	
	
lessBranch:
	addi $t0, $t0,1		#increase the index by 1
	subi $t3, $t3,1		#decrease the loop by 1
	move $t4, $t1		#update MRLT
	beqz $t5, for		#if no LRGT exists go back to the for loop 
	swap			#otherwise swap 
	j    for		#go back to for loop
	
greatBranch:
	subi $t3, $t3,1		#decrease loop
	beqz $t5, update	#if no LRGT exists set one
	j for			#go to for loop
update:
	move $t5, $t1		#set LRGT with the value of $t1, which is the address of the array pointer at this point in the loop
	j for
	
endSwap:
	sll  $t1, $s1, 2	# t1 = 4*low
	add  $t1, $a0, $t1	# t1 = arr + 4*low
	add  $t2, $t0, $s1	# add index + starting point to get the index of the whole array
	sll  $t3, $t2, 2	# t3 = 4*index
	add  $t3, $a0, $t3	# t3 = arr + 4*index
	lw   $t6, 0($t3)	#load value at index
	lw   $t7, 0($t1)	#load value at low
	sw   $t7, 0($t3)	#store value of low at index address
	sw   $t6, 0($t1)	#store value of index at low address
.end_macro
.data 
array: .word 10, 32, 45, 6, 89, 100, 54, 28, 39, 95, 20, 67, 77, 34, 2, 66, 81, 48, 12, 19, 8, 7, 90, 11, 50, 64, 38, 85, 79, 96, 53, 25, 37, 41, 68, 71, 83, 16, 29, 9, 13, 23, 30, 5, 97, 55, 40, 26, 49, 21, 72, 18, 80, 84, 58, 92, 17, 57, 62, 27, 36, 31, 59, 44, 61, 47, 33, 43, 70, 3, 4, 52, 73, 76, 63, 60, 75, 87, 94, 14, 82, 88, 35, 15, 99, 69, 42, 86, 56, 51
array2: .word 106, 364, 43, 840, 923, 388, 566, 515, 961, 219, 403, 461, 876, 332, 333, 902, 385, 549, 285, 564, 575, 378, 763, 379, 258, 321, 484, 887, 671, 726, 785, 992, 508, 157, 516, 845, 438, 964, 732, 699, 799, 649, 587, 618, 175, 309, 337, 458, 949, 215, 178, 888, 796, 842, 733, 326, 865, 68, 60, 189, 440, 74, 439, 492, 454, 981, 352, 93, 421, 510, 971, 934, 150, 339, 409, 541, 599, 899, 588, 414, 681, 232, 585, 186, 636, 893, 538, 70, 846, 995, 406, 356, 386, 698, 882, 69, 45, 241, 83, 647, 827, 490, 85, 830, 499, 759, 367, 942, 721, 630, 97, 891, 579, 481, 266, 216, 910, 863, 291, 199, 534, 317, 665, 750, 862, 631, 806, 523, 38, 129, 495, 28, 592, 839, 555, 600, 813, 524, 691, 597, 408, 389, 82, 979, 807, 700, 973, 109, 168, 128, 986, 127, 802, 678, 445, 669, 909, 878, 787, 727, 478, 974, 617, 6, 969, 166, 720, 437, 848, 996, 854, 818, 650, 124, 249, 867, 658, 193, 239, 767, 858, 570, 376, 890, 108, 393, 705, 743, 10, 533, 653, 47, 158, 947, 758, 209, 593, 568, 154, 853, 851, 641, 610, 279, 299, 741, 577, 144, 642, 639, 30, 44, 710, 685, 916, 451, 18, 771, 236, 894, 855, 633, 755, 965, 22, 263, 327, 914, 465, 835, 716, 358, 826, 928, 247, 831, 32, 391, 606, 250, 181, 55, 149, 560, 399, 884, 65, 324, 94, 133, 522, 429, 348, 12, 201, 208, 751, 63, 267, 864, 993, 812, 77, 177, 604, 424, 790, 330, 474, 784, 719, 841, 886, 362, 941, 798, 913, 954, 448, 915, 435, 467, 428, 331, 105, 766, 303, 430, 237, 506, 280, 444, 276, 967, 715, 368, 792, 294, 146, 9, 544, 615, 54, 390, 99, 176, 252, 612, 637, 777, 573, 539, 134, 552, 643, 184, 708, 121, 955, 837, 117, 377, 29, 978, 903, 620, 180, 396, 547, 567, 270, 233, 53, 693, 442, 125, 800, 675, 436, 476, 920, 511, 990, 791, 387, 107, 222, 140, 244, 646, 989, 994, 120, 860, 696, 432, 401, 196, 148, 970, 857, 402, 912, 584, 764, 959, 313, 686, 816, 143, 419, 582, 772, 483, 295, 156, 240, 507, 695, 946, 278, 296, 234, 211, 569, 873, 537, 340, 341, 956, 462, 277, 204, 594, 119, 190, 748, 580, 135, 714, 543, 81, 648, 927, 819, 162, 382, 810, 950, 809, 130, 275, 227, 793, 548, 101, 322, 558, 223, 843, 774, 877, 472, 357, 122, 453, 300, 542, 932, 765, 738, 832, 602, 293, 595, 825, 290, 645, 116, 997, 879, 473, 605, 145, 651, 598, 679, 57, 531, 953, 61, 78, 335, 987, 164, 75, 821, 251, 471, 488, 536, 205, 627, 316, 459, 905, 852, 581, 126, 960, 338, 747, 141, 690, 343, 425, 844, 898, 975, 640, 711, 654, 346, 433, 487, 919, 820, 302, 556, 447, 808, 634, 704, 197, 194, 42, 138, 504, 926, 525, 392, 102, 161, 355, 86, 370, 91, 921, 151, 482, 834, 672, 571, 153, 673, 169, 304, 136, 394, 847, 59, 395, 532, 815, 734, 142, 756, 361, 561, 27, 603, 14, 475, 206, 937, 550, 320, 505, 288, 373, 951, 670, 517, 786, 318, 5, 163, 187, 553, 663, 349, 441, 182, 718, 619, 701, 885, 629, 838, 426, 723, 576, 667, 21, 725, 286, 334, 497, 682, 883, 562, 735, 255, 160, 301, 984, 328, 46, 545, 325, 521, 274, 1000, 736, 635, 469, 284, 314, 329, 345, 988, 431, 519, 17, 804, 132, 8, 614, 90, 450, 315, 829, 775, 880, 968, 257, 200, 202, 512, 940, 850, 228, 307, 713, 897, 174, 565, 824, 712, 226, 3, 238, 801, 527, 123, 306, 930, 611, 96, 479, 171, 823, 95, 900, 460, 632, 889, 491, 563, 80, 342, 289, 781, 400, 36, 375, 369, 706, 19, 283, 113, 383, 455, 788, 76, 457, 817, 762, 183, 746, 4, 694, 103, 638, 225, 423, 626, 381, 256, 943, 253, 623, 805, 929, 836, 874, 319, 703, 535, 907, 7, 493, 242, 167, 272, 485, 470, 952, 292, 644, 982, 520, 662, 363, 530, 728, 872, 917, 740, 231, 518, 111, 412, 757, 870, 287, 702, 413, 131, 434, 540, 359, 246, 16, 139, 52, 254, 489, 214, 496, 179, 245, 35, 173, 404, 616, 861, 944, 709, 62, 828, 73, 875, 782, 416, 112, 224, 963, 803, 264, 49, 501, 513, 935, 58, 265, 37, 789, 983, 871, 463, 901, 557, 210, 574, 365, 677, 931, 203, 371, 410, 192, 744, 418, 229, 607, 966, 729, 33, 344, 115, 218, 310, 586, 427, 991, 500, 88, 405, 282, 822, 661, 66, 692, 308, 717, 624, 689, 906, 613, 859, 958, 220, 849, 881, 745, 776, 933, 622, 354, 761, 269, 312, 92, 24, 628, 896, 833, 71, 957, 911, 152, 48, 323, 41, 422, 366, 572, 976, 895, 213, 528, 446, 466, 100, 948, 596, 680, 998, 26, 683, 652, 625, 165, 353, 212, 443, 417, 110, 999, 271, 503, 40, 305, 23, 297, 780, 20, 674, 666, 676, 498, 114, 1, 11, 583, 621, 84, 198, 191, 384, 962, 753, 420, 609, 795, 159, 760, 687, 980, 415, 985, 724, 794, 273, 922, 868, 972, 374, 360, 477, 664, 188, 589, 924, 783, 464, 261, 936, 170, 411, 697, 770, 398, 452, 977, 769, 684, 259, 546, 468, 172, 904, 480, 311, 502, 866, 449, 797, 591, 298, 601, 15, 778, 722, 79, 207, 925, 217, 731, 707, 939, 779, 688, 526, 104, 118, 811, 350, 529, 559, 31, 908, 659, 262, 509, 945, 407, 752, 754, 578, 34, 221, 856, 608, 668, 268, 13, 155, 351, 64, 137, 660, 554, 737, 87, 39, 656, 185, 739, 248, 938, 336, 590, 89, 347, 514, 892, 2, 98, 918, 657, 869, 768, 51, 243, 50, 56, 742, 281, 551, 456, 655, 372, 814, 397, 494, 235, 230, 67, 486, 147, 730, 72, 773, 749, 260, 195, 380, 25
newline: .asciiz "\n"
swapsP:  .asciiz "Swaps performed: "
Time:    .asciiz "Time taken: "
# After your program has run, the integers in this array
# should be sorted.
.text # Defines the start of the code section for the program .
.globl main

main:
	getTime($s6)
	la $t0, array # Moves the address of array into register $t0.
	addi $a0, $t0, 0 # Set argument 1 to the array.
	addi $a1, $zero, 0 # Set argument 2 to (low = 0)
	addi $a2, $zero, 89 # Set argument 3 to (high = 89, last index in array)
	jal quicksort # Call quick sort
	getTime($s7)
	sub $s7, $s7, $s6
	printW(Time)
	printR($s7)
	printW(newline)
	printW(swapsP)
	printR($t8)
	printW(newline)
	move $t8,$zero
    

	getTime($s6)
	la $t0, array2 # Moves the address of array into register $t0.
	addi $a0, $t0, 0 # Set argument 1 to the array.
	addi $a1, $zero, 0 # Set argument 2 to (low = 0)
	addi $a2, $zero, 999 # Set argument 3 to (high = 999, last index in array)
	jal quicksort # Call quick sort
	getTime($s7)
	sub $s7, $s7, $s6
	printW(Time)
	printR($s7)
	printW(newline)
	printW(swapsP)
	printR($t8)
	printW(newline)
	
	li $v0, 10 # Terminate program run and
	syscall # Exit


quicksort:			#quicksort method

	addi $sp, $sp, -16	# Make room for 4

	sw $a0, 0($sp)		# a0
	sw $a1, 4($sp)		# low
	sw $a2, 8($sp)		# high
	sw $ra, 12($sp)		# return address
	
	bge $a1, $a2, return	# if low >= high, endif

        partition		# call partition 
	move $s0, $t2		# pivot, s0= t2

	lw $a1, 4($sp)		#a1 = low
	addi $a2, $s0, -1	#a2 = pi -1
	jal quicksort		#call quicksort

	addi $a1, $s0, 1	#a1 = pi + 1
	lw $a2, 8($sp)		#a2 = high
	jal quicksort		#call quicksort

 return:
 	lw $a0, 0($sp)		#restore a0
 	lw $a1, 4($sp)		#restore a1
 	lw $a2, 8($sp)		#restore a2
 	lw $ra, 12($sp)		#restore return address
 	addi $sp, $sp, 16	#restore the stack
 	jr $ra			#return to caller
