# Pset 3.5: Pirate Profiles

### Due Fri, Mar 10 2023

This assignment builds on the other HookBook assignment, specified in [README (Part 1).md](README%20(part%201).md).
Follow those instructions before proceeding with this portion of the assignment.

**Move your entire solution to the first part of the HookBook assignment into a folder named `hookbook_1`, and create a second folder, `hookbook_2`, which will contain your solution to this part of the assignment. You should copy all files from `hookbook_1` into `hookbook_2` before beginning.**

In this portion of the HookBook assignment, you will be expanding upon your previous program by adding more flexibility and information to your collection of pirates.

These pieces of information are:
1. The pirate's name
1. The pirate's current captain
1. The name of the pirate's current vessel of employ
1. The number of treasures the pirate has collected
1. A list of skills the pirate posesses

You must write an application that reads data from **two** different text files&mdash;one containing pirate profile information and another containing pirate/captain pairs&mdash;add those pirates to a list, sort that list *according to an order defined at run-time*, and then print the pirates' information to `stdout`.

The application must accept the following command-line arguments (in this order):
1. The name of a (text) file containing pirate profiles
1. The name of a (text) file containing pirate/captain pairs
1. One of `-n`, `-v`, or `-t`, identifying the order by which to sort the pirates
    * If `-n` is specified, the output of the pirates must be sorted in increasing lexicographic order by the pirate's name
    * If `-v` is specified, the output of the pirates must be sorted in increasing lexicographic order by the pirate's current vessel of employ
    * If `-t` is specified, the output of the pirates must be sorted by *decreasing* order of the number of treasures the pirate has collected

## Input Specification
The input to your program is two text files, passed by their file names at the command line.

### Pirate Profiles
The first file will contain many pirate profiles, each beginning with a pirate's name on a line beginning with the label "`name`" followed by a colon (`':'`).
Each subsequent line of a profile contains a label followed by a colon (`':'`) and then the value for that label.
The possibilities for these lines are as follows:
* The pirate's job title, with label "`title`"
* The pirate's current vessel of employ, with label "`vessel`"
* The pirate's favorite port of call, with label "`port`"
* The number of treasures the pirate has collected, with label "`treasure`"
* Zero or more skills this pirate posesses, each on its own line with the label "`skill`"

The next profile starts at the next line labeled `name`.

### Pirate/Captain Pairs
The second text file will identify the captain under which each pirate is currently sailing.
Each pirate/captain pair will be on a single line, with the two names separated by a single forward slash (`'/'`)&mdash;the first name is the underling and the second name is their captain.

### Assumptions
There are several assumptions you may make about the structure of the input files:
* If it exists, the file containing pirate profiles is properly formatted, that is:
    * Every line has the form `<label>:<value>`
    * Every non-`name` labeled line is meant to be associated with the pirate whose name appeared most recently in the file.
        > **Corollary**: the first line of the file is a pirate's name.
    * Neither the label nor value on any line is longer than $64$ characters, nor will any label or value contain `':'`.
    * The value associated with the `treasure` for every pirate is a decimal integer between $0$ and $(2^{31} - 1)$.
* If it exists, the file containing pirate/captain pairs is properly formatted, that is:
    * Every line has the form `<pirate-name>/<captain-name>`
    * Every name in the file is the name of a pirate with a profile in the other file
    * No name of a pirate will contain `'/'`

### Anomalies
There are several anomalies that your program must handle:
* The first two command-line arguments do not necessarily refer to text files that exist and are readable by your program.
If either of the files is cannot be opened, your program must print a message to `stderr` and exit with status code `1`.
The error message must be `"Invalid filename: "` followed by the value of the command-line argument that caused the error, followed by a newline.
    * If *both* files are unopenable, then the *first* filename should be displayed as the invalid one, and the second one should be ignored.
* The third command-line argument could be anything.
If it is not one of `-n`, `-v`, or `-t`, your program must print a message to `stderr` and exit with status code `1`.
The error message must be `"Invalid argument: "` followed by the value of the command-line argument that caused the error, followed by a newline.
* The program may be invoked with fewer than 3 command line arguments, in which case your program must print the string `"Invalid arguments"` followed by a newline to `stderr` and exit with status code `1`.
* The program may be invoked with more than 3 command-line arguments, in which case your program must ignore any argument after the third.
* Except that the first line of a profile is the pirate's name, no order is defined among the fields in a pirate's profile.
* There may be some pirates that are missing a field in their profile (for example, a pirate that is unemployed may not have a vessel in their profile).
* Some lines may have a label that is not one of `name`, `title`, `vessel`, `port`, `treasure`, or `skill`.
Such lines should be ignored.
* There may be several pirate profiles that share a name, in which case only the profile for the *first* pirate with a given name must be stored in the list of pirates.
* There may be duplicate labels within a single profile (except for `name`).
In this case only the *last* value for a particular label must be persisted in the pirate's profile.
    > **Note**: Skills are an exception to this, in that *every* listed skill must be persisted to the pirate's profile
