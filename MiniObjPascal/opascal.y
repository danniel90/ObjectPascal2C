%{
#include <stdio.h>
#include <iostream>
#include "opascal_tree.h"

using namespace std;

#define YYERROR_VERBOSE

extern ProgramNode *program_node;

int yylex();
int yyerror(const char *msg);
%}

%union {
	OPNode	*op_node;
	Statement *statement_node;
	ExprList *expr_list;
	Expr *expr_node;
	int ivalue;
	char *svalue;
}

%token<ivalue> NUM
%token<svalue> ID STRING_LITERAL
%token OP_ASSIGN GT GTE LT LTE NEQ EQ
%token KW_PROGRAM KW_VAR KW_INTEGER KW_TYPE KW_CLASS KW_VIRTUAL KW_OVERRIDE KW_PROCEDURE KW_FUNCTION 
%token KW_BEGIN KW_END KW_IF KW_THEN KW_ELSE KW_WHILE KW_DO KW_WRITE KW_WRITELN

%type<op_node> program typedef_section typedef_declaration_list typedef_declaration opt_inherits field_declaration_list method_declaration_list method_declaration
%type<op_node> opt_parameters parameter_list parameter_decl
%type<op_node> method_impl_section method_impl_list method_impl opt_modifiers modifiers
%type<op_node> var_section var_declaration_list var_declaration
%type<op_node> type

%type<expr_list> opt_arguments arguments
%type<expr_node> expr expra term factor

%type<statement_node> block statement_list statement assign_statement method_call if_statement opt_else while_statement write_statement
%type<ivalue> st_write modifier

%%

program:			KW_PROGRAM ID ';'
				typedef_section
				method_impl_section
				var_section
				block '.'							{ program_node = new ProgramNode($2, $4, $5, $6, $7); }
;

typedef_section:		KW_TYPE typedef_declaration_list				{ $$ = $2; }
				| /* Nada */							{ $$ = NULL; }
;

typedef_declaration_list:	typedef_declaration_list typedef_declaration			{
												  TypeDefList *list = new TypeDefList($2, NULL);
												  $$ = $1;
												  ((TypeDefList *)$$)->next = list;
												}
				|typedef_declaration						{ $$ = new TypeDefList($1, NULL); }
;

typedef_declaration:		ID '=' KW_CLASS opt_inherits
				field_declaration_list
				method_declaration_list
				KW_END ';'							{ $$ = new ClassDeclaration($1, $4, $5, $6); }
;

opt_inherits: 			'(' ID ')'							{ $$ = new InheritsNode($2); }
				|/* Nada */							{ $$ = NULL; }
;

field_declaration_list:		var_declaration_list						{ $$ = $1; }
				|/* Nada */							{ $$ = NULL; }
;

method_declaration_list:	method_declaration_list method_declaration			{
												  MethodDeclList *list = new MethodDeclList($2, NULL);
												  if ($1 == NULL)	
													$$ = list;
												  else {
													$$ = $1;
													((MethodDeclList *)$$)->next = list;
												  }
												}
				|/* Nada */							{ $$ = NULL; }
;

method_declaration:		KW_PROCEDURE ID opt_parameters ';' opt_modifiers		{ $$ = new MethodDecl(0, $2, NULL, $3, $5); }
				|KW_FUNCTION ID opt_parameters ':' type ';' opt_modifiers	{ $$ = new MethodDecl(1, $2, $5, $3, $7); }
;

opt_modifiers:			modifiers							{ $$ = $1; }
				|/* Nada */							{ $$ = NULL; }
;

modifiers:			modifiers modifier ';'						{
												  ModifierList *list = new ModifierList($2, NULL);
			  									  $$ = $1;
												  ((ModifierList *)$$)->next = list;
		   										}
				|modifier ';'							{ $$ = new ModifierList($1, NULL); }
;

modifier:			KW_VIRTUAL							{ $$ = 0; }
				|KW_OVERRIDE							{ $$ = 1; }
;

opt_parameters:			'(' parameter_list ')'						{ $$ = $2; }
				|/* Nada */							{ $$ = NULL; }
;

parameter_list:			parameter_list ',' parameter_decl				{
												  ParameterDeclList *list = new ParameterDeclList($3, NULL);
												  $$ = $1;
												  ((ParameterDeclList *)$$)->next = list;
												}
				|parameter_decl							{ $$ = new ParameterDeclList($1, NULL); }
;

