/*
 * File name: LinkedList.cpp
 * Class + HW: CPSC 223 HW #4
 * Name: Marcus Lisman
 * 
 * Purpose: Implementation for Linked List of Green Line Extension Stations
 * Don't forget to remove //TODO when you submit!
 */

#include "LinkedList.h"
#include <iostream>
using namespace std;

// Default constructor
LinkedList::LinkedList(){
    length = 0;
    head = NULL;
    currPos = NULL;
}

// Destructor
LinkedList::~LinkedList() {
    makeEmpty();
}

// Assignment operator overloading
// Don't change anything here. This is needed for copying objects.
LinkedList & LinkedList::operator = (const LinkedList &l){
    NodeType *temp;
    while (head != NULL){
        temp = head;
        head = head->next;
        delete temp;
    }
    length = l.length;
    currPos = NULL;
    if (l.head == NULL)
        head = NULL;
    else{
        head = new NodeType;
        head->info = l.head->info;
        head->next = NULL;
        NodeType *curr = head;
        NodeType *orig = l.head;
        while (orig->next != NULL){
            curr->next = new NodeType;
            curr->next->info = orig->next->info;
            curr->next->next = NULL;
            orig = orig->next;
            curr = curr->next;
        }
    }
    return *this;
}

// Input: nothing
// Returns: the length
// Does: returns the length of the LL
int LinkedList::getLength() const{
    return length;
}

// Input: nothing
// Returns: true if currPos is NULL
// Does: determines if currPos is NULL or not
bool LinkedList::isCurrPosNull() const{
    return currPos == NULL;    
}

// Input: Station 
// Returns: void
// Does: inserts the given station into the head of the list
void LinkedList::insertStation(Station s)
{
    NodeType* new_node = new NodeType;
    new_node->info = s;
    new_node->next = head;
    head = new_node;
    length++;
}

// Input: Station
// Returns: void
// Does: deletes 1st instance of station that's in the list and isEqual to the
//       one given as part of the input
void LinkedList::removeStation(Station s)
{
    NodeType* current_node = head;
    NodeType* previous_node = NULL;
    
    // go through list until a match is reached
    while (current_node != NULL && !current_node->info.isEqual(s)) 
    {
        previous_node = current_node;
        current_node = current_node->next;
    }
    
    // if found, update pointers and deallocate memory
    if (current_node != NULL && current_node != currPos) 
    {
        if (previous_node == NULL) 
        {
            head = current_node->next;
        } 
        else 
        {
            previous_node->next = current_node->next;
        }

        delete current_node;
        length--;
    }
    else if (current_node != NULL && current_node == currPos) 
    {
        if (previous_node == NULL) 
        {
            head = current_node->next;
        } 
        else 
        {
            previous_node->next = current_node->next;
        }
        resetCurrPos(); // reset currPos if the current node is currPos
        delete current_node;
        length--;
    }

}


// Input: No input parameters
// Returns: Station
// Does: return the next station in the list based on currPos
Station LinkedList::getNextStation()
{
    // return default station if empty
    if (head == NULL) {
        return Station(); 
    }

    Station station;

    /* 
    * if currPos == NULL, return the first station
    * if currPos points to last, return last station
    * else return the station pointed to by currPos and move ptr to next 
    */
    if (currPos == NULL) 
    {
        station = head->info;
        currPos = head->next;
    } 
    else if (currPos->next == NULL) 
    {
        station = currPos->info; 
        currPos = NULL;
    } 
    else 
    {
        station = currPos->info;
        currPos = currPos->next;
    }
    return station;
}

// Input: No input parameters
// Returns: void
// Does: resets currPos to NULL
void LinkedList::resetCurrPos(){
   currPos = NULL;
}

// Input: no input parameters
// Returns: void
// Does: deletes all elements in the list and deallocates any 
//       allocated memory
void LinkedList::makeEmpty(){
    
    NodeType* current_node = head;
    NodeType* next_node = NULL;
    
    // go through LL and delete each node
    while (current_node != NULL) {
        next_node = current_node->next;
        delete current_node;
        current_node = next_node;
    }
    
    // reset head and length of LL
    head = NULL;
    length = 0;
}

// Input: reference to an ostream object
// Returns: void
// Does: prints all the stations in the list in order in the format
//       specified by the assignment formatting instructions
void LinkedList::print(ostream &out){
    
    NodeType* current_node = head;
    int distance = getLength() - 1;

    while (current_node != nullptr) 
    {
        // print station name and accessibility
        out << current_node->info.getName() << " ";

        if (current_node->info.getAccess() == 1)
        {
            out << "A" << " ";
        }
        else 
        {
            out << "U" << " ";
        }

        // print distance to final stop
        if (current_node->next != nullptr) 
        {
            out << distance << " == ";
            distance = distance - 1;
        } 
        else 
        {
            out << "0\n";
        }

        current_node = current_node->next;
    }
}



