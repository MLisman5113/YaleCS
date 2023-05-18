#
#  File name: Makefile
#  Class + HW: CPSC 223 HW #4
#  Name: Marcus Lisman
#
#  Purpose: Makefile for the train-conductor.cpp, LinkedList and Station
#


CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra 
DEPS = Station.h LinkedList.h

%.o: %.cpp $(DEPS)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

train-conductor: train-conductor.o Station.o LinkedList.o
	$(CXX) -o train-conductor train-conductor.o Station.o LinkedList.o

clean:
	rm -f *.o core* *~ train-conductor
