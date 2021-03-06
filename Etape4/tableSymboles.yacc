%{
    #include<stdio.h>

    voidyyerror(char* s);
%}
%token TXT      // morceau de texte
%token BALTIT   // balise de titre
%token FINTIT   // fin de titre
%token LIGVID   // ligne vide
%token DEBLIST  // début de liste
%token ITEMLIST // item de liste
%token FINLIST  // fin de liste
%token ETOILE   // étoile

%start fichier

%%
fichier : element
		| element fichier

element : TXT
		| LIGVID
		| titre
		| liste
		| texte_formatte

titre : BALTIT TXT FINTIT

liste : DEBLIST liste_textes suite_liste

suite_liste : ITEMLIST liste_textes suite_liste
			| FINLIST

texte_formatte : italique
			   | gras
			   | grasitalique

italique : ETOILE TXT ETOILE

gras : ETOILE ETOILE TXT ETOILE ETOILE

grasitalique : ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE

liste_textes : TXT
			 | texte_formatte
			 | TXT liste_textes
			 | texte_formatte liste_textes
%%
int main(){
    yyparse();
	yylex();
    return 0;
}
void yyerror(char*s){
    fprintf(stderr, "\nerreur Yacc: %s\n", s);
}
