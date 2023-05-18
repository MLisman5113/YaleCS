/*
 * LinkedList.h
 *
 * Interface for Linked List of Green Line Extension Stations
 *
 */

#include "Station.h"
#include "NodeType.h"
#include <fstream>

#ifndef LINKED_LIST_H_
#define LINKED_LIST_H_

class LinkedList
{
public:
    LinkedList();                              // Default constructor
    ~LinkedList();                             // Default constructor
    LinkedList &operator=(const LinkedList &); // Assignment Operator
    LinkedList(const LinkedList &);            // copy constructor.
                                               // It creates a new list that is
                                               // identical to the one given

    void insertStation(Station); // Inserts a station into the list
    void removeStation(Station); // Removes a station from the list
    void makeEmpty();            // Empties the list
    void resetCurrPos();
    Station getNextStation(); // Gives a new station

    bool isCurrPosNull() const;
    int getLength() const; // Returns the length of the list
    void print(ostream &); // Print the list of stations

private:
    int length;
    NodeType *head;
    NodeType *currPos;
};

#endif
