/* 
* Name of file: pirate_list.c
* Name: Marcus Lisman
* Class + HW # : CPSC 223 HW 3
* Date: 03/08/2023
* Purpose: library of helper functions to deal with the list of pirates,
*          including but not limited to creating the list, sorting the list,
*          finding specific elements in the list, inserting and removing
*          in and out of the list, and destroying the list.
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pirate_list.h"
#include "pirate.h"
#include "hookbook_library.h"

size_t INITIAL_CAPACITY  = 25;
size_t RESIZE_FACTOR = 2;

void list_expand_if_necessary(pirate_list*);
void list_contract_if_necessary(pirate_list*);

/* 
* Parameters: N/A
* Returns: a pointer to a list of type pirate_list
* Purpose: Allocate memory for a new pirate_list and return a pointer to it.
*/
pirate_list* list_create()
{
    pirate_list* list = (pirate_list*)malloc(sizeof(pirate_list));
    list->size = 0;
    list->capacity = INITIAL_CAPACITY;

    return list;
}

/*
* Parameters: a pointer to a list of type pirate_list, a pointer to a pirate
* Returns: an index of type size_t based on certain conditions
* Purpose: Return the index of the pirate with the same name as p, 
*          or a value greater than or equal to the length of the list if 
*          there is no pirate in the list with a matching name.
 */
size_t list_index_of(pirate_list *pirates, pirate *p)
{   
    size_t length = pirates->size;

    for(size_t match = 0; match < length; match++)
    {
        if(strcmp(pirates->pirates[match]->name, p->name) == 0)
        {
            return match;
        }
    }

    return length;
}

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
pirate *list_insert(pirate_list *pirates, pirate *p, size_t idx)
{
    // if the index of p is less than the size, it is in the list, so return it
    if(list_index_of(pirates, p) < pirates->size)
    {
        return p;
    }

    /* 
    * creates a new pirate_list that can allocate 1 more space for 
    * one more pirate, the inserted pirate 
    */
    pirate **new_pirates = malloc((pirates->size + 1) * sizeof(pirate*));
    
    // copy pointers up to index into new pirate_list
    for (int i = 0; i < idx; i++) 
    {
        new_pirates[i] = pirates->pirates[i];
    }
    
   // Insert the new pirate 
    new_pirates[idx] = p;
    
    // copy in remaining pointers into new pirate list
    for (int i = idx; i < pirates->size; i++) 
    {
        new_pirates[i + 1] = pirates->pirates[i];
    }
    
    /* 
    * free the memory of the original list and allocate the new list
    * as the updated list of pirates to be used through the rest 
    * of the program
     */
    free(pirates->pirates);
    pirates->pirates = new_pirates;
    pirates->size++;

    return NULL;
}

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate,
*             a pointer to a pirate
* Returns: a pointer to a pirate 
* Purpose: Remove the pirate from the list with the same name as p, 
*          and return a pointer to it. If there is no pirate in the 
*          list with the same name as p, return NULL
*/
pirate *list_remove(pirate_list *pirates, pirate *p)
{
    list_contract_if_necessary(pirates);

    pirate* ptr = NULL;

    for(int i = 0; i < pirates->size; i++)
    {
        if(strcmp(pirates->pirates[i]->name, p->name) == 0)
        {
            ptr = pirates->pirates[i];
            return ptr;
        }
    }
    return NULL;
}

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate,
*             an index of the type size_t
* Returns: a pointer to a pirate
* Purpose: Return a pointer to the pirate pointed to by index idx in 
*          the list, or NULL if idx is not a valid index 
*          (i.e., it is >= the length of the list).
 */
pirate *list_access(pirate_list *pirates, size_t idx)
{
    size_t length = list_length(pirates);

    if(idx >= length || idx < 0)
    {
        return NULL;
    }

    return pirates->pirates[idx];
}

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate
* Returns: N/A
* Purpose: Sort the list of pirates in alphabetical order by name
*/
void list_sort(pirate_list *pirates)
{
    int length = list_length(pirates);

    for(int i = 0; i < length - 1; i++)
    {
        for(int j = 0; j < length - 1; j++)
        {
            if(strcmp(pirates->pirates[j]->name, pirates->pirates[j + 1]->name) > 0)
            {
                pirate *temp = pirates->pirates[j];
                pirates->pirates[j] = pirates->pirates[j + 1];
                pirates->pirates[j + 1] = temp;
            }
        }
    }
    return;
}

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate
* Returns: a value of type size_t
* Purpose: Return the number of pirates in the list.
*/
size_t list_length(pirate_list *pirates)
{
    return pirates->size;
}

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate
* Returns: N/A
* Purpose: Free all memory associated with the pirate_list, but leave the 
*          memory associated with the pirates in the list untouched 
*          (it is someone else's job to free the pirates; maybe that dog 
*          with the keys in the Pirates of the Caribbean).
 */
void list_destroy(pirate_list *pirates)
{
    free(pirates);
}

/*
* Parameters: a list of type pirate_list populated with pirates of type pirate
* Returns: N/A, prints a message to stderr, if applicable
* Purpose: Check if the actual number of pirates in the array is "too large"; 
*          if it is, increase the capacity of the array by a factor 
*          of RESIZE_FACTOR. If the array capacity was changed, 
*          print to stderr the string "Expand to ", followed by the 
*          new capacity of the list and a newline. Here is a possible 
           print statement:
*
*          fprintf(stderr, "Expand to %zu\n", new_capacity);
*
*          If the capacity was not changed, do nothing.
*/
void list_expand_if_necessary(pirate_list* pirates)
{
    size_t new_capacity = pirates->capacity;

    if(pirates->size < pirates->capacity)
    {
        return;
    }

    if(pirates->size == pirates->capacity)
    {
        new_capacity = new_capacity * RESIZE_FACTOR;
        pirates->capacity = new_capacity;

        pirates = (pirate_list*)realloc(pirates, sizeof(pirate_list));
    }

    fprintf(stderr, "Expand to %zu\n", new_capacity);

}


/*
* Parameters: a list of type pirate_list populated with pirates of type pirate,
* Returns: N/A, prints a message to stderr, if applicable
* Purpose: Check if the actual number of pirates in the array is "too small"; 
*          if it is, decrease the capacity of the array by a factor 
*          of RESIZE_FACTOR. If the array capacity was changed, print 
*          to stderr the string "Contract to " followed by the new capacity 
*          of the list. Here is a possible print statement:
*
*          fprintf(stderr, Contract to %zu\n, new_capacity);
*
*          If the capacity was not changed, do nothing.
*
*          The capacity of the array must never fall below INITIAL_CAPACITY!
*/
void list_contract_if_necessary(pirate_list* pirates)
{
    size_t new_capacity = pirates->capacity;

    if(pirates->size < pirates->capacity)
    {
        return;
    }

    if(pirates->size == (pirates->capacity / RESIZE_FACTOR) && (pirates->capacity / RESIZE_FACTOR) >= INITIAL_CAPACITY)
    {
        pirates->capacity = pirates->capacity / RESIZE_FACTOR;
        new_capacity = pirates->capacity;

        pirates = (pirate_list*)realloc(pirates, sizeof(pirate_list));
    }
    fprintf(stderr, "Contract to %zu\n", new_capacity);
}