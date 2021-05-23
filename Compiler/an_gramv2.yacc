%{

#include "an_gramv2.h"
 
FILE *fichier=NULL;
int i = 0;
int val = 0; 
fpos_t position;
int pos = 0;
int ligne = 0;
int current = 0;
//int liste[10];
//int tell = 0;
//int indice = 0;
//int indd = 0;

 	
%}

%union
		{char *vari;
		int nombre;}

%token T_MAIN
%token T_OB
%token T_CB
%token T_CONST
%token T_INT
%token T_PRINTF
%token T_PLUS
%token T_MOINS
%token T_DIV
%token T_MUL
%token T_EQUAL
%token T_OP
%token T_CP
%token T_VIRG
%token T_PV
%token  <nombre> T_NB
%token T_SUP
%token T_INF
%token  <vari> T_VAR
%token  T_IF
%token  T_IF_OP
%token  T_ELSE
%token T_DIFF
%token T_CMP_EQU
%token T_WHILE

%right T_EQUAL
%left T_PLUS T_MOINS
%left T_MUL T_DIV
%left OP CP

%type <vari> variable
%type <vari> variable_instr 



%%


prog : T_INT T_MAIN T_OP T_CP T_OB body T_CB //{exit(0);}
     ;

body : declaration T_PV body 
	 | instruction T_PV  body
     | T_PRINTF T_OP T_VAR {int d = recherche_symb($3); printf_function(d,fichier);} T_CP T_PV body
	 | if_else {fseek(fichier, 0, SEEK_END);}  body 
	 | while {fseek(fichier, 0, SEEK_END);} body
     | 
	 ;

declaration : T_INT T_CONST variable
			{ 
				insert_tableau(false,true);

			} T_EQUAL arithmetic {if(i == 1){int tt = value_ind_res();cop_rec_function(tt, fichier, val); pop_temp();reinit_ind_res();} i=0;}

			| T_INT T_CONST variable 		
			{ 
				insert_tableau(false,false);

			}
			| T_INT variable 
			{ 

				insert_tableau(true,false);

			}		
			| T_INT variable
			{ 
				insert_tableau(true,true);

			} T_EQUAL arithmetic {if(i >= 1){int tt = value_ind_res();cop_rec_function(tt, fichier, val);pop_temp();reinit_ind_res();} i=0;}
       		;

variable : T_VAR {liste_declaration($1);} 
		 T_VIRG variable 
		 | T_VAR {liste_declaration($1);}
		 ;

variable_instr : T_VAR {{/*lengths(1)*/;int d = isDeclare($1);if(d==false){ yyerror();release_tab(); exit(0);}
						else{setInit($1);liste_declaration($1);};}} 
		 		 T_VIRG variable_instr 
		 		 | T_VAR {{/*lengths(1)*/;int d = isDeclare($1);if(d==false){ yyerror();release_tab(); exit(0);}
						else{setInit($1);liste_declaration($1);};}}
				 ;

arithmetic : T_NB {val = $1;i = i+1;insert_temp(fichier, $1);}
		   | T_VAR {i = i+1;int d = isDeclare($1); if(d==false){ yyerror();release_tab(); exit(0);}if(isInit($1)==false){fprintf(stderr,"%s %s %s", "Warning : Variable non initialisée -->", $1, "\n\n");}int v = get_last_value_of_var($1);insert_temp(fichier, v);val = v;} 
		   | arithmetic T_PLUS arithmetic {add_function(receive_temp1(), receive_temp2(), fichier);pop_temp();}
		   | arithmetic T_MOINS arithmetic {sou_function(receive_temp1(), receive_temp2(), fichier);pop_temp();}
		   | arithmetic T_MUL arithmetic {mul_function(receive_temp1(), receive_temp2(), fichier); pop_temp();}
		   | arithmetic T_DIV arithmetic {div_function(receive_temp1(), receive_temp2(), fichier);pop_temp();}
		   | T_OP arithmetic T_CP
		   ;

