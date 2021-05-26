#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>


#define SYMBOL_SIZE 32
#define TAILLE_TAB	30
#define TAILLE_LISTE 25

#define ADD 1
#define MUL 2
#define SOUS 3
#define DIV 4

typedef struct table_symbole
{
	char nom[SYMBOL_SIZE];
	bool var_const;
	bool init; 
}table_symbole; 

typedef struct var_arith
{
	char var[SYMBOL_SIZE];
	int val;

}var_arith;



int yylex();
int yyerror();
void initialize_tab();
void release_tab();
int recherche_symb(char *symb);
void afficher_struct(table_symbole s);
void insert_tableau(bool var_const, bool init);
void insert_temp(FILE *fichier, int val);
void afficher_tableau();
void liste_declaration(char *a);
bool isDeclare(char * symb);
void liste_temp(int arithmetic);
bool isInit(char *symb);
void setInit(char *symb);
void release_temp();
void insert_value_of_variable();
void number_of_init();
int value_of_variable(char *symb);
void liste_variable_valeur(char *var, int val);
int get_last_value_of_var(char *symb);
void pop_temp();
int receive_temp1();
int receive_temp2();
void cop_rec_function(int index_temp, FILE *fichier, int val);
int value_ind_res();
void reinit_ind_res();
void incr_nb_lignes_asm();
int get_nb_lignes_asm();
void masoln();
void masolno();
bool isConst(char *symb);
void insert_cop(FILE *fichier, int symb);

/*Prototypes des fonctions pour création de l'ASM*/

void afc_function(int index_temp, FILE *fichier, int val);
void cop_function(int index_temp, FILE *fichier, int symb);
void add_function(int index_temp1, int index_temp2, FILE *fichier);
void mul_function(int index_temp1, int index_temp2, FILE *fichier);
void sou_function(int index_temp1, int index_temp2, FILE *fichier);
void div_function(int index_temp1, int index_temp2, FILE *fichier);
void printf_function(int index_temp, FILE *fichier);
void cmp_equ_function(int index_temp1, int index_temp2, FILE *fichier);
void inf_function(int index_temp1, int index_temp2, FILE *fichier);
void sup_function(int index_temp1, int index_temp2, FILE *fichier);
void jmf_function(int condition, int instruction, FILE *fichier);
void jmp_function(int instruction, FILE *fichier);
