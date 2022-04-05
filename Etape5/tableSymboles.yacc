%{
    #include<stdio.h>

	extern int TAB[100][5];
	extern int it;
	int nbpuce=0;

    void yyerror(char* s);
%}
%token TXT      // morceau de texte
%token BALTIT   // balise de titre
%token FINTIT   // fin de titre
%token LIGVID   // ligne vide
%token DEBLIST  // début de liste
%token ITEMLIST // item de liste
%token FINLIST  // fin de liste
%token ETOILE   // étoile de mise en forme
%token ECHAPEE	// étoile dans le texte

%start fichier

%%
fichier : element
		| element fichier

texte: TXT {$$=$1; /*printf("BIDULE %d\n",TAB[$$][0]); */}
	| ECHAPEE {$$=$1;} 

element : texte 
		| LIGVID
		| titre
		| liste
		| texte_formatte

titre : BALTIT texte FINTIT

liste : DEBLIST liste_textes suite_liste

suite_liste : ITEMLIST liste_textes suite_liste
			| FINLIST

texte_formatte : italique
			   | gras
			   | grasitalique

italique : ETOILE texte ETOILE { TAB[$2][4] = 1; printf("YACC ITALIQUE %d\n",$2); }

gras : ETOILE ETOILE texte ETOILE ETOILE { TAB[$3][4] = 2; printf("YACC GRAS %d\n",$3); }

grasitalique : ETOILE ETOILE ETOILE texte ETOILE ETOILE ETOILE { TAB[$4][4] = 3; printf("YACC GRASITALIQUE %d\n",$4); }

liste_textes : texte
			 | texte_formatte
			 | texte liste_textes
			 | texte_formatte liste_textes
%%
int main(){
    yyparse();
	yylex();
	printf("\nTable des symboles de YACC\n");
	printTAB2();	
    return 0;
}
void yyerror(char*s){
    fprintf(stderr, "\nerreur Yacc: %s\n", s);
}
void printTAB2(){
	printf("position|\tlength\t|\ttype\t|  title level\t|\tstyle\n");
	printf("−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−\n");
	for(int i = 0 ; i < it ; i++)
	{
		printf("%d\t|\t%d\t|\t",TAB[i][0],TAB[i][1]);
		if(TAB[i][2] == 1)
		{
			printf("Title\t|\t%d\t|\t", TAB[i][3]);
		}
		else if(TAB[i][2] == 2)
		{
			printf("Normal\t|\t\t|\t");
		}
		else if(TAB[i][2] == 3)
		{
			printf("Item\t|\t\t|\t");
		}
		
		if(TAB[i][4] == 0)
		{
			printf("Normal\t|\t\n");
		}
		else if(TAB[i][4] == 1)
		{
			printf("Italique\t|\t\n");
		}
		else if(TAB[i][4] == 2)
		{
			printf("Gras\t|\n");
		}
		else if(TAB[i][4] == 3)
		{
			printf("GrasItalique\t|\n");
		}

	}
}