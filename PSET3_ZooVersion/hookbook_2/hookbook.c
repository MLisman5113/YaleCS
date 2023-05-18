/* 
* Name of file: hookbook.c
* Name: Marcus Lisman
* Class + HW # : CPSC 223 HW 3
* Date: 03/08/2023
* Purpose: main driver file for HookBook application assignment
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
    // define files and lines of text from files
    FILE *file_profiles;
    FILE *file_pirate_captain;
    FILE *checker;
    char line[64];
    char pirate_captain_line[64];

    // check command line arguments, return 1 if error
    if(argc < 3)
    {
        fprintf(stderr, "Invalid arguments\n");
        return 1;
    }
    
    // define profiles and pirate-captain pairs from command line arguments
    // check if files are NULL and return error code + message
    file_profiles = fopen(argv[1], "r");

    if(file_profiles == NULL)
    {
        fprintf(stderr, "Invalid filename: %s\n", argv[1]);
        return 1;
    }

    file_pirate_captain = fopen(argv[2], "r");

    if(file_pirate_captain == NULL)
    {
        fprintf(stderr, "Invalid filename: %s\n", argv[2]);
        return 1;
    }

    // check to see if profiles are present. If not, return error code 1
    checker = fopen(argv[1], "r");
    int c = fgetc(checker);
    if (c == EOF) 
    {
        fclose(checker);
        return 1;
    }
    
    // create a pirate list
    pirate_list *list = list_create();

    /* 
    * check command line argument for method of sorting
    * either "-n" (lexicographically sort by name)
    * "-v" (lexicographically sort by vessel)
    * "-t" (sort by amount of treasure, most to least)
    */
    if(strcmp(argv[3], "-n") == 0)
    {
        while(fgets(line, sizeof(line), file_profiles))
        {
            char *label = strtok(line, ":");
            char *value = strtok(NULL, "\n");
            pirate *p;
            char *none = "(None)";

            /* 
            * Assign the value to the corresponding struct field 
            * based on the label
             */
            if (strcmp(label, "name") == 0) 
            {
                p = create_pirate();
                if(p == NULL)
                {
                    return 1;
                }
                strcpy(p->name, value);
            } 
            else 
            {
                field_filler(p, label, value);
            }

            strcpy(p->captain, none);

            // read in the pirate-captain pairs and add to profile
            file_pirate_captain = fopen(argv[2], "r");
            if(file_pirate_captain == NULL)
            {
                fprintf(stderr, "Invalid filename: %s\n", argv[2]);
                return 1;
            }

            while(fgets(pirate_captain_line, sizeof(pirate_captain_line), 
                        file_pirate_captain))
            {
                char *pirate = strtok(pirate_captain_line, "/");
                char *captain = strtok(NULL, "\n");

                if(strcmp(p->name, pirate) == 0)
                {
                    strcpy(p->captain, captain);
                }
            }

            /* close pirate-captain pair file, expand list if 
            *  needed, and insert 
            */
            fclose(file_pirate_captain);
            list_expand_if_necessary(list);
            list_insert(list, p, 0);
        }

        /* 
        * sort the list, print the profiles, destroy the list,
        * and close the profiles file
         */
        list_sort(list);
        print_profiles(list);
        list_destroy(list);
        fclose(file_profiles);
    }
    else if(strcmp(argv[3], "-v") == 0)
    {
        while(fgets(line, sizeof(line), file_profiles))
        {
            char *label = strtok(line, ":");
            char *value = strtok(NULL, "\n");
            pirate *p;
            char *none = "(None)";

            /* 
            * Assign the value to the corresponding struct field 
            * based on the label
             */
            if (strcmp(label, "name") == 0) 
            {
                p = create_pirate();
                if(p == NULL)
                {
                    return 1;
                }
                strcpy(p->name, value);
            } 
            else 
            {
                field_filler(p, label, value);
            }

            strcpy(p->captain, none);

            // read in the pirate-captain pairs and add to profile
            file_pirate_captain = fopen(argv[2], "r");
            if(file_pirate_captain == NULL)
            {
                fprintf(stderr, "Invalid filename: %s\n", argv[2]);
                return 1;
            }

            while(fgets(pirate_captain_line, sizeof(pirate_captain_line), 
                        file_pirate_captain))
            {
                char *pirate = strtok(pirate_captain_line, "/");
                char *captain = strtok(NULL, "\n");

                if(strcmp(p->name, pirate) == 0)
                {
                    strcpy(p->captain, captain);
                }
            }

            /* close pirate-captain pair file, expand list if 
            *  needed, and insert 
            */
            fclose(file_pirate_captain);
            list_expand_if_necessary(list);
            list_insert(list, p, 0);
        }

        /* 
        * sort the list, print the profiles, destroy the list,
        * and close the profiles file
         */
        list_sort_by_vessel(list);
        print_profiles(list);
        list_destroy(list);
        fclose(file_profiles);
    } 
    else if(strcmp(argv[3], "-t") == 0)
    {
        while(fgets(line, sizeof(line), file_profiles))
        {
            char *label = strtok(line, ":");
            char *value = strtok(NULL, "\n");
            pirate *p;
            char *none = "(None)";

            /* 
            * Assign the value to the corresponding struct field 
            * based on the label
             */
            if (strcmp(label, "name") == 0) 
            {
                p = create_pirate();
                if(p == NULL)
                {
                    return 1;
                }
                strcpy(p->name, value);
            } 
            else 
            {
                field_filler(p, label, value);
            }

            strcpy(p->captain, none);

            // read in the pirate-captain pairs and add to profile
            file_pirate_captain = fopen(argv[2], "r");
            if(file_pirate_captain == NULL)
            {
                fprintf(stderr, "Invalid filename: %s\n", argv[2]);
                return 1;
            }

            while(fgets(pirate_captain_line, sizeof(pirate_captain_line), 
                        file_pirate_captain))
            {
                char *pirate = strtok(pirate_captain_line, "/");
                char *captain = strtok(NULL, "\n");

                if(strcmp(p->name, pirate) == 0)
                {
                    strcpy(p->captain, captain);
                }
            }

            /* close pirate-captain pair file, expand list if 
            *  needed, and insert 
            */
            fclose(file_pirate_captain);
            list_expand_if_necessary(list);
            list_insert(list, p, 0);
        }

        /* 
        * sort the list, print the profiles, destroy the list,
        * and close the profiles file
         */
        list_sort_by_treasure(list);
        print_profiles(list);
        list_destroy(list);
        fclose(file_profiles);
    }
    
    return 0;
}