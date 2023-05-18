# Author
Marcus Lisman
mal249

# Estimate of time to complete assignment
1 hour

# Actual time to complete assignment
|     Date     | Time Started |     Time Spent |     Work completed|
|  1/20/2023   |      3:00 PM |     45 minutes |    read the assignment, wrote the program, and debugged until it met the spec
|  1/21/2023   |      2:45 PM |     40 minutes |  I worked on my makefile during this time. My knowledge of them was still a bit iffy, so I rewatched part of the lecture and looked at the notes from Professor Aspnes.
|  1/25/2023   |      2:30 PM |     15 minutes |  Based on changes to the spec and some of the little concepts that Professor Weide introduced in the 1/25 lecture, I made some minor changes to my code, specifically the scanf portion of the code.

| 1/29/2023    |      1:45 PM |     1 hour     | Based on the results of the autograder, I was failing the test where if the user hit enter and that was it, the program should not say "Hello, ". I had to make some changes and played around with scanf, but couldn't seem to figure it out, so I gave fgets a try and then used an if statement to check if the first character of the input was the newline character, and if it was, to exit the program with no errors. 


# Collaboration
I did not discuss my solution with anyone for this assignment.

# Discussion
An initial difficulty was reacquainting myself with command line arguments and how to properly use the inputs in the C program. I also had to make sure I got the syntax correct for the scanf function so I could use the user input and return it properly as part of the string. I got the program to work, but then had to redirect my attention to creating the makefile. I had some difficulty at this because my initial work was not creating an executable called Hello so I could use ./Hello, but after reviewing Professor Aspnes' notes, I was able to make a few changes and get the makefile to function as intended. Additionally, after the change to the spec that asked the program to accept inner whitespace, I had to figure out how to accept it within scanf, but after seeing Professor Weide do an example of something similar, I was able to make a small change to the code inside of the scanf function that would handle the inner whitespaces until the newlines. However, with that change, I was still missing out on one of the test cases, so I tried out the fgets function to still handle whitespaces, but be able to more effectively look for newline characters and configure the output to be what the autograder was looking for.
