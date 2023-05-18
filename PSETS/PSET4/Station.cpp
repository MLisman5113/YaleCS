/* 
 * File name: Station.cpp
 * Class + HW: CPSC 223 HW #4
 * Name: Marcus Lisman
 * 
 * Purpose: Implementation of the Station class
 * Don't forget to remove //TODO when you submit!
 * 
 */

#include "Station.h"
#include <iostream>

// Constructor
Station::Station(){
	name = "NoName";
    access = false;
}

// Parameterized Constructor
Station::Station(string input_name, bool input_access)
{
    name = input_name;
    access = input_access;
}

// Function: Returns true if the station given as a parameter is identical 
//           to the object whose function is being invoked (that is, they have 
//           the same name and accessibility). Returns false otherwise.
// Input: a Station
// Returns: a boolean indicating Station equality
// Does: checks for equality between two stations
bool Station::isEqual(Station s)
{
    if(s.getAccess() == access && s.getName() == name)
    {
        return true;
    }
    return false;
}

// Function: prints stations from the linked list in the specified
//           assignment format
// Input: reference to an ostream object
// Returns: void
// Does: prints train stations according to spec format
void Station::print(ostream &outfile)
{
    if(access == 1)
    {
        outfile << this->name << " " << "A";
    }
    else 
    {
        outfile << this->name << " " << "U";
    }
}


