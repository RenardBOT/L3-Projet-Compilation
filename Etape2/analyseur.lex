%{
	//Compilation
	//lex -v exemple0.lex
	//gcc -Wall lex.yy.c -o analyseur -lfl
#include <stdio.h>
%}

RETOURLIGNE \n|(\r\n)

%%

^" "{0,3}\#{1,6}" "+ {
	printf("Balise de titre\n");
}

{RETOURLIGNE} {
	printf("Retour à la ligne simple\n");
}

({RETOURLIGNE}" "*){2,} {
	printf("Ligne vide\n");
}

^\*" "+ {
	printf("Point de liste\n");
}


"*" {
	printf("etoile\n");
}

"_" {
	printf("underscore\n");
}

[^" "\t#\*_\n\r][^#\*_\n\r]+ {
	printf("Morceau de texte\n");
}

[" "\t] {

}

. {
	printf("Caractère non reconnu\n");
}

%%
