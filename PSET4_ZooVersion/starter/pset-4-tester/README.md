# Testing Script for Pset 4 (Train Conductor)
### Modified for CPSC 223 by Alan Weide &copy;2023

## Purpose
This folder contains various scripts and files needed to run a variety of test cases on a student's submission for Pset 4 (Train Conductor).

## Usage
The most important file in the folder is `tests.sh`, which should be executed to perform all available tests.
It can be executed as follows:
```
$ ./tests.sh [source_directory]
```

For example, if you'd like to use the directory `~/cs223/hw4` as the source directory, run the following command:
```
$ ./tests.sh ~/cs223/hw4
```

If `./tests.sh` results in a permission error, run either of the two following commands:
```
$ chmod +x tests.sh && ./tests.sh [source_directory]
```
or
```
$ source tests.sh [source_directory]
```

The first command adds the executable permission to the file `tests.sh` and then executes it.
The second command evaluates `tests.sh` as the source for a script, interpreting it line-by-line.

### The Script
When invoked without the `-h`/`-H` option, the `tests.sh` script performs the following steps:
1. Executes `make train-conductor` and reports and warnings or errors (testing is aborted if there any errors)
2. Runs several input/output test cases, checking their correctness with `diff`
3. Executes `valgrind train-conductor` and asserts there are no memory leaks (this step is skipped if Valgrind is not available on your system)
4. Executes `make unittest` (if no changes to `Makefile` have been made, this will not produce any errors)
5. Runs several unit tests and reports their results. See `unittest.cpp` for details of these tests.
6. Cleans up this directory by running `make clean`

Most of the output is redirected to files in the `output` directory.
Output from `make train-conductor` is redirected to `student.compile`.
Output from `./train-conductor` is redirected to `student.out`, and the generated files are also in the `output` directory.
Output from `diff` is redirected to `*.diff`.
Output from `valgrind` is redirected to `student.valgrind`.
Output from `make unittest` is redirected to `unittest.compile`.

### The Source Directory
The `source_directory` option is the directory in which your solution lives.
For this pset, make looks for the following files in that directory:
* `LinkedList.cpp`
* `Station.cpp`

The `source_directory` option is not required.
You could *copy* your solution's files into this directory, and invoke `tests.sh` without any arguments.
Doing so will tell make to search in the current directory for those two source files.
If you opt for this approach, you must **not** copy the following files:
* `Makefile`
* `train-conductor.cpp`
* `glx.txt`, if you modified it

### Delegation to `make`
Compilation of the `train-conductor` executable takes place by calling `make test-conductor` **in the current directory**, which is probably the same directory as `tests.sh`.
This recipe in this directory's `Makefile` is essentially the same as the one in the `Makefile` you were provided with the started code for this Pset, with some necessary modifications to account for the multi-directory structure of this testing harness.

If you have modified your starter `Makefile`, it's possible that this script will not compile your program correctly.
You are free to modify this `Makefile` as necessary to enable successful compilation, but note that it uses features of `make` that have not been covered in class and that you are therefore not expected to be familiar with.
If you'd like assistance fixing up this `Makefile` for your purposes, don't hesitate to reach out to one of the instructors or ULAs.

#### Header Files
The `train-conductor.cpp` and `unittest.cpp` files include header files that it searches for in the current directory: `LinkedList.h` and `Station.h` (and, indirectly, `NodeType.h`).
These files are identical to the header files in the starter code.
You may have to reconcile any modifications you've made to those files before this script will compile your program.
As with the `Makefile`, reach out to one of the instructors or ULAs for help if you need it.

## Example Invocation
Suppose your project looks like the following, and the current directory (`testing`) is marked by `*`:
```
~/cs223 /
    hw1 /
        ...
    hw2 /
        ...
    hw3 /
        ...
    hw4 /
        glx.txt
        LinkedList.cpp
        LinkedList.h
        Makefile
        NodeType.h
        Station.cpp
        Station.h
        train-conductor.cpp
        ...
    *   testing /
            glx.txt
            LinkedList.h
            Makefile
            README.md
            Station.h
            tests.sh
            train-conductor.cpp
            unittest.cpp
            ref /
                all_stations.txt
                output.out
                remove_some.txt
```

Further, assume you've already finished the assignment and your solution is perfect!
Here is the command you should run and expected output (on a system with valgrind installed):
```
$ ./tests.sh ~/cs223/hw4
~~compiling train-conductor~~
No errors or warnings!

~~running difftest~~
all_stations passed!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
remove_some passed!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output passed!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~running valgrind~~
==1022540== Command: ./train-conductor
==1022540== 
I just read and inserted 26 stations
Removed stations and printed to file
Done!
==1022540== 
==1022540== HEAP SUMMARY:
==1022540==     in use at exit: 0 bytes in 0 blocks
==1022540==   total heap usage: 57 allocs, 57 frees, 108,626 bytes allocated
==1022540== 
==1022540== All heap blocks were freed -- no leaks are possible
==1022540== 
==1022540== For lists of detected and suppressed errors, rerun with: -s
==1022540== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)

~~running unittest~~
test1 passed!
test2 passed!
test3 passed!
test4 passed!
test5 passed!
test6 passed!
test7 passed!
test8 passed!
test9 passed!
test10 passed!

~~cleaning up~~
rm -f unittest train-conductor
rm -f Station.o LinkedList.o
rm -f core* *~
```
