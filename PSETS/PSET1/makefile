#I used Professor Aspnes' notes for guidance 
# on how to create this makefile

CC = gcc
CFLAGS = -g3 -Wall

all: Hello

Hello: Hello.o
	${CC} ${CFLAGS} -o $@ $^

Hello.o: Hello.c