# Author
Marcus Lisman
mal249

# Estimate of time to complete assignment
5

# Actual time to complete assignment
|     Date     | Time Started |     Time Spent |     Work completed|
| 3/30/23      |       3:00PM |         1 hour |    Read spec, loaded in files, began playing around with building a solution, completed the Station class
| 4/1/23       |       6:30PM |        2 hours |   Worked on the functions for the LinkedList class and successfully finished them. I went through, added some comments, and tested my code using the script provided. My solution passed all the tests, had no memory leaks, and exactly matched the sample output in the README that indicated what to expect if the output was successful.
| 4/2/23       |      12:00PM  |    1 hours |  I wrapped up the assignment by adding a few more comments and making sure my solution was in line with the style guide. I also had to make a change to how I calculated my distance after using the updated testing script and finally got an output that passed the tests and worked perfectly with the local autograder. I then submitted it to Gradescope.

# Collaboration
I did not discuss my solution with anyone else in the class. 

# Discussion
This assignment was much more straightforward compared to HookBook. Two technical issues that I faced while working on this problem set was acclimating myself to C++ syntax compared to C syntax and making proper use of the NodeType struct and public versus private variables. The print format for C++ was something I had to play around with a bit, but I eventually figured out how to print out the input in the specified input according to the spec. Additionally, at first I was getting a lot of errors with my nodes and pointers and didn't really know what was going on. However, after looking through the code, I found that the nodes used a specific struct type that was more useful for processing stations in the linked list. I changed my nodes to the correct struct type and changed the field selectors, and after making these changes, my code worked and I was able to move on to testing it out. After receiving the updated testing script on 4/2/23, I had to make a change to how I calculated my distance, which I changed to use getLength(). After this change, my solution matched that of the testing script and passed all the tests and valgrind. Structurally, putting together the linked list in functions we had to fill out rather than doing everything from scratch was much easier to code and to conceptually understand. 
