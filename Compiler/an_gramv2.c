#include "an_gramv2.h"

table_symbole *ts = NULL;

char *liste[TAILLE_LISTE];

int listeTemp[TAILLE_LISTE];

int listeVal[TAILLE_LISTE];

int length = 0;

int lengthTemp = 0;

int lengthservice = 0;

int ind = 0;

int ind_res = TAILLE_TAB-1;

int pv;

var_arith *liste_var_val = NULL;

int ind_var_val = 0;

int ind_temp = 0;

int nbr_ligne_asm = 0;

int asm_code[10];

int n = 0;

int masol = 0;

/*Fonction permettant d'initialiser notre tableau principal contenant les variables.*/

void initialize_tab(){

	ts = calloc(TAILLE_TAB, sizeof(table_symbole));
	liste_var_val = calloc(TAILLE_LISTE, sizeof(var_arith));


}

/*Fonction permettant de vider le tableau principal.*/

void release_tab(){

	free(ts);

}

/*Fonction permettant de rechercher un symbole (variable) dans le tableau principal.*/
/*Le paramètre symb est le symbole recherché.*/

int recherche_symb(char* symb){
	
	pv = -1;
	int s, t;

	for(s=0;s<ind;s++){
		if(strcmp(symb,ts[s].nom)==0){
			
			pv=s;
			break;
			
		}
	}

	return pv;

}


/*Fonction permettant d'afficher le tableau souhaité.*/
/*Le paramètre est le tableau que l'on souhaite afficher.*/

void afficher_struct(table_symbole s){
	
	char *a = s.nom;
	bool b = s.var_const;
	bool c = s.init;

	printf("%s %d %d\n", a, b, c);
}

/*Fonction permettant d'insérer dans le tableau un symbole (variable).*/
/*Les paramètres sont le type de la variable (int(1)/const int(0)) que l'on souhaite afficher et si la variable est initialisée.*/

void insert_tableau(bool var_const, bool init){
	
	int j;
	
	for(j=0; j<length; j++){
		int s = recherche_symb(liste[j]);
		if(s == -1){
			if(ts[ind].nom[0] == '\0'){
					strncpy(ts[ind].nom, liste[j],SYMBOL_SIZE - 1);
					ts[ind].var_const = var_const;
					ts[ind].init = init; 

					if(ind >= ind_res){

						fprintf(stderr, "%s","Warning : Maintenant, il n'y a plus de place dans le tableau\n\n");
					}
					
					if(ind<ind_res){
						ind = ind + 1;	
					}

			}
			
			else{
				
				if(ind<ind_res){
						ind = ind + 1;	
					}
				
			}
		}

		else{

			fprintf(stderr, "%s", "Présence de variable(s) déjà déclarée(s)\n"); //Avertit d'une ou de variables déjà déclarées.

		}

	}

	if(init == 0){

		length = 0;
	}	
}

/*Fonction permettant d'insérer dans le tableau principal les varaibles temporaires nécessaires.*/
/*Les paramètres sont le fichier dans lequel l'on va écrire et la valeur de la variable concernée.*/


void insert_temp(FILE *fichier, int val){


	lengthservice = length;
	

	strncpy(ts[ind_res].nom, "temp" ,SYMBOL_SIZE - 1);


	afc_function(ind_res, fichier, val);

	if(ind >= ind_res){

		fprintf(stderr, "%s","Warning : Maintenant, il n'y a plus de place dans le tableau\n\n");
	}

	ind_temp = ind_res;
	
	if(ind_res>ind){

	ind_res = ind_res - 1;

	}

	
}

/*Fonction permettant de réinitialiser l'index pour les variables temporaires.*/

void reinit_ind_res(){

	if(masol == 0){

		ind_res = TAILLE_TAB-1;

	}


}

int value_ind_res(){

	return ind_temp;


}

/*Fonction permettant de d'appliquer la fonction cop_function autant de fois que nécessaire.*/
/*Les paramètres sont l'index de la variable temporaire, le nom du fichier et la valeur de la variable.*/

