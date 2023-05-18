#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "life.h"

int main(int argc, char* argv[])
{
    // checks if there are less than 4 command line arguments and exits if so
    if(argc < 4)
    {
        return 1;
    }

    // sets time_steps to the 1st user-inputted command line argument (not the program name), game_size to the 2nd, and start to the 3rd 
    int time_steps = atoi(argv[1]);
    int game_size = atoi(argv[2]);
    char *start = argv[3];

    // if time_steps is negative or game_size is negative or equal to 0, program exits
    if(time_steps < 0 || game_size <= 0)
    {
        return 1;
    }

    // if game_size exeeds the string to be analyzed, program exits
    if(game_size > strlen(start))
    {
        return 1;
    }

    //creates array of ints of size game_size
    int array[game_size];

    int iteration_count = 0;
    int zero_one_count = 0;

    // loops through to check if each character in the array is equal to 0 or 1 
    // first by subtracting ASCII value and then adding to zero_one_count if 0 or 1, exiting if not
    for(int i = 0; i < game_size; i++)
    {
        array[i] = start[i] - '0';
        if(array[i] == 0 || array[i] == 1)
        {
            zero_one_count++;
        }
        else
        {
            return 1;
        }
    }

    // prints the initial values only if the zero_one_count is equal to game_size, which makes sure the input is only 1s and 0s
    printf("Initial values                   [");
     for(int i = 0; i < game_size; i++)
    {
        if(zero_one_count == game_size)
        {
            printf("%d", array[i]);
            if (i < game_size - 1)
            {
                printf(", ");
            }
        }
    }
    printf("]\n");

    // creates a new array of ints of size game_size that will copy array and keep track of changes for the next iteration rather than changing them live
    int copy[game_size];
    for(int i = 0; i < game_size; i++)
    {
        copy[i] = array[i];
    }
    

    // loops through the array time_steps amount of times and checks each index to see if it should die, remain alive, or come to life
    // calls upon isAlive and shouldDie and had various conditions for checking at index 0, indices 1 through game_size - 2, and index game_size - 1
    for(int i = 0; i < time_steps; i++)
    {
        for(int j = 0; j < game_size; j++)
        {
            if(j == 0) //checks the first cell and prevents index errors
            {
                if(game_size == 1) //if the array input is only 1 cell, the program will skip the rest and end up printing the one cell
                {
                    continue;
                }
                if(isAlive(array, j, game_size) && !isAlive(array, j + 1, game_size))
                {
                    copy[j + 1] = 1;
                }
                if(isAlive(array, j, game_size))
                {
                    copy[j] = 1;
                }
            }
            else if(j != 0 && j < game_size - 1)
            {
                // each if and else if statement in this chunk checks for the various conditions of bringing a cell to life or killing it based on the rules of the game
                if(shouldDie(array, j, game_size))
                {
                    copy[j] = 0;
                }
                else if(!isAlive(array, j - 1, game_size) && isAlive(array, j, game_size) && !isAlive(array, j + 1, game_size))
                {
                    copy[j - 1] = 1;
                    copy[j + 1] = 1;
                }
                else if(!isAlive(array, j - 1, game_size) && isAlive(array, j, game_size))
                {
                    copy[j - 1] = 1;
                }
                else if(!isAlive(array, j + 1, game_size) && isAlive(array, j, game_size))
                {
                    copy[j + 1] = 1;
                }
            }
            else if(j == game_size - 1) // checks the last cell and prevents index errors
            {
                if(isAlive(array, j, game_size) && !isAlive(array, j - 1, game_size))
                {
                    copy[j - 1] = 1;
                }
            }
        }

        iteration_count++;

        // the following code chunk prints each iteration at each time step by modifying array based on the changes indicated by copy
        // makes sure to maintain the formatting of the spec by allocating the proper spaces and brackets 
        printf("Values after timestep %-10d [", iteration_count);
        for(int k = 0; k < game_size; k++)
        {
            if(copy[k] == 0)
            {
                array[k] = 0;
            }
            if(copy[k] == 1)
            {
                array[k] = 1;
            }
            printf("%d", array[k]);
            if (k < game_size - 1)
            {
                printf(", ");
            }
        }
        printf("]\n");
    }

    // program exits with code 0 if successful!
    return 0;
}