#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "life.h"

// returns true if the value of the cell is 1, false otherwise

bool isAlive(int array[], size_t index, size_t size)
{
    if(array[index] == 1)
    {
        return true;
    }
    return false;
}


// returns true if both cells on either side of a live cell are alive, in which case the cell dies, false otherwise
bool shouldDie(int array[], size_t index, size_t size)
{
    if(isAlive(array, index, size) && isAlive(array, index - 1, size) && isAlive(array, index + 1, size))
    {
        return true;
    }
    
    return false;
}