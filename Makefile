# Dragan Sorin 334CC

all: header_lexer

lex.yy.c: header_flex.l
	lex header_flex.l

header_lexer: lex.yy.c
	gcc lex.yy.c -lfl -o header_lexer

clean:
	rm -f header_lexer lex.yy.c
