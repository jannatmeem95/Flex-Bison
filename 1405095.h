#include<bits/stdc++.h>
using namespace std;
extern ofstream logout;
extern FILE* symbol;
//File *logout;
extern int no_;
extern int bucket;


class SymbolInfo
{
	string name;
	string type;
public:
	SymbolInfo *next;
	double value;
	string datatype;
	int siz,index;
	int *arr;
	float *arr1;
	int row, column;

	string return_type;
	int num_parameters;
	SymbolInfo *param_list;

	SymbolInfo() {}
	SymbolInfo(string n,string t)
	{
		next = NULL;
		row = 0;
		column = 0;
		name=n;
		type=t;
		value=-1000000;
		
	}
	void setname(string x) { name = x; }
	void setType(string x) { type = x; }
	void setsize(int n) {
		siz=n;
	}
	
	void setarray(string dtp) {
		if(dtp=="int"){arr=new int[siz]; cout<<"babababab\n\n";
			for(int i=0;i<siz;i++) arr[i]=-10000;}
		else if(dtp=="float") {arr1=new float[siz];cout<<"maaaaa\n\n";
			for(int i=0;i<siz;i++) {arr1[i]=-10000.0;cout<<arr1[i]<<"  ";} }
	}

	void setarrval(string datp,double value)
	{
		cout<<datp<<"  "<<index<<"   "<<value<<"\n\n";
		if(datp=="int") arr[index]=int(value);
		else arr1[index]=value;

	}
	//void setvalue(double n) {value=n;}
	//void setdatatype(string n) {datatype=n;}
	double getvalue(){ return value;}
	string getdatatype() { return datatype;}
	string getname() { return name; }
	string getType() { return type; }
	void insert_func(string ret,int num,SymbolInfo * point)
	{
		return_type=ret; num_parameters=num; param_list=point;
		
	}
};

class ScopeTable
{
	int hashfunc(string p) {
		return ((57 * (p[p.length() / 2] + p[p.length() / 3]  + p[0] + 111) % 1000000007) % bucket);
	}


public:
	int id;
	SymbolInfo **info;
	ScopeTable *parentScope;
	ScopeTable()
	{
		info = new SymbolInfo*[bucket];
		for (int i = 0; i<bucket; i++) info[i] = NULL;
		id = no_ + 1;
		no_ = id;
		parentScope = NULL;
	}
	~ScopeTable()
	{
		delete[] info;
	}

	SymbolInfo* Lookup(string a)
	{
		int w = hashfunc(a);
		SymbolInfo *p = info[w];
		while (p != NULL)
		{
			if (p->getname() == a) return p;
			p = p->next;
		}
		return NULL;
	}
	void insert_function(string a,string ret,int num,SymbolInfo * point)
	{	
		SymbolInfo * p= Lookup(a);
		if(p!=NULL) p->insert_func(ret,num,point);
	}
	bool Insert(string a, string b)
	{
		if (Lookup(a) == NULL)
		{
			SymbolInfo *p=new SymbolInfo(a,b);
			//p->setname(a);
			//p->setType(b);
			int x = hashfunc(a);
			p->row = x;
			if (info[x] != NULL) p->column = info[x]->column + 1;
			else p->column = 0;
			SymbolInfo *q = info[x];
			p->next = q;
			info[x] = p;
			return true;
		}
		return false;
	}
	
	void insert_val(string a,double val)
	{
		SymbolInfo * p= Lookup(a);
		if(p!=NULL){ p->value=val;cout<<"\n\n"<<a<<val;}
	}
	
	
	void insert_size(string a,int val)
	{
		SymbolInfo * p= Lookup(a);
		if(p!=NULL){ p->setsize(val);cout<<"\n\n"<<a<<val;}
	}

	void set_arrscope(string name,string dtp)
	{
		SymbolInfo * p= Lookup(name); if(p!=NULL){ p->setarray(dtp);}
	}
	
	void set_arrayval(string name,double val)
	{
		cout<<name<<"  "<<val<<"\n\n"; SymbolInfo * p= Lookup(name); if(p!=NULL){ p->setarrval(p->datatype,val);}
	}

	void insert_data(string a,string val)
	{
		SymbolInfo * p= Lookup(a);
		if(p!=NULL) {p->datatype=val;cout<<"yyyy  "<<p->datatype<<"\n\n";}
	}


	bool Delete(string &a)
	{
		int w = hashfunc(a);
		SymbolInfo *p = info[w];
		if(Lookup(a)==NULL)
        {
            cout<<"Not Found\n";
            return false;
        }
		if (p->getname() == a)
		{
			info[w] = info[w]->next;

			cout<<"Deleted From Current table "<<p->row<<","<<p->column<<endl;
			return true;
		}
		else
		{
		    //cout<<info[w]->column;
			while (p->next->getname() != a )
			{
			    p->column--;
				p = p->next;


			}
				cout<<"Deleted From Current table "<<p->next->row<<","<<(p->next->column)<<endl;
				p->next = p->next->next;
				return true;
		}//p->next e a ache


	}

