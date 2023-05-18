#include <stdio.h>

int main(){
    int x; // declaration
    x = 123; // initialization

    int y = 321;
    int age = 19; //integer

    float gpa = 4.0; //floating point number
    char grade = 'A'; //single character
    char name[] = "Marcus"; //strings are represented by strings of characters

    printf("Hello %s\n", name);
    printf("You are %d years old.\n", age);
    printf("Your average grade is %c\n", grade);
    printf("Your GPA is %f\n", gpa);
    return 0;
}