#include <stdio.h>
#include <string.h>

int main(){

    char name[25]; //bytes
    int age;

    printf("What's your name? ");
    //scanf("%s", &name);
    fgets(name, 25, stdin); // allows us to read whitespaces
    name[strlen(name) - 1] = '\0'; // gets rid of the whitespace at the end of the string

    printf("How old are you? ");
    scanf("%d", &age); // read user input

    printf("\nHello %s, how are you?\n", name);
    printf("You are %d years old.\n", age);

    if(age >= 18)
    {
        printf("Congratulations, %s! You are now signed up!\n", name);
    }
    else if(age < 0)
    {
        printf("You haven't been born yet!");
    }
    else if(age == 0)
    {
        printf("You can't sign up %s, you were just born!\n", name);
    }
    else
    {
        printf("Sorry %s, you are too young to sign up!\n", name);
    }

    return 0;
}