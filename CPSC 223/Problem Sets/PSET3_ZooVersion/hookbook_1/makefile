# Name of file: makefile
# Name: Marcus Lisman
# Class + HW # : CPSC 223 HW 3
# Date: 03/08/2023
# Purpose: makefile for HookBook Part 1 to create executable HookBook

CC=gcc
CFLAGS=-std=c17 -Wall -Werror -pedantic -g

all: HookBook

HookBook: hookbook.o pirate_list.o hookbook_library.o
	${CC} ${CFLAGS} -o $@ $^

hookbook.o: pirate.h pirate_list.h hookbook_library.h
pirate_list.o: pirate.h pirate_list.h
hookbook_library.o: pirate.h pirate_list.h hookbook_library.h

clean:
	$(RM) HookBook *.o

