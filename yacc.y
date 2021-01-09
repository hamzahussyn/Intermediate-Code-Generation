%{
	#include <stdio.h>
	#include <string.h>

	/* The additional file of yacc.y, where we define the parser */


	//Prototypes of functions
	void result_gen();	
	void quadruple_entry(char a[], char b, char c[]);
	void quadruple_entry_assign(char a[], char b, char c[]);
	void quadruple_entry_loop();
	void quadruple_entry_do();
	void iftrue();
	void ifstart();
	void three_address_code();
	
	
	//Global variables
	int q_index = 0;
	char result[3] = {'t','0','\0'};
	char result2[3] = {'L','0','\0'};
	char goto_[7] = {'g','o','t','o',' ','\0'};
	char if_[4] = {'i','f',' ','\0'};
	char else_[6] = {'e','l','s','e',' ','\0'};
	char temp[3];

	
	//Structure to store three address records
	struct QuadrupleStructure {
		char arg1[10];
		char op;
		char arg2[10];
		char rslt[3];
	}quadruple[25];

	
 
%}

%union {
	char str[10];
	char symbol;
}

%token WHILE DO IF
%token <str> ID
%token <symbol> OP
%type  <str> expr 

%right '='
%left '+' '-'
%left '/' '*'


%%

stmt	:	block
	|	blkwstmt
	|	blkif
	;

blkif	:	blkif ifstmt
	|	ifstmt
	;

ifstmt	:	IF '(' con ')' { ifstart(); } { iftrue(); } block
	;

blkwstmt:	blkwstmt w
	|	w
	;

w	:	WHILE '('con')' { quadruple_entry_loop(); } DO block { quadruple_entry_do(); }
	;	 	

block	:	block s
	|	s	
	;

s	:	ID '=' expr  { quadruple_entry_assign($1, '=', $3); }
	;
con	:	ID OP ID { quadruple_entry($1,$2,$3); }
	;	

expr	:	expr '+' expr { quadruple_entry($1, '+', $3); strcpy($$,temp); }

	|	expr '-' expr { quadruple_entry($1, '-', $3); strcpy($$,temp); }

	|	expr '/' expr { quadruple_entry($1, '/', $3); strcpy($$,temp); }

	|	expr '*' expr { quadruple_entry($1, '*', $3); strcpy($$,temp); }

	|	'(' expr ')'  { strcpy($$,$2); }

	|	ID	      { strcpy($$,$1); }
	;

%%




void result_gen() {
	strcpy(temp,result);
	result[1]++;
}


void quadruple_entry(char a[], char b, char c[]) {
	result_gen();

	strcpy(quadruple[q_index].arg1, a);
	quadruple[q_index].op = b;
	strcpy(quadruple[q_index].arg2, c);
	strcpy(quadruple[q_index].rslt, temp);

	q_index++;
}

void quadruple_entry_assign(char a[], char b, char c[]) {
	char tempLocal[3] = {' ',' ','\0'};
	strcpy(quadruple[q_index].arg1, a);
	quadruple[q_index].op = b;
	strcpy(quadruple[q_index].arg2, c);
	strcpy(quadruple[q_index].rslt, tempLocal);

	q_index++;
}

void quadruple_entry_loop() {
	char tempLocal[3];
	strcpy(tempLocal, result2);
	char resultLocal[3];
	strcpy(resultLocal, result);
	resultLocal[1]--;

	char tempLocal2[10] = {'i','f',' ','\0'};
	strcat(tempLocal2, resultLocal);
	char tempLocal3 = ' ';
	char tempLocal4[] = " ";
	
	strcpy(quadruple[q_index].rslt, tempLocal);
	strcpy(quadruple[q_index].arg1, tempLocal2);
	quadruple[q_index].op = tempLocal3;
	strcpy(quadruple[q_index].arg2, tempLocal4);
 
	q_index++;	
}

void quadruple_entry_do() {
	char tempLocal[10];
	strcpy(tempLocal, goto_);
	strcat(tempLocal, result2);
	strcpy(quadruple[q_index].arg1,tempLocal);

	char tempLocal2[] = "  ";
	char tempLocal3 = ' ';

	quadruple[q_index].op = tempLocal3;
	strcpy(quadruple[q_index].arg2, tempLocal2);
	strcpy(quadruple[q_index].rslt, tempLocal2);

	q_index++;
	result2[1]++;
 	
	char tempLocal4[10];
	strcpy(tempLocal4, else_);
	strcat(tempLocal4, result2);
	strcpy(quadruple[q_index].arg1,tempLocal4);

	char tempLocal5[] = " ";
	char tempLocal6 = ' ';

	quadruple[q_index].op = tempLocal6;
	strcpy(quadruple[q_index].arg2, tempLocal5);
	strcpy(quadruple[q_index].rslt, tempLocal2);

	q_index++;
}
	 
void ifstart() {
	char templocal[7];
	strcpy(templocal, if_);
	char resultLocal[3];
	strcpy(resultLocal, result);
	resultLocal[1]--;
	
	strcat(templocal, resultLocal);

	strcpy(quadruple[q_index].arg1, templocal);
	strcpy(quadruple[q_index].rslt, result2);
	
	q_index++;
	
	strcpy(quadruple[q_index].rslt, result2);
	result2[1]++;

	char tempLocal3[10] = {'g','o','t','o',' ','\0'};
	strcat(tempLocal3, result2);

	//quadruple[q_index].op = tempLocal2;
	strcpy(quadruple[q_index].arg1, tempLocal3);
	
	q_index++;
}

void iftrue() {
	strcpy(quadruple[q_index].rslt, result2);
	char templocal[10] = " ";
	char templocal2 = ' ';
		
	quadruple[q_index].op = templocal2;
	strcpy(quadruple[q_index].arg2, templocal);
	strcpy(quadruple[q_index].arg1, templocal);
	
	result2[1]++;
	q_index++;
}

void three_address_code() {
	int i;
	for(i=0 ; i<q_index ; i++) 
		printf("\n%s := %s %c %s", quadruple[i].rslt, quadruple[i].arg1, quadruple[i].op, quadruple[i].arg2);
}

void yyerror(char *s){
    printf("\nProgram terminated due to error. \nError type: %s",s);
}

int yywrap() {
	return 1;
}

int main() {
	yyparse();
	three_address_code();
	return 0;
} 