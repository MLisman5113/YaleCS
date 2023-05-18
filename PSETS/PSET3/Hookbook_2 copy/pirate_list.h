/* 
* Name of file: pirate_list.h
* Name: Marcus Lisman
* Class + HW # : CPSC 223 HW 3
* Date: 03/08/2023
* Purpose: header file for pirate_list.c, which has helper functions to deal 
*          with the list of pirates, including but not limited to creating 
*          the list, sorting the list, finding specific elements in the list, 
*          inserting and removing in and out of the list, and destroying 
*          the list. The file also has the struct definition for a pirate_list
* Other comments: I made no changes to the source code of the functions. The
*                 only change I made to this file was implementing the
*                 pirate_list struct to be used throughout the rest of the
*                 program. No parameters were changed.
*/

#ifndef __PIRATE_LIST_H__
#define __PIRATE_LIST_H__

#include <stdlib.h>
#include "pirate.h"

// Type of a list of pirates
typedef struct implementation {
    pirate** pirates;
    size_t capacity;
    size_t size;
} pirate_list;


/* 
* Parameters: N/A
* Returns: a new instance of a pirate list of type pirate_list
* Purpose: Allocate memory for a new pirate_list and return a pointer to it
*/
pirate_list *list_create();

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate,
*             a pointer to a pirate
* Returns: an index of type size_t 
* Purpose: Return the index of the pirate with the same name as p, 
*          or a value greater than or equal to the length of the list 
*          if there is no pirate in the list with a matching name.
 */
size_t list_index_of(pirate_list *pirates, pirate *p);

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate,
*             a pointer to a pirate, an index of type size_t
* Returns: a pointer to a pirate if the conditions of not already being in the
*          list are met
* Purpose: Only if there is no pirate in the list with the same name as p, 
*          insert pirate p into the list at index idx by copying the pointer, 
*          shifting the latter part of the list one “slot” to the right.
*          If there is a pirate in the list with the same name as p, 
*          do nothing, and return a pointer to the pirate that was not 
*          inserted. If the pirate was inserted into the list, return NULL.
*/
pirate *list_insert(pirate_list *pirates, pirate *p, size_t idx);

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate,
*             a pointer to a pirate
* Returns: a pointer to a pirate 
* Purpose: Remove the pirate from the list with the same name as p, 
*          and return a pointer to it. If there is no pirate in the 
*          list with the same name as p, return NULL
*/
pirate *list_remove(pirate_list *pirates, pirate *p);

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate,
*             an index of the type size_t
* Returns: a pointer to a pirate
* Purpose: Return a pointer to the pirate pointed to by index idx in 
*          the list, or NULL if idx is not a valid index 
*          (i.e., it is >= the length of the list).
*/
pirate *list_access(pirate_list *pirates, size_t idx);

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate
* Returns: N/A
* Purpose: Sort the list of pirates in alphabetical order by name
*/
void list_sort(pirate_list *pirates);

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate
* Returns: a value of type size_t
* Purpose: Return the number of pirates in the list.
*/
size_t list_length(pirate_list *pirates);

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate
* Returns: N/A
* Purpose: Free all memory associated with the pirate_list, but leave the 
*          memory associated with the pirates in the list untouched 
*          (it is someone else's job to free the pirates; maybe that dog 
*          with the keys in the Pirates of the Caribbean).
*/
void list_destroy(pirate_list *pirates);

#endif
