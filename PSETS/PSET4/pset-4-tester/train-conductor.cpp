/*
 * train-conductor.cpp
 */

#include "LinkedList.h"
#include <iostream>
#include <string>

using namespace std;

// Input and output files
const string STATIONS_FILE = "input/glx.txt";
const string OUTPUT_ONE = "output/all_stations.txt";
const string OUTPUT_TWO = "output/remove_some.txt";

// Constants
const int FAIL = -1;
const int NUM_REMOVE = 10;

// Function to reverse a linked list
LinkedList reverseList(LinkedList);

// HW2 functions to generate output files
int reverseAllStations(LinkedList &);
int removeSome(LinkedList &); // ADD

int main()
{
    LinkedList stations;
    int numStations = 0;


    // Read in all the stations and print
    numStations = reverseAllStations(stations);
    if (numStations == FAIL)
    {
        cerr << "Failed to read and print all stations, exiting\n";
        return FAIL;
    }
    cout << "I just read and inserted " << numStations << " stations\n";

    // Get rid of some of the stations
    if (removeSome(stations) == FAIL)
    {
        cerr << "Failed to remove stations from list and write file,"
             << "exiting\n";
        return FAIL;
    }
    cout << "Removed stations and printed to file\n";

    cout << "Done!\n";

    return 0;
}

// Procedure that opens file STATIONS_FILE, reads information
// of all stations found and inserts them into the given linked list.
// Once finished it returns the number of insertions executed
int reverseAllStations(LinkedList &stations)
{
    int counter = 0;

    // Read in original list from file
    ifstream infile;
    infile.open(STATIONS_FILE.c_str());
    if (!infile.is_open())
    {
        cerr << "Could not add station from file\n";
        return FAIL;
    }

    string stationInfo = "";
    while (getline(infile, stationInfo))
    {
        char accesschar = stationInfo[stationInfo.length() - 1];
        string station_name = stationInfo.substr(0, stationInfo.length() - 2);
        bool access = false;
        if (accesschar == 'Y')
            access = true;
        else
            access = false;
        Station s(station_name, access);
        stations.insertStation(s);
        counter++;
    }

    infile.close();

    // Print the untouched list; it will be in reverse order than we inserted
    ofstream outfile;
    outfile.open(OUTPUT_ONE.c_str());
    if (!outfile.is_open())
    {
        cerr << "Failed to open file for writing\n";
        return FAIL;
    }
    stations.print(outfile);
    outfile.close();
    return counter;
}

// Procedure that removes NUM_REMOVE stations from the given Linked list
// Prints the new list in OUTPUT_TWO
int removeSome(LinkedList &stations)
{
    for (int i = 0; i < NUM_REMOVE; i++)
    {
        Station s = stations.getNextStation();
        stations.removeStation(s);
    }

    // Print the truncated list
    ofstream outfile;
    outfile.open(OUTPUT_TWO.c_str());
    if (!outfile.is_open())
    {
        cerr << "Failed to open file for writing\n";
        return FAIL;
    }
    stations.print(outfile);
    outfile.close();
    return 1;
}
