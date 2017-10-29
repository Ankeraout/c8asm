CC=gcc -c
CFLAGS=-W -Wall -Wextra
LD=gcc
LDFLAGS=
LEX=flex
LEXFLAGS=
YACC=bison
YACCFLAGS=

all: bin/c8asm

bin/c8asm: src/main.c src/lexer.l src/parser.y
	$(YACC) $(YACCFLAGS) src/parser.y -o src/parser.c --defines=src/parser.h
	$(LEX) $(LEXFLAGS) --header-file=src/lexer.h -o src/lexer.c src/lexer.l
	
	if [ ! -d obj ]; then \
		mkdir obj; \
	fi
	
	$(CC) $(CFLAGS) src/parser.c -o obj/parser.o
	$(CC) $(CFLAGS) src/lexer.c -o obj/lexer.o
	$(CC) $(CFLAGS) src/main.c -o obj/main.o
	
	if [ ! -d bin ]; then \
		mkdir bin; \
	fi

	$(LD) $(LDFLAGS) -lc obj/main.o obj/parser.o obj/lexer.o -o bin/c8asm
	
clean:
	rm -rf obj
	rm -f src/lexer.c
	rm -f src/lexer.h
	rm -f src/parser.c
	rm -f src/parser.h
	rm -rf bin
	