doc : an_gramv2.yacc an_gramv2.h an_lexv2.lex
	lex an_lexv2.lex
	yacc -d an_gramv2.yacc
	gcc y.tab.c lex.yy.c -o compilo.exe
	./compilo.exe < text.c 

free : an_gramv2.yacc an_gramv2.h an_lexv2.lex
	lex an_lexv2.lex
	yacc -d an_gramv2.yacc
	gcc y.tab.c lex.yy.c -o compilo.exe
	./compilo.exe

files : an_gramv2.yacc an_gramv2.h an_lexv2.lex mon_asm.asm text.c an_gramv2.c
	pluma an_gramv2.yacc an_gramv2.c an_gramv2.h an_lexv2.lex mon_asm.asm text.c &

test : an_gramv2.yacc an_gramv2.h an_lexv2.lex an_gramv2.c
	lex an_lexv2.lex
	yacc -d an_gramv2.yacc
	gcc y.tab.c lex.yy.c an_gramv2.c -o compilo.exe
	./compilo.exe < text.c 

free1 : an_gramv2.yacc an_gramv2.h an_lexv2.lex an_gramv2.c
	lex an_lexv2.lex
	yacc -d an_gramv2.yacc
	gcc y.tab.c lex.yy.c  -o compilo.exe
	./compilo.exe
