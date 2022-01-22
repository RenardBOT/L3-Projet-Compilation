# L3-Projet-Compilation
Projet du module de **Langages Formels &amp; Compilation de L3**.  
Le but du projet est d’analyser un fichier **Markdown** et de le traduire en **HTML**.  

# Fichiers à analyser 
Le langage à analyser pour ce projet est en fait une version simplifiée du langage Markdown (décrite ci-dessous).  
  
Un fichier Markdown contient du texte et des caractères spéciaux qui vont définir la mise en forme à
appliquer à certaines parties de ce texte.  

Ces caractères spéciaux sont # * et _ (pour ce projet).  
  
En fonction de la façon dont ils sont placés, ils peuvent avoir différentes fonctions.  

## Titres

Le symbole # est utilisé pour définir les titres.  
Pour cela, il doit être placé en début de ligne, avec éventuellement entre 1 et 3 espaces avant, et suivi d’au
moins un espace.  
Pour définir un titre, on écrit un ou plusieurs # (jusqu’à 6 et sans espace entre deux #), en fonction du
niveau de titre (# : titre de niveau 1, ## : titre de niveau 2, etc.)  
La fin du titre annoncée par les # est déterminée par un retour à la ligne.  
En dehors de cette utilisation, tous les autres # seront considérés comme des erreurs lexicales.   

## Mise en forme

Les symboles * et _ sont utilisés pour mettre en évidence certains mots du texte (gras et italique). Dans ce cas, ils sont
utilisés par paire.  
Une seule étoile ou un seul underscore de part et d’autre d’un texte met celui-ci en italique.
Deux étoiles ou deux underscores (sans espaces entre les deux) de part et d’autre d’un texte met celui-ci
en gras.  
Trois étoiles ou trois underscores (sans espaces entre deux) de part et d’autre d’un texte met celui-ci en
gras et italique.  
Remarque : le texte se trouvant entre les – et * de début et les * et _ de fin ne doit pas comporter de ligne
vide

## Retours à la ligne

Les retours à la ligne jouent également un rôle important dans les fichiers Markdown.
Un retour à la ligne à la fin d’une ligne de titre annonce la fin du titre.
Une ligne vide indique un changement de paragraphe. Est considérée comme ligne vide une suite de
retours à la ligne, éventuellement séparés par des espaces. 

## Liste à puces

Le * peut également être utilisé pour introduire les items d’une liste à puce. Dans ce cas, il doit
obligatoirement se trouver en début de ligne et être suivi d’au moins 1 espace. Le texte qui suit constitue
un item de la liste. Celui-ci s’arrête au prochain item (prochaine * se trouvant en début de ligne) ou à la
prochaine ligne vide (pour le dernier item de la liste). 

## Erreurs syntaxiques

Tous les * et _ reconnus et mal placés dans le fichier source (qui ne peuvent pas être reconnus comme
balise de mise en forme ou de liste à puce du fait de leur emplacement) seront considérés comme faisant
partie du texte et traduits tels quels dans le fichier html.

## Traduction en HTML 

Définition d’un titre de niveau 1 : < h1 > titre < /h1 >  
Définition d’un titre de niveau 2 : < h2 > titre < /h2 >  
Etc.  
Mise en gras d’un texte :  < strong > texte < /strong >  
Mise en italique d’un texte : < em > text < /em >  
Changement de paragraphe < br >  
Définition d’une liste à puces :  
< ul >  
< li > item < /li >  
< li > item < /li >  
…
< /ul >

# Etapes du projet

## Etape 1 ( pour le 03 Février 2022 )

Etablir la liste des unités lexicales devant être reconnues par l’analyseur lexical (voir description générale
du projet) et donner une description de celles-ci en français la plus précise possible (voir cours).  
Aucun programme n’est demandé ici. Il n’est pas demandé non plus de rapport avec introduction et
conclusion. Uniquement un fichier texte contenant la liste des unités lexicales – une ligne par unité lexicale
– présentée de la façon suivante :  
Nom de l’unité lexicale 1 : Description en français  
Nom de l’unité lexicale 2 : Description en français  
etc.   

