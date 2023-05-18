/* 
* Name of file: hookbook.c
* Name: Marcus Lisman
* Class + HW # : CPSC 223 HW 3
* Date: 03/08/2023
* Purpose: driver source file for HookBook Part 1
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pirate_list.h"
#include "pirate.h"
#include "hookbook_library.h"

void list_expand_if_necessary(pirate_list*);
void list_contract_if_necessary(pirate_list*);

int main(int argc, char* argv[])
{

    FILE *file;
    char name[64];

    // checks for appropriate minimum command line arguments
    if(argc < 2)
    {
        return 1;
    }

    // open and verify file
    file = fopen(argv[1], "r");
    if(file == NULL)
    {
        return 1;
    }

    // create new pirate list
    pirate_list *list = list_create();

    // go through file, create pirate, and assign a name
    while(fgets(name, sizeof(name), file))
    {
        pirate *p = create_pirate(name);
        if(p == NULL)
        {
            return 1;
        }

        // expand list capacity if necessary and insert
        list_expand_if_necessary(list);
        list_insert(list, p, 0);
    }

    list_sort(list);

    // print each pirate in the list
    for(int i = 0; i < list->size; i++)
    {
        printf("%s", list->pirates[i]->name);
    }

    // destroy list and close file
    list_destroy(list);
    fclose(file);

    return 0;
}