#ifndef SIMB_TABLE_H_
#define SIMB_TABLE_H_

#include <string>
#include <list>
#include <map>
#include "opascal_tree.h"
#include "util.h"

using namespace std;

enum TypeID { Int_Type, Class_Type };

class ClassDef;

struct Type {
	TypeID 	type_id;
	ClassDef *class_def;
};

struct ParameterDef
{
		ParameterDef(string name, Type type)
		{
			parameter_name = name;
			parameter_type = type;
		}

		string parameter_name;
		Type parameter_type;
};

typedef list<ParameterDef *> ParameterDefList;
typedef map<string, ParameterDef *> ParameterDefMap;

class MethodDef
{
	public:
		MethodDef(string name)
		{
			method_name = name;
		}

		~MethodDef()
		{
			if (method_parameter_list != 0) {
				FreeList(method_parameter_list);
				delete method_parameter_list;
			}
			
			if (method_parameter_map != 0) {
				method_parameter_map->clear();
				delete method_parameter_map;
			}
		}

		string method_name;
		Type method_return_type;
		ParameterDefList *method_parameter_list;
		ParameterDefMap *method_parameter_map;
		Statement *method_body;
};

typedef list<MethodDef *> MethodDefList;
typedef map<string, MethodDef *> MethodDefMap;

class VariableDef
{
public:
	VariableDef(string name, Type type)
	{
		variable_name = name;
		variable_type = type;
	}
	
	string variable_name;
	Type variable_type;
};

typedef list<VariableDef *> VariableDefList;
typedef map<string, VariableDef *> VariableDefMap;

class ClassDef
{
	public:
		ClassDef()
		{
			name = "";
		}

		ClassDef(string name)
		{
			ClassDef();
			this->name = name;
		}

		~ClassDef()
		{
			FreeList(&field_def_list);	
			FreeList(&method_def_list);
			field_def_map.clear();
			method_def_map.clear();
		}

		string name;
		VariableDefList field_def_list;
		MethodDefList   method_def_list;
		VariableDefMap  field_def_map;
		MethodDefMap 	method_def_map;
};

typedef map<string, ClassDef *> ClassDefMap;
#endif /* SIMB_TABLE_H_ */
