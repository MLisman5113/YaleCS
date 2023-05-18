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
pirate* create_pirate();

/*  
* Parameters: a pirate pointer, a string label from a file, value label
*             from a file
* Returns: N/A
* Purpose: Based on the file stream from the profile txt file, this function
*          fills the struct fields of the pirate for their profiles
*/
void field_filler(pirate* p, char *label, char* value);

/*
* Parameters: a list of pirates of the type pirate_list
* Returns: N/A
* Purpose: Sort the list of pirates in alphabetical order by vessel
*          If a tie exists (i.e. same vessel), then break tie by 
*           lexicographical sort
*/
void list_sort_by_vessel(pirate_list *pirates);

/* 
* Parameters: a list of pirates of the type pirate_list
* Returns: N/A
* Purpose: Sort the list of pirates in decreasing order by amount of 
*          treasure collected. If a tie exists (i.e. same treasure), 
*          then break tie by lexicographical sort
 */
void list_sort_by_treasure(pirate_list *pirates);

/* 
* Parameters: a list of pirates of the type pirate_list
* Returns: N/A
* Purpose: Takes in a list of pirates and prints out the profiles according 
*          to the specification of the assignment. Variation comes when 
*          there is or isn't a captain present in a pirate's profile.
 */
void print_profiles(pirate_list* list);

/* 
* Parameters: an array of strings where each string is a skill, a value of type
*             size_t that is equal to the number of skills the pirate has
* Returns: N/A
* Purpose": Creates an array to keep track of skills and how many asterisks 
*           should be assigned. Takes in an array of strings and a number 
*           of skills and sorts them, removes duplicates, and assigns 
*           asterisks based on how many times it shows up. Then prints 
*           all the skills and their corresponding asterisks.
*/
void skill_star_print(char skill[65][65], size_t number_of_skills);

#endif