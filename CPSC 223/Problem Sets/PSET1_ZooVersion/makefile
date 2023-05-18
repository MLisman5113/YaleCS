#I used Professor Aspnes' notes and lecture notes for guidance 
# on how to create this makefile

CC=gcc
CFLAGS=-g3 -Wall

all: Hello

Hello: Hello.c
	${CC} ${CFLAGS} -o $@ $^

Hello.o: Hello.c

clean:
	rm -f hello *.o