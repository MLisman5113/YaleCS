#include <stdio.h>
#include <math.h>

int main(){

    double A = sqrt(9);
    double B = pow(2, 4); // exponents
    int C = round(3.14); // rounds up .5 and above, rounds down below .5 
    int D = ceil (3.14); // rounds up to nearest int
    int E = floor(3.99); // rounds down to nearest int
    double F = fabs(-100); // absolute value
    double G = log(3);
    double H = sin(45);
    double I = cos(45);
    double J = tan(45);

    printf("\n%d", C);

    return 0;
}