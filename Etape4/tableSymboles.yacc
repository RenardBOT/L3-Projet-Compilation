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
fichier :
element :
titre :
liste :
suite_liste :
texte_formatte :
italique :
gras :
grasitalique :
liste_textes :

P : duree note G {$$ = $1 + $3; printf("total %d\n",$$);}
G : duree note G {$$ = $1 + $3;}
    | {$$=0;};
%%
int main(){
    yyparse();
    return 0;
}
void yyerror(char*s){
    fprintf(stderr, "erreur %s\n", s);
}