	void print(FILE * symbol)
	{
		fprintf(symbol,"Scopetable  #    %d \n",id);
		for (int i = 0; i<bucket; i++)
		{
			
			if (info[i] != NULL)
			{
				fprintf(symbol,"%d----->",i);
				SymbolInfo *p = info[i];
				while (p != NULL)
				{
					//cout << "   < " << p->getname() << " : " << p->getType() << " >" << "  ";
					if(p->getType()=="FUNCTION") fprintf(symbol,"   <  %s %s : ID  >  ",p->getname().c_str(),p->return_type.c_str());
					else if(p->getType()!="ARRAY") fprintf(symbol,"   <  %s : %s : %f >  ",p->getname().c_str(),p->datatype.c_str(),p->value);
					else if(p->getType()=="ARRAY"){
						fprintf(symbol,"   < %s : %d : {",p->getname().c_str(),p->datatype);
						if(p->datatype=="int"){ for(int i=0;i<p->siz-1;i++) fprintf(symbol,"  %f ,",p->arr[i]); fprintf(symbol," %f } >",p->arr[p->siz-1]);}
						else if(p->datatype=="float"){ for(int i=0;i<p->siz-1;i++) fprintf(symbol,"  %f ,",p->arr1[i]); 
						fprintf(symbol," %f } >", p->arr1[p->siz-1]); }
					}
					
					p = p->next;
				}
				fprintf(symbol,"\n");
			}
			
		}
		fprintf(symbol,"\n");
	}
	
	void print()
	{
		cout<<"Scopetable  #    "<<id<<"\n\n";
		for (int i = 0; i<bucket; i++)
		{
			
			if (info[i] != NULL)
			{
				cout<<i<<"----->";
				SymbolInfo *p = info[i];
				while (p != NULL)
				{
					//cout << "   < " << p->getname() << " : " << p->getType() << " >" << "  ";
					if(p->getType()!="ARRAY") cout<<"   <"<< p->getname()<<"  , "<<p->datatype<<"  ,  "<<p->value<<" >";
					else{
						cout<<"   <"<<p->datatype<<"  ,  "<<p->getname()<<"  ,  {";
						if(p->datatype=="int"){ for(int i=0;i<p->siz-1;i++) cout<<p->arr[i]<<" , "; cout<<p->arr[p->siz-1]<<" }  >";}
						else if(p->datatype=="float"){ for(int i=0;i<p->siz-1;i++) cout<<p->arr1[i]<<" , "; 
						cout<<p->arr1[p->siz-1]<<" }  >"; }
					}
					p = p->next;
				}
				cout<<"\n\n";
			}
			
		}
		cout<<"\n\n";
	}

};

class SymbolTable
{
public:
	ScopeTable *curr_scope;
	SymbolTable() { curr_scope = new ScopeTable; }
	void EnterScope()
	{
		ScopeTable *b=new ScopeTable;
		b->parentScope = curr_scope;
		curr_scope=b;
		curr_scope->id = (curr_scope->parentScope->id) + 1;
		cout << "New ScopeTable with id " << curr_scope->id << " created" << '\n';
	}

	void ExitScope()
	{
		cout << "ScopeTable with id " << curr_scope->id << " removed." << '\n';
		ScopeTable* p = curr_scope->parentScope;
		curr_scope = p;
	}

	bool Insert_here(string a, string b)
	{
		bool x = curr_scope->Insert(a, b);
		//if (x == true) fprintf(logout, "Inserted in ScopeTable # << %d <<  at position   %d , %d \n",curr_scope->id,curr_scope->Lookup(a)->row,curr_scope->Lookup(a)->column) ;
		//else fprintf(logout, "already exists in current ScopeTable \n");
		return x;
	}

	void insertfunc(string a,string ret,int num,SymbolInfo * point)
	{	
		curr_scope->insert_function(a,ret,num,point);
	}
	
	void insert_value(string a,double val)
	{
		curr_scope->insert_val(a,val);
	}

	void insert_datatype(string a,string val)
	{
		curr_scope->insert_data(a,val);
	}
	
	void insert_size(string a,int val)
	{
		curr_scope->insert_size(a,val);
	}

	void set_arrtable(string name,string dtp)
	{
		curr_scope->set_arrscope(name,dtp);
	}

	void insert_arrval(string name,double val)
	{
		cout<<name<<"  "<<val<<"\n\n";curr_scope->set_arrayval(name,val);
	}

	bool Remove(string a)
	{
		return curr_scope->Delete(a);
	}

	SymbolInfo *Look_up(string a)
	{
		ScopeTable *p = curr_scope;
		while (p != NULL)
		{
			SymbolInfo *x = p->Lookup(a);
			if (x != NULL)
			{
				cout << "Found in ScopeTable# " << p->id << " at position " << x->row << ',' << x->column << '\n';
				return x;
			}
			p = p->parentScope;
		}
		cout << "Not found" << '\n';
		return NULL;
	}
	
	SymbolInfo *Look_curscope(string a)
	{
		SymbolInfo *x = curr_scope->Lookup(a);
		return x;
	}

	SymbolInfo *Look_globalscope(string a)
	{
		ScopeTable *p = curr_scope;
		while (p->parentScope!= NULL)
		{
			p = p->parentScope;
		}
		SymbolInfo *x = p->Lookup(a);
		return x;
	}

	void printCurrScope(FILE * symbol)
	{
		curr_scope->print(symbol);
	}

	void printCurrScope()
	{
		curr_scope->print();
	}

	void printAll(FILE * symbol)
	{
		ScopeTable *x = curr_scope;
		int p = x->id;
		while (p>0)
		{
			x->print(symbol);
			x = x->parentScope;
			p=p-1;
		}
	}

	void printAll()
	{
		ScopeTable *x = curr_scope;
		int p = x->id;
		while (p>0)
		{
			x->print();
			x = x->parentScope;
			p=p-1;
		}
	}
};