void cop_rec_function(int index_temp, FILE *fichier, int val){

	int j;

	for(j=0;j<lengthservice;j++){

		int d = recherche_symb(liste[j]);
		cop_function(index_temp, fichier, d);
		liste_variable_valeur(liste[j], val);
	}

	if(ind >= ind_res){

		fprintf(stderr, "%s","Warning : Maintenant, il n'y a plus de place dans le tableau\n\n");
	}

	if(ind_res>ind){

	ind_res = ind_res - 1;

	}


	lengthservice = 0;	

	length = 0;



}

/*Fonction permettanr de retirer un élément une variable temporaire du tableau principal.*/

void pop_temp(){


	if(ind_temp  <= (TAILLE_TAB-2)){

		ind_res = ind_res + 1;

		ind_temp = ind_temp + 1;

	}

}

/*Les deux fonctions suivantes permettent de reçevoir deux variables temporaires qui se suivent. Elles sont 
nécessaire pour les opérations notamment.*/

int receive_temp2(){

	return ind_temp;

}

int receive_temp1(){

	return (ind_temp+1);

}

/*Fonction permettant de mettre à jour la valuer d'une variable notamment lorque l'on écrit des intructions de variables après 
les avoir déjà déclarées et initialisées.*/
/*Le paramètre est la variable souhaitée.*/

int get_last_value_of_var(char *symb){
	
	int j;
	int k = 0;
	for(j=0;j<ind_var_val;j++){

		if(strcmp(liste_var_val[j].var, symb)==0){

			listeVal[k] = liste_var_val[j].val;
			k = k + 1;

		} 
	
	}
	
	
	return listeVal[k-1];

}


/*Fonction permettant d'afficher le tableau principal.*/


void afficher_tableau(){
	
	int i;
	printf("Nom Var Init\n");
	for(i=0;i<TAILLE_TAB;i++){
		
		afficher_struct(ts[i]);

	}
}

/*La fonction liste_declaration(char *symb) permet de stocker dans une liste 
les variables déclarées sur une même ligne.*/
/*Le paramètre est la variable à déclarer.*/

void liste_declaration(char *symb){ 

	
	liste[length] = symb;
	length = length + 1;

}

/*Fonction permettant de stocker la valeur associée à une ou plusieurs variables.*/
/*Les paramètres sont la variable et la valeur associée.*/

void liste_variable_valeur(char *var, int val){
	
	strncpy(liste_var_val[ind_var_val].var, var ,SYMBOL_SIZE - 1);
	liste_var_val[ind_var_val].val = val;  

	ind_var_val = ind_var_val + 1;

}

/*Fonction permettant de mettre dans la liste listTemp les valeurs de variable.*/
/*Le paramètre est la valeur à insérer dans la liste.*/

void liste_temp(int arithmetic){

	listeTemp[lengthTemp] = arithmetic;
	lengthTemp = lengthTemp + 1;
	
}

/*La fonction isDeclare(char * symb) permet de savoir si une variable 
est déjà déclarée ou non.*/
/*Le paramètre est la variable souhaitée.*/


bool isDeclare(char * symb){

	int d = recherche_symb(symb);
	
	if(d==-1){

		return false;	
	
	}

	else{
	
		return true;

	}

}

/*Fonction permettant de savoir si une variable est initialisée ou pas.*/
/*Le paramètre est la variable en question.*/

bool isInit(char *symb){

	bool tf = false;

	int d = recherche_symb(symb);

	if(d != -1){

		if(ts[d].init == true){

		tf = true;
	
		}
	
	}

	return tf;

}

/*Fonction permettant de marquer l'initialisation d'une variable dans le tableau principal.*/
/*Le paramètre est le symbole(variable) souhaitée pour la marquer initialisée.*/

void setInit(char *symb){

	int d = recherche_symb(symb);
	strncpy(ts[ind_res].nom, "temp" ,SYMBOL_SIZE - 1);
	ts[d].init = true;


}

/*Fonction permettant de compter le nombre de variables initialisées.*/

void number_of_init(){

	ind_var_val = ind_var_val + 1;


}

