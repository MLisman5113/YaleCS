#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef char* string;

int main(int argc, string argv[])
{
    
    // creates an empty string that can hold 128 characters (upper limit of name length, as indicated by the spec) 
    char name[129];
    
    // checks if number of command line arguments is greater than 1; if so, returns Hello, *input*
    // if number of arguments equals 1, then the program will prompt the user for their name and then print it after a series of checks and removing any trailing whitespace
    if(argc > 1)
    {
        printf("Hello, %s\n", argv[1]);
    } 
    else if(argc == 1)
    {
         printf("What is your name? ");

        // the specifications inside fgets reads the first 128 characters from stdin, including whitespaces
        fgets(name, 129, stdin);

        //if the first character from the stdin is the newline, the program will exit and not print any greeting
        if(name[0] == '\n')
        {
            exit(0);
        }
        else
        {
            //checks if the name finishes with a newline character, and if it does, it gets replaced with the null terminator and gets printed
            if (name[strlen(name) - 1] == '\n') 
            {
                name[strlen(name) - 1] = '\0';
            }
            printf("Hello, %s\n", name);
        }
    }

    return 0;
}
