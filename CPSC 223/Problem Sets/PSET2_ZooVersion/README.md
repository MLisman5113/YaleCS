# CPSC 223 SPRING 2023 PSET 2: Game of Life
## Due Thursday, February 10th at 11:59pm
## Submission checklist 
Your final submission must have the following files: 
* `life.c`
* `life.h`
* `main.c`
* `makefile` (or `Makefile`)
* `LOG.md` (see the section about your [Log File](#log-file) below)
When you submit these files, submit them either as a `.zip` file containing *only* 
the files themselves, and not a folder with the files in them, or indvidually to 
Gradescope.
## Background
In this assignment, you will design and write a C program for a one-dimensional 
version of the [Game of Life](https://en.wikipedia.org/wiki/Conway
%27s_Game_of_Life).
The basic idea of the Game of Life is that cells in a grid are used to simulate 
biological cells.
Each cell is either alive or dead.
At each step of the simulation, each cell’s current status and its number of living
neighbors are used to determine the status of the cell for the next step of the 
simulation.  
Typically, the Game of Life is set up as a two-dimensional grid.
In this assignment you will build a one-dimensional version that has $N$ cells 
numbered $0$ through $N-1$.
Your grid will be stored in a **statically-allocated array**.
Each cell $i$ is adjacent to cells $i - 1$ and $i + 1$.
There are two exceptions: cell $0$ is adjacent only to cell $1$, and cell $N-1$ is 
adjacent only to cell $N-2$.
A live cell has value $1$ and a dead cell has value $0$.
At each step of the simulation, the cell values at that step determine what changes
will occur at the next timestep as follows: 
* If a live cell $i$ has two live neighbors, then cell $i$ will die
* If a live cell $i$ does not have two live neighbors, then any dead neighbors of 
cell $i$ will become alive
> **Note**: for all interior cells, two neighbors need to be examined.
> For the first and last cell, there is only one neighbor to examine, and the rules
above still apply (this has the effect that once alive, edge cells can never die).
Consider the state with 10 cells:
```
0111010101
```
* Cell 0 is dead; it stays dead. 
* Cell 1 is alive; it has a dead neighbor in cell 0, so cell 0 becomes alive in the
next timestep.
    It does nothing to cell 2.  
* Cell 2 is alive; it has two alive neighbors, so cell 2 dies in the next timestep.
* Cell 3 is alive; it has a dead neighbor in cell 4, so cell 4 becomes alive.
    (It treats cell 2 as still "alive", since that was the cell’s state when this 
timestep started, and does not do anything to it) 
* Cell 4 is dead; it stays dead (again, based on the current timestep!)
* Cell 5 is alive; it has two dead neighbors, so both cell 4 and cell 6 become 
alive.
* Cell 6 is dead; it stays dead.
* Cell 7 is alive; it has two dead neighbors, so both cell 6 and cell 8 become 
alive.
* Cell 8 is dead; it stays dead.
* Cell 9 is alive; it has a dead neighbor in cell 8, so cell 8 becomes alive.
So at the next step of the simulation, the state would be:
```
1101111111
```
After another simulation step, then the state would be:
```
1111000001
```
Work through this example by hand to make sure you understand the rules for cell 
modification.
 
## The Assignment 
You will submit `main.c` (which we'll call the "driver"), `life.h` ("interface"), 
`life.c` (implementation), `makefile`, and `LOG.md` files for this assignment.
The point of this assignment is to build your understanding of statically-alocated 
memory, so **you may not use dynamic memory allocation anywhere in your program: 
that means you may not use `malloc` or `calloc`!**
`life.h` must contain declarations for at least the following two functions: 
* ```C
  bool isAlive(int array[], size_t index, size_t size);
  ```
    The `isAlive` function takes as arguments an array of `int`s called `array`, an
index `i`, and the size of the array (`size`).
    It returns `true` if the cell at position `i` is alive, otherwise returns 
`false`.
    Note that `bool`, `true` and `false` are not keywords in C, so you may 
`#include <stdbool.h>`, which contains definitions for those two values and the 
type
* ```C
  bool shouldDie(int array[], size_t index, size_t size);
  ```
    The `shouldDie` function takes as arguments an array of `int`s called `array`, 
an index `i`, and the size of the array (`size`).
    It returns `true` if cell `i` has two live neighbors; otherwise it returns 
`false`.
    > **Hint**: Checking for neighbors that don’t exist (*e.g.*, things at index `-
1` or at an index equal to `size`) will cause an error.
    > Check your indexes before using them! 
`life.c` must contain an *implementation* for each function delcared in `life.h`.
`main.c` should contain a single function with the following signature:
```C
int main(int argc, char* argv[])
```
This function should accept three command-line arguments, which will appear in the 
following order:
* `int time_steps`: how many "generations" the simulation will run for.
    It should be nonnegative.
    Use a low value *e.g.*, 1 or 2 as you write and test your code, and increase it
after you confirm expected outputs for the lower values.
    We will test your program on arbitrarily large values of `time_steps` (within 
the range of type `unsigned int`).
* `int game_size`: the size of your Game of Life array.
    It should be positive.
* `start`: a string consisting of the characters `'0'` and `'1'`, of length 
`game_size`, representing the start state for this run of Game of Life.
Thereafter, your `main` function must create a new statically-allocated array (that
is, you may *not* use `malloc`, or `calloc`), using `game_size` for the size of the
array.
Using this array: 
* Print the initial values held in the array (they must match what was entered as 
the third command-line argument)
* Run the game `time_steps` times, printing the array at the end of each step (so 
it looks like the examples in the [sample runs](#sample-runs) below)
`makefile` must have, as its *first target*, a rule to create an executable called 
`Life`, which when executed runs the `main` function implemented in `main.c`.
The name of the target must be "`Life`".
`LOG.md` must have the same format as that described in Pset 0 ("Hello, Jack").
Those requirements are reproduced at the end of this document.
## Output format
The first line of ouptut must have the string "Initial values:" followed by a 
comma-separated list of the initial cell values enclosed in `'['` and `']'`, 
beginning on column 34.
Thereafter, each line of output must have the string "Values at timestep N" (for 
some N, starting at 1 and increasing by 1 per line) followed by a comma-separated 
list of the cell values at that timestep enclosed in `'['` and `']'`, beginning on 
column 34.
## Assumptions You May Make
**None!**
We will test your code both on "nice" inputs that satisfy your expectations about 
what the input looks like, but we will also test your code on inputs that violate 
those expectations, including:
* No or too few command-line arguments
    * Your program must exit with a nonzero status code, but must not cause any 
system errors such as a segmentation fault
* Too many command-line arguments
    * Your program must attempt to interpret the first 3 arguments as the valid 
ones, and ignore the others
    * Only if there is another issue with the first three arguments should your 
program exit with a nonzero status code
* Command-line arguments that cannot be converted to `int`s
    * Your program must exit with a nonzero status code, but must not cause any 
system errors such as a segmentation fault
* A negative number for `time_steps` or a nonpositive number for `game_size`
    * Your program must exit with a nonzero status code, but must not cause any 
system errors such as a segmentation fault
* A `game_size` argument that does not match the length of the `field`
    * If `game_size` is less than the length of `field`, your program must 
interpret the first `game_size` characters of `field` as the real field and ignore 
the rest
    * If `game_size` is greater than the length of `field`, your program must exit 
with a nonzero status code, but must not cause any system errors such as a 
segmentation fault
* A `field` that contains characters other than `'0'` and `'1'`
    * Your program must exit with a nonzero status code, but must not cause any 
system errors such as a segmentation fault
* Other weird inputs that I have not thought of yet
    * Your program should attempt to recover (*e.g.*, by ignoring extra values)
    * If it cannot, it must exit with a nonzero status code but must not cause any 
system errors such as a segmentation fault
## Comments and Coding Style 
Make sure all your code is well-commented and readable.
In particular, make sure to have: 
* good variable names 
* high level comments that explain what the program is doing or what it is 
implementing 
* lower level comments that explain how particular elements of the program are 
implemented *if the implementation is not obvious*
* please look at the style guide for further style suggestions, which has been 
shared via Canvas
# Hints and Advice 
Before you do any coding, complete this design planning exercise by carrying out 
the following steps: 
1. Reread the gameplay instructions and consult the sample runs below until you 
understand exactly what will change from one time step to the next
2. Determine what data is involved, based on the problem description 
3. Write out a high level program outline 
4. Write more refined pseudocode within the outline, sketching out each function in
pseudocode 
5. Write more refined pseudocode for the main function 
6. Then (and only then!) start turning your pseudocode into real code.
    Compile and test your program often, maybe as frequently as after each line of 
code!  
7. As you test your code, unexpected things will occur!
    Add print statements to inspect variable values to help understand what your 
program is doing or&mdash;better&mdash;use [GDB](https://www.sourceware.org/gdb/) 
(if you're on the Zoo or another Linux machine, including WSL on Windows) or [LLDB]
(https://lldb.llvm.org/) (if you're on a Mac).
If you feel that adding more functions in addition to the ones outlined in this 
overview would help your program, you are welcome to do so.
If these extra functions are called from `main`, they should be declared in 
`life.h` and implemented in `life.c`.
If these extra functions were useful only in the implementations of your other 
`life.h` functions, they should not be declared in `life.h` and instead *only* 
exist in `life.c` (you may find it useful to separate their *declaration* from 
their *implementation*, even within the same file, but you are not required to do 
so).
Be sure to note any additional functions you have implemented in your `LOG.md` 
file, and ensure they are well-commented (*i.e.*, there must be an English-language
description of their behavior adjacent to their declaration; complicated functions 
should have comments in the code, too).
By itself, the C programming language does not provide many functions you can call.
Most of the useful functions for this assignment are in `stdlib.h`, which you 
should `#include` in `main.c` and maybe also in `life.h` or `life.c`, depending on 
how you have structured your program.
One such function, `int atoi(const char* s)` returns the `int` that is represented 
by the string `s` interpreted as a decimal integer.
It has the following weird behavior: if the string is not a valid representation of
an `int`, the function returns `0`.
## Sample Runs 
To aid your testing, multiple sample runs are shown below.
Before you begin to write any code, it is crucial that you can replicate these by 
hand (given the initial values, carry out the next 2, 3, or more timesteps).
### Example A:
```
$ ./Life 2 5 10001
Initial values                   [1, 0, 0, 0, 1]  
Values after timestep 1          [1, 1, 0, 1, 1] 
Values after timestep 2          [1, 1, 1, 1, 1] 
```
### Example B
```
$ ./Life 2 5 00100
Initial values                   [0, 0, 1, 0, 0] 
Values after timestep 1          [0, 1, 1, 1, 0] 
Values after timestep 2          [1, 1, 0, 1, 1] 
```
### Example C
```
$ ./Life 3 5 00111
Initial values                   [0, 0, 1, 1, 1] 
Values after timestep 1          [0, 1, 1, 0, 1] 
Values after timestep 2          [1, 1, 1, 1, 1] 
Values after timestep 3          [1, 0, 0, 0, 1]
```
### Example D
```
./Life 10 10 1010011111
Initial values                   [1, 0, 1, 0, 0, 1, 1, 1, 1, 1] 
Values after timestep 1          [1, 1, 1, 1, 1, 1, 0, 0, 0, 1] 
Values after timestep 2          [1, 0, 0, 0, 0, 1, 1, 0, 1, 1] 
Values after timestep 3          [1, 1, 0, 0, 1, 1, 1, 1, 1, 1] 
Values after timestep 4          [1, 1, 1, 1, 1, 0, 0, 0, 0, 1] 
Values after timestep 5          [1, 0, 0, 0, 1, 1, 0, 0, 1, 1] 
Values after timestep 6          [1, 1, 0, 1, 1, 1, 1, 1, 1, 1] 
Values after timestep 7          [1, 1, 1, 1, 0, 0, 0, 0, 0, 1] 
Values after timestep 8          [1, 0, 0, 1, 1, 0, 0, 0, 1, 1] 
Values after timestep 9          [1, 1, 1, 1, 1, 1, 0, 1, 1, 1] 
Values after timestep 10         [1, 0, 0, 0, 0, 1, 1, 1, 0, 1] 
```
## Log file
Your `LOG.md` file should be a [markdown](https://www.markdownguide.org/) file of 
the general form (that below is mostly fictitious):
```markdown
# Author
Alan Weide 
adw58
# Estimate of time to complete assignment
10 hours
# Actual time to complete assignment
| Date | Time Started | Time Spent | Work completed |
| :--: | -----------: | ---------: | :------------- |
| 8/01 |      10:15pm |       0:45 | read assignment and played several games to 
help me understand the rules. |
| 8/02 |       9:00am |       2:20 | wrote functions for determining whether a roll
is three of a kind, four of a kind, and all the other lower categories |
| 8/04 |       4:45pm |       1:15 | wrote code to create the graph for the 
components |
| 8/05 |       7:05pm |       2:00 | discovered and corrected two logical errors; 
code now passes all tests except where choice is Yahtzee |
| 8/07 |      11:00am |       1:35 | finished debugging; program passes all public 
tests |
|      |              |            |                |
|      |              |       7:55 | total time spent |
# Collaboration
I discussed my solution with: Petey Salovey, Biddy Martin, and Biff Linnane (and 
watched four episodes of Futurama).
# Discussion
Debugging the graph construction was difficult because the size of the graph made 
it impossible to check by hand.
Using asserts helped tremendously, as did counting the incoming and outgoing edges 
for each vertex.
The other major problem was my use of two different variables in the same function 
called _score and score.
The last bug ended up being using one in place of the other; I now realize the 
danger of having two variables with names varying only in punctuation -- since they
both sound the same when reading the code back in my head it was not obvious when I
was using the wrong one.
```
Specifically, it must contain...
* Your full name and netID, each on their own line in a section with header "`# 
Author`"
* Your estimate of the time required (made prior to writing any code) in a section 
with header "`# Estimate of time to complete assignment`"
* The total time you actually spent on the assignment, formatted as you see 
fit[^1], but must contain each "shift" during which you worked on the assignment 
and a brief description of the work completed in each shift, in a section with 
header "`# Actual time to complete assignment`"
* The names of all others (but not members of the teaching staff) with whom you 
discussed the assignment for more than 10 minutes, in a section with header "`# 
Collaboration`", and
* A brief discussion (~100 words) of the major conceptual and coding difficulties 
that you encountered in developing and debugging the program (and there will always
be some), in a section with header "`# Discussion`", which must be the last section