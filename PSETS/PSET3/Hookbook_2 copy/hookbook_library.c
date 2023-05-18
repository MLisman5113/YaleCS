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
pirate* create_pirate()
{
    pirate* p = (pirate*)malloc(sizeof(pirate));
    char* none = "(None)";
    strcpy(p->title, none);
    strcpy(p->captain, none);
    strcpy(p->vessel, none);
    strcpy(p->port, none);
    strcpy(p->skill[0], none);
    return p;
}

/*  
* Parameters: a pirate pointer, a string label from a file, value label
*             from a file
* Returns: N/A
* Purpose: Based on the file stream from the profile txt file, this function
*          fills the struct fields of the pirate for their profiles
*/
void field_filler(pirate* p, char *label, char* value)
{
    if (strcmp(label, "title") == 0) 
    {
        strcpy(p->title, value);
    }   
    else if (strcmp(label, "vessel") == 0) 
    {
        strcpy(p->vessel, value);
    } 
    else if (strcmp(label, "port") == 0) 
    {
        strcpy(p->port, value);
    } 
    else if (strcmp(label, "treasure") == 0) 
    {
        p->treasure = (size_t)atoi(value);
    } 
    else if (strcmp(label, "skill") == 0) 
    {
        strcpy(p->skill[p->number_of_skills], value);
        p->number_of_skills = p->number_of_skills + 1;
    }
}

/*
* Parameters: a list of pirates of the type pirate_list
* Returns: N/A
* Purpose: Sort the list of pirates in alphabetical order by vessel
*          If a tie exists (i.e. same vessel), then break tie by 
*           lexicographical sort
*/
void list_sort_by_vessel(pirate_list *pirates)
{
    int length = list_length(pirates);

    for(int i = 0; i < length - 1; i++)
    {
        for(int j = 0; j < length - 1; j++)
        {
            if(strcmp(pirates->pirates[j]->vessel, 
                      pirates->pirates[j + 1]->vessel) > 0)
            {
                pirate *temp = pirates->pirates[j];
                pirates->pirates[j] = pirates->pirates[j + 1];
                pirates->pirates[j + 1] = temp;
            } 
            else if(strcmp(pirates->pirates[j]->vessel, 
                           pirates->pirates[j + 1]->vessel) == 0)
            {
                if(strcmp(pirates->pirates[j]->name, 
                          pirates->pirates[j + 1]->name) > 0)
                {
                    pirate *temp = pirates->pirates[j];
                    pirates->pirates[j] = pirates->pirates[j + 1];
                    pirates->pirates[j + 1] = temp;
                }
            }
        }
    }
    return;
}

/* 
* Parameters: a list of pirates of the type pirate_list
* Returns: N/A
* Purpose: Sort the list of pirates in decreasing order by amount of 
*          treasure collected. If a tie exists (i.e. same treasure), 
*          then break tie by lexicographical sort
 */
void list_sort_by_treasure(pirate_list *pirates)
{
    int length = list_length(pirates);

    for(int i = 0; i < length - 1; i++)
    {
        for(int j = 0; j < length - 1; j++)
        {
            // checks for treasure
            if(pirates->pirates[j]->treasure < 
               pirates->pirates[j + 1]->treasure)
            {
                pirate *temp = pirates->pirates[j];
                pirates->pirates[j] = pirates->pirates[j + 1];
                pirates->pirates[j + 1] = temp;
            }
            // if same amount of treasure, break tie based on name
            else if(pirates->pirates[j]->treasure == 
                    pirates->pirates[j + 1]->treasure)
            {
                if(strcmp(pirates->pirates[j]->name, 
                          pirates->pirates[j + 1]->name) > 0)
                {
                    pirate *temp = pirates->pirates[j];
                    pirates->pirates[j] = pirates->pirates[j + 1];
                    pirates->pirates[j + 1] = temp;
                }
            }
        }
    }
    return;
}

/* 
* Parameters: a list of pirates of the type pirate_list
* Returns: N/A
* Purpose: Takes in a list of pirates and prints out the profiles according 
*          to the specification of the assignment. Variation comes when 
*          there is or isn't a captain present in a pirate's profile
 */
