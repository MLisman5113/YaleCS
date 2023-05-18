/*
 * File name: NodeType.h
 * Class + HW: CPSC 223 HW #4
 * Name: Marcus Lisman
 *
 * Purpose: Small struct that is part of a Linked List class
 *
 */

#include "Station.h"
using namespace std;

#ifndef NODETYPE
#define NODETYPE

struct NodeType
{
    Station info;
    NodeType *next;
};

#endif
