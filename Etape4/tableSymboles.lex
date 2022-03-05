%{
	//Compilation
	//lex -v exemple0.lex
	//gcc -Wall lex.yy.c -o analyseur -lfl
	//CATEGORIES : etoile = 1 , underscore = 2 , texte = 3
	//SOUS-CATEGORIES : titre = 1 , normal = 2 , item = 3

#include <stdio.h>

int TAB[100][5];
int position = 1;
int it = 0;
int level = 0;
%}

RETOURLIGNE \n|(\r\n)

%start TITRE
%start ITEM

%%

^" "{0,3}\#{1,6}" "+ {
	level = titleLevel();
	BEGIN TITRE;
}

{RETOURLIGNE} {
	printf("Retour à la ligne simple\n");
}

({RETOURLIGNE}" "*){2,} {
	printf("Ligne vide\n");
}

^\*" "+ {
	printf("Point de liste\n");
	BEGIN ITEM;
}


"*" {
	printf("ETOILE [index : %d]\n", fillTab(0,0,1,0,0));
}

"_" {
	printf("UNDERSCORE [index : %d]\n", fillTab(0,0,2,0,0));
}

<INITIAL>[^" "\t#\*_\n\r][^#\*_\n\r]+ {
	printf("TEXTE [index : %d]\n", fillTab(position,yyleng,3,2,0));
}

<TITRE>[^" "\t#\*_\n\r][^#\*_\n\r]+ {
	printf("TEXTE [index : %d]\n", fillTab(position,yyleng,3,1,level));
	BEGIN INITIAL;
}

<ITEM>[^" "\t#\*_\n\r][^#\*_\n\r]+ {
	printf("TEXTE [index : %d]\n", fillTab(position,yyleng,3,3,0));
	BEGIN INITIAL;
}

[" "\t] {

}

. {
	printf("Caractère non reconnu\n");
}
%%

int fillTab(int pos, int lg, int cat, int sscat, int niveau){
	TAB[it][0] = pos;
	TAB[it][1] = lg;
	TAB[it][2] = cat;
	TAB[it][3] = sscat;
	TAB[it][4] = niveau;
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
	printf("pos | lg | cat | sscat | lv title\n");
	for(int i = 0 ; i < it ; i++)
		printf("%d | %d | %d | %d | %d\n",TAB[i][0],TAB[i][1],TAB[i][2],TAB[i][3],TAB[i][4]);
} 

int yywrap(){
	printTAB();
	return 1;
} 