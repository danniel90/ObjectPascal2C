%option noyywrap
%x comment

%{
#include <stdio.h>
#include "opascal_tree.h"
#include "opascal_tokens.h"

int line_num = 1;
%} 

%%
	
"+"			{ return '+'; }
"-"			{ return '-'; }
"*"			{ return '*'; }
"/"			{ return '/'; }
"("			{ return '('; }
")"			{ return ')'; }
";"			{ return ';'; }
":"			{ return ':'; }
"."			{ return '.'; }
","			{ return ','; }
"="			{ return '='; }
":="			{ return OP_ASSIGN; }
">"			{ return GT; }
">="			{ return GTE; }
"<"			{ return LT; }
"<="			{ return LTE; }
"!="			{ return NEQ; }
"=="			{ return EQ; }
"program"		{ return KW_PROGRAM; }
"var"			{ return KW_VAR; }
"integer"		{ return KW_INTEGER; }
"type"			{ return KW_TYPE; }
"class"			{ return KW_CLASS; }
"procedure"		{ return KW_PROCEDURE; }
"function"		{ return KW_FUNCTION; }
"virtual"		{ return KW_VIRTUAL; }
"override"		{ return KW_OVERRIDE; }
"begin"			{ return KW_BEGIN; }
"end"			{ return KW_END; }
"if"			{ return KW_IF; }
"then"			{ return KW_THEN; }
"else"			{ return KW_ELSE; }
"while"			{ return KW_WHILE; }
"do"			{ return KW_DO; }
"write"			{ return KW_WRITE; }
"writeln"		{ return KW_WRITELN; }
[ \t]   		/* Nada */
"\n"    		{ line_num++; }
\'[^\']*\'		{ 
			  yytext[yyleng-1] = '\0';
			  yylval.svalue = strdup(&yytext[1]); 
			  return STRING_LITERAL;
			}
[0-9]+			{ 
			  yylval.ivalue = atoi(yytext);
			 return NUM;
			}
[a-zA-Z]+		{
			  yylval.svalue = strdup(yytext);
			  return ID;
			}

"{"			BEGIN(comment);

<comment>[^}\n]*	/* consumir todo lo que no sea '}' o fin de linea */
<comment>\n		++line_num;
<comment>"}"		BEGIN(INITIAL);

.			printf("Caracter no reconocido %c\n", yytext[0]);

%%
