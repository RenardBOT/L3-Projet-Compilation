y.tab.c: tableSymboles.yacc
    yacc tableSymboles.yacc

y.tab.h: tableSymboles.yacc
    yacc -d tableSymboles.yacc

lex.yy.c: tableSymboles.lex 
    lex tableSymboles.lex

lex.yy.o: lex.yy.c y.tab.h
    gcc -Wall -c lex.yy.c

analyseur: y.tab.c lex.yy.o
    gcc -Wall y.tab.c lex.yy.o -lfl -o analyseur

clear:
    rm y.tab.h; rm y.tab.c; rm lex.yy.c