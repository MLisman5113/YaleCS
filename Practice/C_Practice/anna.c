#include <stdio.h>

int main()
{

    int current;
    int previous;
    int consumption;
    float bill = 0.0;

    printf("Enter the previous and current readings:");
    scanf("%d %d", &previous, &current);

    if(current < previous)
    {
        consumption = current + (10000-previous);
    }
    else
    {
        consumption = current - previous;
    }


    if(consumption <= 70)
    {
        printf("Current bill is $7.00");
    } 
    else if(consumption - 400 > 0)
    {
        bill = 7.0 + (100*0.05) + (230*0.025) + ((consumption - 400)*0.015);
    } 
    else if (consumption > 170 && consumption < 400)
    {
        bill = 7.0 + (100*0.05) + (consumption - 170)*0.025;
    }
    else if (consumption > 70 && consumption < 170)
    {
        bill = 7.0 +(consumption - 70)*0.05;
    }

    printf("Current bill is $%4.2f\n", bill);

    return 0;
}