# Author
Marcus Lisman
mal249

# Estimate of time to complete assignment
4 hours

# Actual time to complete assignment
|     Date     | Time Started |     Time Spent |     Work completed|
|  2/9/2023   |     6:00 PM |     3 hours |    read the assignment, started working through the logic before coding, and then began to code out the shouldDie and isAlive functions. I also worked to configure my makefile so I would have a runnable executable.
|  2/10/2023   |      5:00PM |     3 hours |  I worked to meet the non-assumptions in the spec and so it would take only a specific type of input or at least exit with an error code instead of a segmentation fault. I also kept trying to work through the logic to get some of the simple cases outlined in the spec to work.
|  2/11/2023   |      2:30 PM |     2 hours |  I made some changes to my shouldDie and isAlive functions to get the logic right and began to pass some of the cases. Moving in the right direction.

| 2/13/2023   |     7:00 PM |     1 hour 45 minutes    | Based on the results of the autograder, I was failing some of the tests, especially those with large fields. At office hours, Christian and Brian (TAs) helped me to realize that I was having some indexing errors, which was causing the booleans to give me the wrong output for some iterations. I fixed this by checking the index value and assigning it a certain procedure based on the index value. This change made my code pass all the tests and I finished by rounding out my LOG.md 


# Collaboration
I did not discuss my solution with anyone else in the class. 

# Discussion
A big difficuly for me initially was getting the isAlive and shouldDie functions to work as intended. It turned out that I was attempting to overcomplicate the whole point of the function and ended up simplifying it down massively based on what was presented in section. Once I got these functions to work, some of the cases began to pass, but many of them still did not and there were even some cases that passed locally but not on Gradescope and vice versa, so I was quite confused. I made many changes to the logic and eventually resorted to using a separate array to keep track of the changes for the next iteration, which helped to pass a few more tests, but I was still missing some of them. I went to office hours to see what the issue could be and I realized with some help from the TAs that I had an issue with my indexing at the beginning and end of the array, which was causing issues in each following iteration due to the functions returning the wrong values. I ended up creating a system where it dealt with the 0th index, the indices from 1 to game_size - 2, and then the last index game_size - 1. By checking these and assigning values appropriately, I then was able to pass all the tests and deal with the various forms of input that the spec and the test cases indicated. Overall, I was relieved to successfully finish the PSET, but it definitely was one that required a lot of careful thinking about the logic. 