condition : arithmetic T_CMP_EQU arithmetic {cmp_equ_function(receive_temp1(), receive_temp2(), fichier);pop_temp();}
		  | arithmetic T_SUP arithmetic {sup_function(receive_temp1(), receive_temp2(), fichier);pop_temp();}
		  | arithmetic T_INF arithmetic {inf_function(receive_temp1(), receive_temp2(), fichier);pop_temp();}
		  ;

instruction : variable_instr   												//Interdit l'utilisateur d'écrire une 																								instruction avant de l'avoir préalablement déclarée.
			  T_EQUAL arithmetic {if(i >= 1){int tt = value_ind_res();cop_rec_function(tt, fichier, val);pop_temp();reinit_ind_res();} i=0;}
			;



if_else : T_IF_OP condition T_CP T_OB

			{
			fseek(fichier, 0, SEEK_END);
			ligne = get_nb_lignes_asm();
			fgetpos(fichier, &position);

			/*tell = ftell(fichier);
			liste[0] = 0;
			indice = indice + 1;							code associé au bout de code en commentaire ci-dessous.
			
			liste[indice] = tell;
			printf("cursor: %d\n", liste[indice]);
			printf("indice: %d\n", indice);*/
			
			jmf_function(receive_temp1()-1, ligne, fichier);


			}

	  		body 

			{ current = get_nb_lignes_asm();

			fsetpos(fichier, &position);

			fprintf(fichier, "JMF %d %d", receive_temp1()-1, current + 2);

			/*if(indice != 1){
			indice = indice - 1;
			fseek(fichier, indd,SEEK_SET);
			printf("cursor_type2: %d\n", liste[0]);     Code non terminé pour l'imbrication des if : On stocke les curseurs
			printf("indice: %d\n", indice);				pour y revenir mais il y a un problème avec la liste lors ici. Des
														valeurs arbitraire s'y stockent.
			fprintf(fichier, "You");
			
			}*/


			}

			T_CB

			T_ELSE T_OB

			{
			fseek(fichier, 0, SEEK_END);
			ligne = get_nb_lignes_asm();
			fgetpos(fichier, &position);
			jmp_function(ligne, fichier);
			

			}

	  		body 

			{ current = get_nb_lignes_asm();

			fsetpos(fichier, &position);

			fprintf(fichier, "JMP %d", current + 1);

			}

			T_CB



			| T_IF T_OP condition T_CP T_OB {

			fseek(fichier, 0, SEEK_END);
			ligne = get_nb_lignes_asm();
			fgetpos(fichier, &position);
			
			jmf_function(receive_temp1()-1, ligne, fichier);


			}

	  		body 

			{ current = get_nb_lignes_asm();

			fsetpos(fichier, &position);

			fprintf(fichier, "JMF %d %d", receive_temp1()-1, current+1);

			}T_CB;


while : T_WHILE T_OP condition T_CP T_OB
		{
			fseek(fichier, 0, SEEK_END);
			ligne = get_nb_lignes_asm();
			fgetpos(fichier, &position);
			
			jmf_function(receive_temp1()-1, ligne, fichier);

		}

		body

		{

			current = get_nb_lignes_asm();

			fsetpos(fichier, &position);

			fprintf(fichier, "JMF %d %d", receive_temp1()-1, current+2);

			fseek(fichier, 0, SEEK_END);
			
			jmp_function(ligne + 1, fichier);


		

		} T_CB
		;

							
	   
%%



int main()
{
	printf("Dans le main\n\n");
	initialize_tab();


	fichier = fopen("mon_asm.asm", "w+");

	if(fichier != NULL)
	{
		yyparse();

		printf("Tableau des variables et constantes\n");
		afficher_tableau();
		printf("Fin du tableau\n\n");

		release_tab();

		printf("FIN\n");
	
		fclose(fichier);

	}

	return 0;
}


int yyerror()
	{
	fprintf(stderr, "%s", "erreur\n");
  	return 1;
	}



