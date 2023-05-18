#include <stdio.h>
#include <stdbool.h>
#include <math.h>

int main(){
    int x = 5;
    int y = 2;

    float z = x / (float)y;

    int a = x % y;

    printf("%f\n", z);
    printf("%d", a);

    // augmented assignment operators = x = x + 1 --> x+=1

    int b = 10;
    //x = x + 2 --> x+=2
    // x-=2, x*=2, x/=2, x%=2
}