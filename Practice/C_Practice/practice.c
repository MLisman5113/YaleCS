#include <stdio.h>
#include <string.h>

int main()
{
    char name[25]; //bytes

    char* anna = "Anna";

    printf("What's your name? ");
    scanf("%s", &name);

    if(strcmp(name, anna) == 0)
    {
        printf("Fuck off.\n");
    }
    else{
        printf("\nHello %s, have a great day!\n", name);
    }

    return 0;
}