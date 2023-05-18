/* 
* Name of file: hookbook_library.c
* Name: Marcus Lisman
* Class + HW # : CPSC 223 HW 3
* Date: 03/08/2023
* Purpose: file of supporting helper functions for 
*          HookBook application assignment
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pirate_list.h"
#include "pirate.h"
#include "hookbook_library.h"

/* 
* Parameters: N/A
* Returns: pointer to a new pirate
* Purpose: creates a new pointer to a new pirate and sets the name
 */
pirate* create_pirate(char* name)
{
    pirate* p = (pirate*)malloc(sizeof(pirate));
    strcpy(p->name, name);
    return p;
}