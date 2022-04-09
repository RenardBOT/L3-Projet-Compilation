%{
    #include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	extern int TAB[100][6];
	extern char CH[500];
	extern int it;
	FILE* file;

	int nblist = 0;

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
fichier : element { fprintf(file,"</body></html>");} 
		| element fichier

texte: TXT { $$=$1; }
	| ECHAPEE { $$=$1; } 

element : texte { printNormalText($1); } 
		| LIGVID { fprintf(file,"<br/>"); } 
		| titre { 
				char baliseTitreOuvrante[5];
				sprintf(baliseTitreOuvrante, "<h%d>", TAB[$1][3]);
				char baliseTitreFermante[6];
				sprintf(baliseTitreFermante, "</h%d>", TAB[$1][3]);

				fprintf(file,"%s", baliseTitreOuvrante); 
				printNormalText($1);
				fprintf(file,"%s", baliseTitreFermante); 
				} 
		| liste 
		| texte_formatte { printFormattedText($1);} 

titre : BALTIT texte FINTIT {$$ = $2;} 

liste : DEBLIST liste_textes suite_liste 
		{ 
			fprintf(file,"<ul>");
			fprintf(file, "<li>");
			int first = 0;
			for(int i = 0 ; i < it ; i++)
			{
				if(TAB[i][2] == 3 && TAB[i][5] == nblist)
				{
					if(first)
					{
						fprintf(file,"<li>");
						first = 0;
					}	

					if(TAB[i][4] == 0)
						printNormalText(i);
					else
						printFormattedText(i);

					if(TAB[i][3] == 2)
					{
						fprintf(file,"</li>");
						first = 1;
					}	
					
				} 	
			}	
	 		fprintf(file,"</ul>"); 
		 	nblist++;
	 	}  

suite_liste : ITEMLIST liste_textes suite_liste
			| FINLIST 

texte_formatte : italique {$$ = $1;} 
			   | gras {$$ = $1;} 
			   | grasitalique {$$ = $1;} 

italique : ETOILE texte ETOILE { TAB[$2][4] = 1; printf("YACC ITALIQUE %d\n",$2); $$ = $2;}

gras : ETOILE ETOILE texte ETOILE ETOILE { TAB[$3][4] = 2; printf("YACC GRAS %d\n",$3); $$ = $3;}

grasitalique : ETOILE ETOILE ETOILE texte ETOILE ETOILE ETOILE { TAB[$4][4] = 3; printf("YACC GRASITALIQUE %d\n",$4); $$ = $4; }

liste_textes : texte { 
						TAB[$1][3] = 2;
						TAB[$1][5] = nblist;
					} 
			 | texte_formatte { 
				TAB[$1][3] = 2;
				TAB[$1][5] = nblist;
				}
			 | texte liste_textes { 
									TAB[$1][3] = 1;
									TAB[$1][5] = nblist;
								}
			 | texte_formatte liste_textes { 
				TAB[$1][3] = 1;
				TAB[$1][5] = nblist;
				}
%%
int main(){
	file = fopen("output.html", "w");
	fputs("<html><head><meta charset='utf-8'/><title>From Markdown</title></head><body>", file);
    yyparse();
	yylex();
	printf("\nTable des symboles de YACC\n");
	printTABYacc();
	fclose(file);
    return 0;
}

void yyerror(char*s){
    fprintf(stderr, "\nerreur Yacc: %s\n", s);
}

void printNormalText(int indice){
	char text[500]; 
	strncpy(text,&CH[TAB[indice][0]],TAB[indice][1]); 
	text[TAB[indice][1]] = '\0'; 
	fprintf(file,"%s", text); 
} 

void printFormattedText(int indice){
	char baliseOuvrante[20] = "";
	char baliseFermante[20] = "";
	switch(TAB[indice][4])
	{
		case 1:
		strcat(baliseOuvrante, "<em>");
		strcat(baliseFermante, "</em>");
		break;

		case 2:
		strcat(baliseOuvrante, "<strong>");
		strcat(baliseFermante, "</strong>");
		break;

		case 3:
		strcat(baliseOuvrante, "<em><strong>");
		strcat(baliseFermante, "</strong></em>");
		break;
	}
	fprintf(file,"%s", baliseOuvrante); 
	printNormalText(indice);
	fprintf(file,"%s", baliseFermante); 
} 

void printTABYacc(){
	printf("position|\tlength\t|\ttype\t|\tlevel\t|\tstyle\t|\tensemble\n");
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
			printf("Item\t|\t");
			if(TAB[i][3] == 1)
			{
				printf("meme\t|\t");
			}	
			else
			{
				printf("change\t|\t");
			} 
		}
		
		if(TAB[i][4] == 0)
		{
			printf("Normal\t|\t");
		}
		else if(TAB[i][4] == 1)
		{
			printf("Italique\t|\t");
		}
		else if(TAB[i][4] == 2)
		{
			printf("Gras\t|\t");
		}
		else if(TAB[i][4] == 3)
		{
			printf("GrasItalique\t|\t");
		}

		if(TAB[i][2] == 3)
		{
			printf("%d \t|\t\n", TAB[i][5]);
		}
		else
		{
			printf("\n");
		}	
	}
}