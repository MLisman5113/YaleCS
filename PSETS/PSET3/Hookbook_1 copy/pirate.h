/* 
* Name of file: pirate.h
* Name: Marcus Lisman
* Class + HW # : CPSC 223 HW 3
* Date: 03/08/2023
* Purpose: header file that defines the pirate struct. Within the pirate
*          struct, there are the various pieces of information that make up
*          a pirate's profile. The information is then used throughout the 
*          program for various sorting, manipulation, and printing purposes.
*/

#ifndef __PIRATE_H__
#define __PIRATE_H__

// Type of a pirate.
typedef struct person {
    char name[65];
} pirate;

#endif
