# Author
Marcus Lisman
mal249

# Estimate of time to complete assignment
10

# Actual time to complete assignment
|     Date     | Time Started |     Time Spent |     Work completed|
| 4/9/2023     |      12:00PM |         6 hours|    Read spec, loaded in files, began playing around with building a solution. I worked through each function mentioned in the README and kept testing to make sure I didn't run into memory errors and that certain functions were doing what they were supposed to. In this full stretch I coded out my PSET and began debugging. I had to fix a few segmentation faults, but after testing it out, I got output that matched the output of ./the_avlt.
| 4/17/2023    |       2:30PM |        45 min  | I reviewed my code, added comments where I saw them necessary, and tested my solution against the provided executable the_avlt again. I then made sure my files met the style guide and turned in the assignment on Gradescope.

# Collaboration
I did not discuss my solution with anyone else in the class. 

# Discussion
Building out the AVL trees nearly from scratch through the individual functions was quite a good experience. I found the two main challenges to be structuring the recursion within the functions properly and getting rid of segmentation faults. At first, my recursive functions were returning the incorrect values as I tested my program, but one major oversight I had was that I had to recurse on both the right and left nodes of the tree, which fixed my issues. Stemming off of that idea, when I thought I finished the problem set, I would run the program, but got a segmentation fault over and over again. I found out that it didn't exist before implementing the balance, left_rotate, and right_rotate, and height_diff functions, so I knew the issue had to lie there. I found out that my error was in the fact that I assumed that a node would have both right and left child nodes, so when I ran the program to balance, it would keep that assumption in mind aand try and balance nodes that didn't actually exist, which was causing the segmentation fault. I fixed this by putting in a checker that checked for a valid left and right child node and then made a decision based on the output of that checker. That ensured that the rest of the program and the functions that are called while balancing would not cause segmentation faults, and after making that change, my program was finished and matched that of the provided the_avlt executable.