/*Fonction permettant d'incrémenter le nombre de ligne pour compter le nombre d'instruction ASM.*/

void incr_nb_lignes_asm(){

	n = nbr_ligne_asm;

	nbr_ligne_asm = nbr_ligne_asm + 1;

}

/*Fonction permettant de récupérer le nombre de d'instructions assembleurs générées depuis le début.*/

int get_nb_lignes_asm(){

	return 	n;

}

/*Les deux fonctions suivantes permettent de protéger l'adresse de la condition du while pour qu'elle ne soit pas écrasée.*/

void masoln(){

 masol = 1;

}

void masolno(){

 masol = 0;

}

/*Fonxtion permettant de savoir si une variable est constante.*/
/*Le paramètre est le symbole souhaité.*/

bool isConst(char *symb){

	bool constante = false;

	int d = recherche_symb(symb);
	
	if(ts[d].var_const == false){

		constante = true;	
	

	}

	return constante;

}

void insert_cop(FILE *fichier, int symb){


	lengthservice = length;
	

	strncpy(ts[ind_res].nom, "temp" ,SYMBOL_SIZE - 1);

	cop_function(symb, fichier, ind_res);

	if(ind >= ind_res){

		fprintf(stderr, "%s","Warning : Maintenant, il n'y a plus de place dans le tableau\n\n");
	}

	ind_temp = ind_res;
	
	if(ind_res>ind){

	ind_res = ind_res - 1;

	}

	
}







/*

Les fonctions suivantes concernent l'ASM.

*/

void afc_function(int index_temp, FILE *fichier, int val){

	fprintf(fichier, "AFC %d %d\n", index_temp, val);
	incr_nb_lignes_asm();

}


void cop_function(int index_temp, FILE *fichier, int symb){

	fprintf(fichier, "COP %d %d\n", symb, index_temp);
	incr_nb_lignes_asm();
}

void add_function(int index_temp1, int index_temp2, FILE *fichier){

	fprintf(fichier, "ADD %d %d %d\n", index_temp1, index_temp1, index_temp2);
	incr_nb_lignes_asm();
}

void mul_function(int index_temp1, int index_temp2, FILE *fichier){

	fprintf(fichier, "MUL %d %d %d\n", index_temp1, index_temp1, index_temp2);
	incr_nb_lignes_asm();
}

void sou_function(int index_temp1, int index_temp2, FILE *fichier){

	fprintf(fichier, "SOU %d %d %d\n", index_temp1, index_temp1, index_temp2);
	incr_nb_lignes_asm();
}

void div_function(int index_temp1, int index_temp2, FILE *fichier){

	fprintf(fichier, "DIV %d %d %d\n", index_temp1, index_temp1, index_temp2);
	incr_nb_lignes_asm();
}

void printf_function(int index_temp, FILE *fichier){

	fprintf(fichier, "PRI %d \n", index_temp);
	incr_nb_lignes_asm();
}

void cmp_equ_function(int index_temp1, int index_temp2, FILE *fichier){

	fprintf(fichier, "EQU %d %d %d\n", index_temp1, index_temp1, index_temp2);
	incr_nb_lignes_asm();
}

void sup_function(int index_temp1, int index_temp2, FILE *fichier){

	fprintf(fichier, "SUP %d %d %d\n", index_temp1, index_temp1, index_temp2);
	incr_nb_lignes_asm();
}

void inf_function(int index_temp1, int index_temp2, FILE *fichier){

	fprintf(fichier, "INF %d %d %d\n", index_temp1, index_temp1, index_temp2);
	incr_nb_lignes_asm();
}

/*Pour les deux fonctions suivantes le bourage du symbole '\t' permet de corriger l'epacement entre deux instructions consécutives.*/

void jmf_function(int condition, int instruction, FILE *fichier){

	fprintf(fichier, "JMF %d %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n", condition, instruction);
	incr_nb_lignes_asm();
}

void jmp_function(int instruction, FILE *fichier){

	fprintf(fichier, "JMP %d\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n", instruction);
	incr_nb_lignes_asm();


}

