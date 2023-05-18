#include <stdio.h>
#include <string.h>

typedef char* string;

int main(int argc, string argv[])
{
    
    // creates an empty string that can hold 128 characters (upper limit of name length, as indicated by the spec) 
    char name[129];
    
    // checks if number of command line arguments is greater than 1; if so, returns Hello, *input*
    // if number of arguments equals 1, then the program will prompt the user for their name and then print it 
    if(argc > 1)
    {
        printf("Hello, %s\n", argv[1]);
    } 
    else if(argc == 1)
    {
        printf("What is your name? ");

        // the specifications inside scanf reads in first 128 characters unless a newline character comes before that
        scanf("%128[^\n]s", &name);
        printf("Hello, %s\n", name);
    }

    return 0;
}
