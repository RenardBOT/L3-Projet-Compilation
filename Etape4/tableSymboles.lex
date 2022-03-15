%{
	//Compilation
	//lex -v exemple0.lex
	//gcc -Wall lex.yy.c -o analyseur -lfl
	//SOUS-CATEGORIES : titre = 1 , normal = 2 , item = 3

#include <stdio.h>

int TAB[100][4];
int position = 1;
int it = 0;
int level = 0;
%}

RETOURLIGNE \n|(\r\n)

%start TITRE
%start ITEM

%%

<INITIAL>^" "{0,3}\#{1,6}" "+ {
	level = titleLevel();
	BEGIN TITRE;
	return BALTIT;
}

<TITRE>{RETOURLIGNE} {
	printf("Fin titre\n");
	return FINTIT;
}

<TITRE>({RETOURLIGNE}" "*){2,} {
	printf("Fin titre\n");
	return FINTIT;
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
	printf("item de liste\n");
	return ITEMLIST;
}

<ITEM>({RETOURLIGNE}" "*){2,} {
	printf("Fin de liste\n");
	return FINLIST;
}

"*" {
	printf("ETOILE\n");
	return ETOILE;
}

<INITIAL>[^" "\t#\*_\n\r][^#\*\n\r]+ {
	printf("TEXTE : %s [index : %d]\n", yytext,fillTab(position,yyleng,2,0));
	return TXT;
}

<TITRE>[^" "\t#\*_\n\r][^#\*\n\r]+ {
	printf("TEXTE [index : %d]\n", fillTab(position,yyleng,1,level));
	BEGIN INITIAL;
	return TXT;
}

<ITEM>[^" "\t#\*\n\r][^#\*\n\r]+ {
	printf("TEXTE [index : %d]\n", fillTab(position,yyleng,3,0));
	BEGIN INITIAL;
	return TXT;
}

[" "\t] {

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
	position += yyleng ;
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
	printf("pos\t|\tlg\t|\tsscat\t|\tlv title\n");
	for(int i = 0 ; i < it ; i++)
		printf("%d\t|\t%d\t|\t%d\t|\t%d\n",TAB[i][0],TAB[i][1],TAB[i][2],TAB[i][3]);
} 

int yywrap(){
	printTAB();
	return 1;
} 
