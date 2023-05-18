#I used Professor Aspnes' notes and lecture notes for guidance 
# on how to create this makefile

CC=gcc
CFLAGS=-g3 -Wall

all: Life

Life: main.o life.o
	${CC} ${CFLAGS} -o $@ $^

main.o: main.c life.h
life.o: life.c life.h

clean:
	$(RM) Life *.o