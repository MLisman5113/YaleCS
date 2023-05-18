#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "life.h"

bool isAlive(int array[], size_t index, size_t size)
{
    if(array[index] == 1)
    {
        return true;
    }
    return false;
}

bool shouldDie(int array[], size_t index, size_t size)
{
    if(isAlive(array, index, size) && isAlive(array, index - 1, size) && isAlive(array, index + 1, size))
    {
        return true;
    }
    
    return false;
}