void print_profiles(pirate_list* list)
{
     for(int i = 0; i < list->size; i++)
    {
        char *none = "(None)";
        if(strcmp(list->pirates[i]->captain, none) == 0)
        {
            printf("Pirate: %s\n", list->pirates[i]->name);
            printf("    Title: %s\n", list->pirates[i]->title);
            printf("    Captain: %s\n", list->pirates[i]->captain);
            printf("    Vessel: %s\n", list->pirates[i]->vessel);
            printf("    Treasure: %ld\n", list->pirates[i]->treasure);
            printf("    Favorite Port of Call: %s\n", list->pirates[i]->port);
            
            if(list->pirates[i]->number_of_skills == 0)
            {
                printf("    Skills: (None)");
            }
            else
            {
                skill_star_print(list->pirates[i]->skill, 
                                 list->pirates[i]->number_of_skills);
            }
        }
            
        if(strcmp(list->pirates[i]->captain, none) != 0)
        {
            printf("Pirate: %s\n", list->pirates[i]->name);
            printf("    Title: %s\n", list->pirates[i]->title);
            printf("    Captain: %s\n", list->pirates[i]->captain);

            /* 
            * to get captain information, a dummy pirate is made and then 
            * it gets passed into list_get_index to get the index of
            * the captain, which can then be stored in the pirate's profile
             */
            pirate *dummy = create_pirate();
            strcpy(dummy->name, list->pirates[i]->captain);
            size_t index = list_index_of(list, dummy);
            free(dummy);

            printf("        Captain's Title: %s\n", 
                   list->pirates[index]->title);
            printf("        Captain's Favorite Port of Call: %s\n", 
                   list->pirates[index]->port);
            printf("    Vessel: %s\n", list->pirates[i]->vessel);
            printf("    Treasure: %ld\n", list->pirates[i]->treasure);
            printf("    Favorite Port of Call: %s\n", list->pirates[i]->port);

            if(list->pirates[i]->number_of_skills == 0)
            {
                printf("    Skills: (None)\n");
            }
            else
            {
                skill_star_print(list->pirates[i]->skill, 
                                 list->pirates[i]->number_of_skills);
            }
        }
        printf("\n");
    }
}



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
void skill_star_print(char skill[65][65], size_t number_of_skills)
{
    int counts[number_of_skills];
    for(int i = 0; i < number_of_skills; i++)
    {
        counts[i] = 0;
    }

    // count the number of times each skill shows up
    for (size_t i = 0; i < number_of_skills; i++) 
    {
        for (size_t j = 0; j < number_of_skills; j++) 
        {
            if (strcmp(skill[i], skill[j]) == 0) 
            {
                counts[i]++;
            }
        }
    }

    // copies the skill list over for easier sorting
    char *unique[number_of_skills];
    int k = 0;
    for (int m = 0; m < number_of_skills; m++) 
    {
        unique[k++] = skill[m];
    }

    // create an array for asterisk strings
    char* stars[k]; 
    for (int i = 0; i < k; i++) 
    {
        stars[i] = (char*) malloc(counts[i] + 1);
        memset(stars[i], '*', counts[i]); 
        stars[i][counts[i]] = '\0';
    }


    char skill_stars[k][128];

    // concatenate the skill and number of asterisks into a new array
    for(int i = 0; i < k; i++) 
    {
        sprintf(skill_stars[i], "%s %s", unique[i], stars[i]);
    }

    for (int i = 0; i < k - 1; i++) 
    {
        for (int j = 0; j < k - i - 1; j++) 
        {
            if (strcmp(skill_stars[j], skill_stars[j + 1]) > 0) 
            {
                char temp[64];
                strcpy(temp, skill_stars[j]);
                strcpy(skill_stars[j], skill_stars[j + 1]);
                strcpy(skill_stars[j + 1], temp);
            }
        }
    }


   //checks for duplicate elements in unique, deletes the position if so.
   // unique represents unique skills, which is desired for printing
   for (int x = 0; x < k; x++) 
   { 
       for (int y = x + 1; y < k; y++) 
       {  
           if (strcmp(skill_stars[x], skill_stars[y]) == 0) 
           {
               for (int z = y; z < k - 1; z++) 
               { 
                   strcpy(skill_stars[z], skill_stars[z + 1]);
               } 
               k--;   
               y--;     
           } 
       } 
   }

    // print each skill and the corresponding asterisks
    printf("    Skills: %s\n", skill_stars[0]);
    for (int m = 1; m < k; m++) 
    {
        printf("            %s\n", skill_stars[m]);
    }

    // free the original array of strings
    for (int i = 0; i < k; i++) 
    {
        free(stars[i]);
    }

}