# Author
Marcus Lisman
mal249

# Estimate of time to complete assignment
12 hours

# Actual time to complete assignment
|     Date     | Time Started |     Time Spent |     Work completed|
| 3/5/23       |       2:00PM |         4 hours|    Read spec, loaded in files, began playing around with building a solution
| 3/7/23       |       9:00AM |         6 hours |  Worked on hookbook Part 1,
worked on being able to successfully read in file input and defining the structs correctly, started working on the helper functions
| 3/8/23       |      6:00PM  |         3 hours | Worked on hookbook Part 1, mainly tried different methods to read in strings and make pirates with those strings, worked on helper functions to create the list and expand it as the two main ones, worked on the smaller functions as well
| 3/10/23      |      12:00PM |         4 hours | Worked on hookbook Part 1, pretty much finished it, got expansion to work, still having issues with long continuous strings that are more than 64 characters. Moving on to Part 2 and will address later.
| 3/14/23      |      7:00PM  |         2 hours | After finishing Part 2, I returned to Part 1 to try and figure out the cases with strings on one line that are longer than 64 characters and how to split them up in stead of tossing away the rest of the string. I ended up making some minor changes to meet all the different possible inputs or lack thereof. My program works as intended and there are some discrepancies between the testing script and the autograder and what my machine does locally, so I think I'm at a point where I'll submit and then request manual grading if needed.

# Collaboration
I did not discuss my solution with anyone else in the class. 

# Discussion
Part 1 was pretty tough, but it set the foundation for a more fun Part 2. An initial major challenge came when actually working to define the structs, as I needed to make sure I created something that was compatible with the function definitions provided in the starter source code. I also needed to make sure that all the types matched up to prevent any errors and/or segmentation faults. After a lot of trial and error, I finally got to a point where I had eliminated my errors and could begin compiling the program and building out the other functions. As some functions relied on others, as I hit segmentation faults in the driver file hookbook.c, I had to find the function that was causing the segmentation fault and debug to try and solve the issues. Solving segmentation faults took up 90% of my debugging, which makes sense in such a memory- and pointer-heavy assignment. After going function by function and using a lot of print statements as flags to see which functions were causing the problems, I was able to eliminate the segmentation faults. I thought I was done, but then I came across a final issue. For some of the tests, some of the lines were longer than 64 characters, but my program was reading them instead of stopping at 64. Additionally, for variations that I tried that stopped at 64 characters, it would cut away the rest of the string, which was not wanted by the test cases and autograder. I had to try a few different things until I could finally get it to work. 