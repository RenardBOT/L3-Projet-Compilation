%{
	//Compilation
	//lex -v exemple0.lex
	//gcc -Wall lex.yy.c -o analyseur -lfl
	//SOUS-CATEGORIES : titre = 1 , normal = 2 , item = 3

#include <stdio.h>

#include "y.tab.h"

int TAB[100][4];
char CH[500];
int position = 1;
int it = 0;
int level = 0;
%}

RETOURLIGNE \n|(\r\n)
TEXT [^" "\t#\*_\n\r][^#\*\n\r_]+

%start TITRE
%start ITEM

%%

<INITIAL>^" "{0,3}\#{1,6}" "+ {
	level = titleLevel();
	printf("Balise de titre de niveau %d\n", level);
	BEGIN TITRE;
 	return BALTIT;
}

<TITRE>{RETOURLIGNE} {
	printf("Fin titre\n");
	BEGIN INITIAL;
	return FINTIT;
}

<TITRE>({RETOURLIGNE}" "*){2,} {
	printf("Fin titre\n");
	BEGIN INITIAL;
	return FINTIT;
}

<ITEM>{RETOURLIGNE} {
}
<INITIAL>{RETOURLIGNE} {
}

<INITIAL>({RETOURLIGNE}" "*){2,} {
	printf("Ligne vide\n");
	return LIGVID;
}

<INITIAL>^\*" "+ {
	printf("Debut de liste\n");
	BEGIN ITEM;
	return DEBLIST;
}

<ITEM>^\*" "+ {
	printf("Item de liste\n");
	return ITEMLIST;
}

<ITEM>({RETOURLIGNE}" "*){2,} {
	printf("Fin de liste\n");
	BEGIN INITIAL;
	return FINLIST;
}

"*" {
	printf("ETOILE\n");
	return ETOILE;
}

<INITIAL>{TEXT} {
	printf("TEXTE : %s [index : %d]\n", yytext,fillTab(position,yyleng,2,0));
	strcat(CH, yytext);
	return TXT;
}

<TITRE>{TEXT} {
	printf("TEXTE : %s [index : %d]\n", yytext, fillTab(position,yyleng,1,level));
	strcat(CH, yytext);
	return TXT;
}

<ITEM>{TEXT} {
	printf("TEXTE : %s [index : %d]\n", yytext, fillTab(position,yyleng,3,0));
	strcat(CH, yytext);
	return TXT;
}

[" "\t] {
}

"_" {
	printf("Erreur lexicale: caractere %s non autorisé\n", yytext);
}

. {
	printf("Caractère non reconnu\n");
}
%%

int fillTab(int pos, int lg, int sscat, int niveau){
	TAB[it][0] = pos;
	TAB[it][1] = lg;
	TAB[it][2] = sscat;
	TAB[it][3] = niveau;
	position += yyleng;
	return it++;
}

int titleLevel(){
	char * in = yytext;
	int out = 0;
	for(int i = 0 ; i < yyleng ; i++)
		if(in[i] == '#')
			out++;
	return out;
}

void printTAB(){
	printf("position|\tlength\t|\ttype\t|\ttitle level\n");
	for(int i = 0 ; i < it ; i++)
	{
		printf("%d\t|\t%d\t|\t",TAB[i][0],TAB[i][1]);
		if(TAB[i][2] == 1)
		{
			printf("Title\t|\t%d\n", TAB[i][3]);
		}
		else if(TAB[i][2] == 2)
		{
			printf("Normal\t|\n");
		}
		else if(TAB[i][2] == 3)
		{
			printf("Item\t|\n");
		}
	}
}

int yywrap(){
	printf("\nTable des symboles\n");
	printTAB();
	printf("\nCH\n");
	printf("%s\n", CH);
	return 1;
}
