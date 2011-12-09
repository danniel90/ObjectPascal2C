#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "opascal_tree.h"
#include "simb_table.h"

using namespace std;

ClassDefMap class_def_map;
VariableDefMap var_map;

extern int line_num;
ProgramNode *program_node = NULL;

const char *yycurrfilename()
{
	return "";
}

long yycurrlinenum(void)
{
	return 0;
}

void yynodefailed(void)
{
	
}

void yyerror(const char *m)
{
	printf("%d:%s\n", line_num, m);
}

extern FILE *yyin;
int yyparse();

int main(int argc, char **argv)
{
	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {
		printf("No se pudo abrir el archivo %s\n", argv[1]);
		exit(1);
	}
	yyparse();
	if (program_node != NULL) {
		cout << "#include <stdio.h>" << endl << endl;
		cout << program_node->gen_op_code() << endl;
		cout << "int main() {" << endl;
		cout << program_node->block->gen_statement_code();
		cout << "}" << endl;
	}
}

