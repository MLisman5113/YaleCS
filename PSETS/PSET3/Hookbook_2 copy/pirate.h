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
    char captain[65];
    char title[65];
    char vessel[65];
    char port[65];
    size_t treasure;
    char skill[65][65];
    size_t number_of_skills;
} pirate;

#endif
