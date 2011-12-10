#ifndef SIMB_TABLE_H_
#define SIMB_TABLE_H_

#include <string>
#include <list>
#include <vector>
#include <map>
#include "opascal_tree.h"
#include "util.h"

using namespace std;

enum TypeID { Int_Type, Class_Type, Void_Type };

enum Modifier { Virtual, Override, None };

//class ClassDef;

struct Type
{
	TypeID	 type_id;
	//ClassDef *class_def;
	string class_id;
};

struct ParameterDef
{
	string	parameter_name;
	Type	parameter_type;

	ParameterDef(string name, Type type)
	{
		parameter_name = name;
		parameter_type = type;
	}
};

typedef list<ParameterDef *>		ParameterDefList;
typedef map<string, ParameterDef *>	ParameterDefMap;

class MethodDef
{
public:
	string		 method_name;
	string		 classOwner;
	Type		 method_return_type;
	Modifier	 modifier;
	ParameterDefList *method_parameter_list;
	ParameterDefMap	 *method_parameter_map;
	Statement	 *method_body;

	MethodDef(string name) { method_name = name; }
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
};

typedef list<MethodDef *> MethodDefList;
typedef vector<MethodDef *> MethodDefVector;
typedef map<string, MethodDef *> MethodDefMap;

class VariableDef
{
public:
	string	variable_name;
	Type	variable_type;

	VariableDef(string name, Type type)
	{
		variable_name = name;
		variable_type = type;
	}
};

typedef list<VariableDef *> VariableDefList;
typedef map<string, VariableDef *> VariableDefMap;

class ClassDef
{
public:
	string		name;
	string		base;
//	ClassDef	*base;
	VariableDefList *field_def_list;
	VariableDefMap  *field_def_map;

	MethodDefList   *method_def_list;
	MethodDefList   *virtualmethod_def_list;
	MethodDefList   *overridemethod_def_list;

	MethodDefMap 	*method_def_map;

	ClassDef() {
		name = "";
		base = "";//NULL;
		field_def_list = NULL;
		field_def_map  = NULL;

		method_def_list = NULL;
		virtualmethod_def_list = NULL;
		overridemethod_def_list = NULL;

		method_def_map = NULL;
	}

	ClassDef(string name)
	{
		//ClassDef();
		this->name = name;
		base = "";
	}

	~ClassDef()
	{
		FreeList(field_def_list);	
		FreeList(method_def_list);
		FreeList(virtualmethod_def_list);
		FreeList(overridemethod_def_list);
		field_def_map->clear();
		method_def_map->clear();
	}
};

typedef map<string, ClassDef *> ClassDefMap;
#endif /* SIMB_TABLE_H_ */
