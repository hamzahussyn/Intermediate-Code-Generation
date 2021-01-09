%{
	#include "y.tab.h"

	/* Additional file of lex.l, where we define the lexer for our program */
%}


NUMBER		[0-9]		
ALPHABET	[a-zA-Z]

%%

[ \n\t] 	{ };
{NUMBER}+	{ strcpy(yylval.str, yytext); return ID; }
{ALPHABET}	{ strcpy(yylval.str, yytext); return ID; }
"while"		{ return WHILE; }
"do"		{ return DO; }
"if"		{ return IF;}
"<"		{ yylval.symbol=yytext[0]; return OP; }
">"		{ yylval.symbol=yytext[0]; return OP; }
"!="		{ yylval.symbol=yytext[0]; return OP; }
"=="		{ yylval.symbol=yytext[0]; return OP; }
.		{ return yytext[0]; }

%%