* There may be duplicate skills listed for a given pirate.
In this case, duplicate skills are to be interpreted as increased expertise by that pirate in that skill (the number of occurences of a particular skill is that skill's "rating"), and the rating of a skill must be persisted in the pirate's profile.
* Not all pirates with a profile will be party to a pirate/captain pair
* A pirate may be on the left-hand side of several pirate/captain pairs.
In this case only the *last* appearance of a pirate on the left-hand side of a pair should be persisted in your application
* It may be the case that the captain of one pirate also is the underling to a different captain.
*Both* of those relationships must be persisted in your application (so-called "transitive captainships" of more than two degrees must also be persisted).
    * These kinds of relationships may even be cyclical!
    Your program must handle this possibility.
* If you encounter any other anomaly in the command-line arguments or input that is not explicitly forbidden by the [assumptions](#assumptions), your program must exit with status code `1` and must not cause a system error such as a segmentation fault.

## Output Specification

The output of your program must be the list of pirate profiles, sorted according to the third command-line argument, each followed by a blank line.
Each pirate profile must have the following format:
```
Pirate: <pirate-name>
    Title: <pirate-title>
    Captain: <captain-name>
        Captain's Title: <captain-title>
        Captain's Favorite Port of Call: <captain-port>
    Vessel: <pirate-vessel>
    Treasure: <pirate-treasure>
    Favorite Port of Call: <pirate-port>
    Skills: <skill-0> <skill-0-rating>
            <skill-1> <skill-1-rating>
            <skill-2> <skill-2-rating>
            [...and so on]

```

In other words, the output for each pirate profile must begin with a line containing the text `"Pirate: "` followed by the pirate's title and name (do not print `<` or `>`).
Thereafter, each line must be indented by **4 spaces**, and contain&mdash;*in order*&mdash;the pirate's title (labeled `"Title: "`), the profile of the pirate's captain (labeled and indented as above), the pirate's vessel of employ (labeled `"Vessel: "`), the pirate's treasure count (labeled `"Treasure: "`), and the pirate's favorite port of call (labeled `"Favorite Port of Call: "`).
After those fields, there must be a list, labeled `"Skills: "`, containing all of the pirate's skills and each skill's "rating", with each skill and rating separated by a single space and followed by a newline, and the skills must be left-aligned with one another (a total of **12 spaces** from the beginning of the line).
The rating must displayed as as series of asterisks (`'*'`), with the number of asterisks matching the skill's rating.
The skills in the list must be sorted in increasing lexicographic order, and there must be only one occurrence of each skill displayed in the output.

For example, if a pirate's list of skills has 3 occurrences of "swashbuckling" and 1 ocurrence of "good with kids", the output would have the following lines:
```
    Skills: good with kids *
            swashbuckling ***
```

If there is any field that was not given a value in a pirate's profile, the text `"(None)"` must be displayed on the corresponding line.
If a pirate has no captain, then the lines containing the captain's title and favorite port of call must not be present at all.

For example, Blackbeard's profile might be displayed like this:
```
Pirate: Blackbeard
    Title: Captain
    Captain: (None)
    Vessel: Queen Anne's Revenge
    Favorite Port of Call: New Providence
    Skills: intimidation ******
            leadership ***
            swashbuckling *
```

> **Note**: It is a [requirement](#requirements) that each pirate's profile is printed in $O(s)$ time where $s$ is the *number of skills posessed by that pirate*.
> Among other things, this means that you *may not* search the list of pirates for the captain's name each time you print a pirate's profile.

## Efficiency and Source Code Requirements

Beyond correctness with regard to the [output specification](#output-specification) above, there are several other benchmarks your solution must pass to earn full credit on this assignment.
1. Creating a pirate from a profile in the input file must take no more than $O(s)$ time, where $s$ is the number of skills (including duplicates) the pirate poseses.
    * There is some subtlety here: the input specification does not forbid arbitrarily many lines of input being associated with one pirate, due to its allowance of duplicates.
    The time bound for creating a pirate applies *only* for pirate profiles that have no duplicate non-skill entries (profiles with duplicate non-skill entries must meet no particular time bound for their instantiation).
    > **Note**: While the rating for each skill must be persisted, pay careful attention to this complexity requirement when deciding precisely *how* to persist skill ratings.
    > An implication of this time bound is that each skill from input must be persisted in constant ($O(1)$) time.
1. Sorting the list of pirates must require no more than $O(n^2)$ comparisons, where $n$ is the number of pirates in the list, *no matter which field is used to sort it*.
1. Printing a pirate's profile must take no more than $O(s^2)$ time, where $s$ is the number of skills the pirate posesses.
1. You are required to make minimal modifications to the existing `pirate_list.h` header file.
In particular, you may only add at most one parameter to at most one function in the file, and you must modify that function's comment to account for this change&mdash;if you make any changes at all.
    * You may make any modifications you want to your `pirate_list.c` source file, including the removal of print statements regarding the expansion and contraction of your list.
    Any modifications you make to source code *must* be reflected in relevant comments.
1. If your program completes successfully, it must release all resources that was acquired over the course of execution, including:
    * It must close every file that it opened, and
    * It must free all memory that it allocated
1. Style penalties will be applied to submissions in which it is clear that little to no care was taken in part 1 to enable the kind of extension required in this assignment (part 2), and therefore that part 1 is *substantially different* from part 2.
Part 2 is designed such that it can be solved with 75&ndash;100 additional lines of code on top of a good solution to Part 1 of the HookBook assignment.
    * Use those numbers as a guide, but don't worry if you can't get your line count all the way down to 75, and definitely do not "minify" your code to reach 75 added lines.
    Lines of code (LOC, or SLOC if you exclude comments) is only one metric for determining code quality and complexity, and it is quite a bad metric for both.

## Recommendations

Except for the efficiency and source code requirements above, the rest is up to you.
Here are some recommendations to help you tackle this assignment.
* Although it is certainly not the only option, you might consider implementing your input digestion algorithm as a [finite-state machine (FSM)](https://en.wikipedia.org/wiki/Finite-state_machine)
    * Instead of a FSM, you might consider instead factoring out code to read a pirate's profile into a `read_profile(infile, ...)` function.
    This poses its own set of challenges.

    > **Note**: As with many other aspects of programming (pointers, project structure, object inheritance, system architecture, networks, ...), a finite-state machine is best understood by *drawing a picture* of it.
    > We strongly encourage you to draw the state diagram of a FSM that would process the input as specified in this document before reading any further.
    > Then, you can match your drawing to the skeleton state machine implemented below.
    ---

    > Although we have not discussed FSMs in class, they have a reasonably straightforward structure when implemented in C.
    > Typically, the implementation of a FSM begins with the definintion of possible states as an `enum` (enumeration), which defines a type with a fixed, finite set of possible values.
    > For this problem, it might look similar to the following:
    > ```C
    > typedef enum
    > {
    >     PROFILE_BEGIN_STATE, PROFILE_CONTENTS_STATE
    > } input_state;
    > ```
    >
    > Then your transition function is implemented as a loop, each iteration of which you decide which state should come next based on the last input.
    > That might look like the following (which is not complete for obvious reasons):
    > ```C
    > input_state current_state = PROFILE_BEGIN_STATE;
    > read_line_from_file(...);
    > while (/* not at end of file */)
    > {
    >     switch (current_state)
    >     {
    >     case PROFILE_BEGIN_STATE:
    >         // We must have just read a "name:<pirate-name>" line. Start a new pirate profile.
    >         current_pirate = create_pirate(value);
    >         // We're now inside of a pirate's profile, so switch states to PROFILE_CONTENTS_STATE.
    >         current_state = PROFILE_CONTENTS_STATE;
    >         break;
    >     case PROFILE_CONTENTS_STATE:
    >         // We are reading the contents of a pirate's profile. Decide if we're done.
    >         read_line_from_file(...);
    >         if (/* we just read a name, which starts a new profile */)
    >         {
    >             // We're done with this profile. Change state to PROFILE_BEGIN_STATE to start a new profile.
    >             current_state = PROFILE_BEGIN_STATE;
    >         }
    >         else
    >         {
    >             // We're still on the same profile. Store this field with the pirate and remain in PROFILE_CONTENTS_STATE.
    >             store_pirate_field(current_pirate, label, value);
    >         }
    >         break;
    >     default:
    >         break;
    >     }
    > }
    > ```
    > 
    > The `switch` statement is a new statement type we have not discussed in class.
    > Within a `switch` statement, the `case` containing the value equal to the value of the switch parameter is executed.
    > Statements following that case label are executed until a `break` statement is reached.
    > The `default` case is executed when the value of the switch parameter does not match any of the case values.
    > It is not required when the cases are exhaustive of all possibilities, but is considered best practice to include.
    > Here are some resources to help you understand it better:
    > * [Prof. Aspnes' Notes](https://www.cs.yale.edu/homes/aspnes/classes/223/notes.html#conditionals)
    > * [cppreference.com](https://en.cppreference.com/w/c/language/switch)
    > * [Wikipedia](https://en.wikipedia.org/wiki/Switch_statement)

* Define and implement a type for a "list of strings" to hold each pirate's skills.
Pay careful attention to the runtime of the insertion operation!
    * This new type could be a slight modification of your `pirate_list` type, or it could be entirely different.
    * You might instead consider implementing a *generic* list type that can be used for both the pirates and their skills.
        > **Note**: If you choose to implement a generic list type, you may use it to replace `pirate_list`, and you may ignore the modification rules surrounding that file.
        > You might, however, find it challenging to correctly implement and integrate such a generic list into your solution for Part 1 within the time constraints of this assignment.

## Correctness

Your solution will be assessed for correctness according to the input/output specification above.
To aid you in your self-assessment of correctness, we will release a limited set of test cases against which you can confirm things like input and output format specifics, but the test cases will not be exhaustive and you should supplement them by devising more on your own.

Your code will also be tested against an autograder running on Gradescope's servers.
In the event that your code produces output from the autograder that does not match what you expect&mdash;or if the Gradescope autograder simply does not cooperate&mdash;your submission will be run on the Zoo, which in such a case will be treated as the "official" behavior of your code.
**It is therefore imperative that you test your program on the Zoo to confirm its behavior is correct.**

## Submission

This assignment is due **Friday March 10, 2023 at 11:59 PM NHT (New Haven Time)**.
You must submit your solution by uploading the following items or a `.zip` file containing the following items to Gradescope by that deadline for full credit.
* A folder named `hookbook_1`, which contains your solution to [Part 1](README%20(part%201).md) of the assignment, with the prescribed files
    * The `hookbook_1` folder must, in addition to other files, contain a `LOG.md` file, containing the information prescribed for the log file in earlier assignments, except that you do not need an exact account of all hours worked&mdash;especially if you have already completed Part 1 of this assignment
* A folder named `hookbook_2`, which contains your solution to Part 2 (this part) of the assignment.
Within that folder, there must be (at least) the following files:
    * `makefile` (or `Makefile`), containing a target named `HookBook` that generates an executable named `HookBook` that, when run, satisfies the requirements outlined in this document
    * `LOG.md`, containing the information prescribed for the log file in earlier assignments
    * All files required to compile and run your program

---
## Disclaimer

**Any apparent contradiction in this document is unintentional.**
We always do our best to keep these documents as unambiguous as possible, but as with all complex things small pieces sometimes fall through the cracks.
Before reaching out to an instructor, ULA, or on Ed about a perceived contradiction in this spec, first read this document very carefully and see if you just missed the clarification elsewhere, and then reflect on what you believe our *intent* was when writing this document. Only if it is still not clear, seek assistance on the matter after you have taken those two steps.
A good rule of thumb in judging our intent is that if there are several possible interpretations of some item in this spec, the one that leads to the *more elegant solution* is the one we meant&mdash;our goal is not to overwhelm you with tedium.
In any such case, even if our intent is clear, we urge you to note the ambiguity in your `LOG.md` file you submit with your program.
Doing so helps us in two ways: first, so we can better understand why you might have made a decision that differs from other students, and second, so that we can disambiguate a future version of this assignment.

### Pirate Skills
Here is a non-exhaustive list of the skills your pirates posess:
* marksmanship
* swashbuckling
* cannon loading
* pickpocketing
* lockpicking
* knot tying
* cooking
* navigating
* charting
* shanty singing
* whip cracking
* grog guzzling
* rum running

---
&copy;2023 Alan Weide and Ozan Erat
