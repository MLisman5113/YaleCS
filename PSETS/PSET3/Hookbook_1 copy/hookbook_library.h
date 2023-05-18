/* 
* Name of file: hookbook_library.h
* Name: Marcus Lisman
* Class + HW # : CPSC 223 HW #
* Date: 03/08/2023
* Purpose: header file for hookbook_library.c, define functions for
*          hookbook_library.c to be used throughout the program
*/

#ifndef __HOOKBOOK_LIBRARY_H__
#define __HOOKBOOK_LIBRARY_H__

#include <stdlib.h>
#include "pirate.h"
#include "pirate_list.h"

/*  
* Parameters: N/A
* Returns: a new instance of a pirate of type pirate
* Purpose: creates a new pointer to a new pirate and sets the name
*/
pirate* create_pirate(char* name);

#endif