parameter_decl:			ID ':' type							{ $$ = new ParameterDecl($1, $3); }
;

method_impl_section:		method_impl_list						{ $$ = $1; }
				|/* Nada */							{ $$ = NULL; }
;

method_impl_list:		method_impl_list method_impl					{
												  MethodImplList *list = new MethodImplList($2, NULL);
												  $$ = $1;
												  ((MethodImplList *)$$)->next = list;
												}
				|method_impl							{ $$ = new MethodImplList($1, NULL); }
;

method_impl:			KW_PROCEDURE ID '.' ID opt_parameters ';' block ';'		{ $$ = new MethodImpl(0, $2, $4, NULL, $5, $7 ); }
				|KW_FUNCTION ID '.' ID opt_parameters ':' type ';' block ';'	{ $$ = new MethodImpl(1, $2, $4, $7, $5, $9 ); }
;

var_section:			KW_VAR var_declaration_list					{ $$ = $2; }
				|/* Nada */							{ $$ = NULL; }
;

var_declaration_list:		var_declaration_list var_declaration				{
												  VarDeclList *list = new VarDeclList($2, NULL);
												  $$ = $1;
												  ((VarDeclList *)$$)->next = list;
												}
				|var_declaration						{ $$ = new VarDeclList($1, NULL); }
;

var_declaration:		ID ':' type ';'							{ $$ = new VarDecl($1, $3); }
;

type:				KW_INTEGER							{ $$ = new IntegerType(); }
				|ID								{ $$ = new ClassType($1); }
;

block:				KW_BEGIN statement_list KW_END					{ $$ = $2; }
;

statement_list:			statement_list statement					{ $$ = new SeqStatement($1, $2); }
				|statement							{ $$ = $1; }
;

statement:			write_statement							{ $$ = $1; }
				|if_statement							{ $$ = $1; }
				|while_statement						{ $$ = $1; }
				|method_call							{ $$ = $1; }
				|assign_statement						{ $$ = $1; }
;

write_statement:		st_write '(' expr ')' ';' 					{ $$ = new WriteStatementExpr($1, $3); }
				|st_write '(' STRING_LITERAL ')' ';'				{ $$ = new WriteStatementStr($1, $3); }
				|KW_WRITELN							{ $$ = new WriteStatementStr(1, string("")); }
;

st_write:			KW_WRITE							{ $$ = 0; }
				|KW_WRITELN							{ $$ = 1; }
;

if_statement:			KW_IF expr KW_THEN block opt_else ';'				{ $$ = new IfStatement($2, $4, $5); } 
;

opt_else:			KW_ELSE block							{ $$ = $2; }
			 	|/* Nada */							{ $$ = NULL; }
;

while_statement:		KW_WHILE expr KW_DO block ';'					{ $$ = new WhileStatement($2, $4); }
;

method_call:			ID '.' ID opt_arguments ';'					{ $$ = new MethodCallStatement($1, $3, $4); }
;

opt_arguments: 			'(' arguments ')'						{ $$ = $2; }
				|/* Nada */							{ $$ = NULL; }
;

arguments:			arguments ',' expr						{ $$ = $1; $$->push_back($3); }
				|expr								{ $$ = new ExprList; $$->push_back($1); }
;

assign_statement:		ID OP_ASSIGN expr ';'						{ $$ = new AssignStatement($1, $3); }
;

expr:		expra GT expra			{ $$ = new GTExpr($1, $3); }
		|expra GTE expra		{ $$ = new GTEExpr($1, $3); }
		|expra LT expra			{ $$ = new LTExpr($1, $3); }
		|expra LTE expra		{ $$ = new LTEExpr($1, $3); }
		|expra NEQ expra		{ $$ = new NEQExpr($1, $3); }
		|expra EQ expra			{ $$ = new EQExpr($1, $3); }
		|expra
;

expra:		expra '+' term			{ $$ = new AddExpr($1, $3); }
		|expra '-' term			{ $$ = new SubExpr($1, $3); }
		|term				{ $$ = $1; }
;

term:		term '*' factor			{ $$ = new MultExpr($1, $3); }
		|term '/' factor		{ $$ = new DivExpr($1, $3); }
		|factor				{ $$ = $1; }
;

factor:		NUM				{ $$ = new NumExpr($1); }
		|ID				{ $$ = new IDExpr($1); }
		|ID '.' ID opt_arguments	{ $$ = new FuncCallExpr($1, $3, $4); }
		|'(' expr ')'			{ $$ = $2; }
;

