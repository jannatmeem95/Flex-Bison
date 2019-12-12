%{
#include<iostream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<fstream>
#include "1405095.h"
#define YYSTYPE SymbolInfo*

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE *loglog;
FILE *symbol;
SymbolTable *table=new SymbolTable;
SymbolInfo ** dec_list=new SymbolInfo*[50];
int counter=0;


int no_ = 0;
int bucket=3;
ofstream logout;
extern int line_count;
extern int error_count;
FILE *fp;
FILE *fp1;
FILE *fp2;

void yyerror(char *s)
{
	fprintf(stderr,"%s\n",s);
	return;//write your code
}


%}

%token IF ELSE FOR WHILE INT FLOAT DOUBLE RETURN VOID PRINTLN ADDOP MULOP ASSIGN_OP RELOP LOGICOP NOT SEMICOLON COMMA LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD INCOP DECOP CONST_INT CONST_FLOAT ID CHAR CONST_CHAR DO CONTINUE DEFAULT 


%left '+' '-'
%left '*' '/'
//%right

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE 




%%

start : program
	{
		
		logout<<"Total Lines: "<<line_count<<"\n\n"<<endl;cout<<"Kgukhikj\n\n"; table->printAll(symbol);

		
		//logout<<"Total Errors: "<<error_count<<endl;
	}
	;

program : program unit
	{
		
		logout<<"Line no :"<<line_count<<" program:program unit\n\n";
	} 
	| 
	unit
	{
		
		logout<<"Line no :"<<line_count<<" program:unit\n\n";
	}
	;
	
unit : var_declaration
	{
		
		logout<<"Line no :"<<line_count<<"  unit:var_declaration\n\n";
	}
     	| 
     	func_declaration
     	{
		
		logout<<"Line no :"<<line_count<<" unit:func_declaration\n\n ";
     	}
     	| 
     	func_definition
     	{
		
		logout<<"Line no :"<<line_count<<" unit:func_declaration\n\n";
		
     	}
     	;
    


 
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
			{
				
				logout<<"Line no :"<<line_count<<" func_declaration:type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n"; cout<< "parina\n\n";cout<<"bekub\n\n";
				SymbolInfo* x=new SymbolInfo($2->getname(),"FUNCTION");x->param_list=$4;  table->Insert_here($2->getname(),"FUNCTION");x->return_type=$1->datatype; cout<<$1->datatype;
				 table->printAll(symbol);int i=1; SymbolInfo*p=x;
				while (p != NULL)
				{
					i++;
					p = p->next;
				}	x->num_parameters=i; $$=x; cout<<"ppppp"<<$$->return_type<<$$->num_parameters<<"wwwww\n\n"; table->insertfunc($2->getname(),x->return_type,i,x->param_list);
					}
		 	;



		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
			{
				
				logout<<"Line no :"<<line_count<<" func_definition:type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n";table->printAll();
				SymbolInfo* x=new SymbolInfo($2->getname(),"FUNCTION");x->param_list=$4; x->return_type=$1->datatype;
				cout<<$1->datatype;
				 table->printAll(symbol);int i=1; SymbolInfo*p=x; SymbolInfo* q=table->Look_up($2->getname()); SymbolInfo* r=q->param_list;bool val=true;
				if(q!=NULL){	
					while (p != NULL)
					{
						i++; if(p->datatype!=r->datatype) { val=false;break;}
						p = p->next;r=r->next;
					}if((i!=q->num_parameters)||(x->return_type!=q->return_type)) val=false;  }  x->num_parameters=i; 
					if((val==true)&&(q==NULL)) {  table->Insert_here($2->getname(),"FUNCTION"); $$=x; cout<<"ppppp"<<$$->return_type<<$$->num_parameters<<"wwwww\n\n"; 
					table->insertfunc($2->getname(),x->return_type,i,x->param_list);}
					
				
			}
 		 	;


parameter_list : parameters {$$=$1;}
		|
		;

 		 
parameters  : parameters COMMA type_specifier ID        	{

									logout<<"Line no :"<<line_count<<" parameters  : parameters COMMA type_specifier ID\n\n";
								         $$=$3; $3->next=$1; cout<<"nananaj\n\n";


								}

								

		| parameters COMMA type_specifier		{	
									logout<<"Line no :"<<line_count<<" parameters:parameters COMMA type_specifier	 		    \n  \n";
									$$=$3; $3->next=$1;

								}							


	 
 		| type_specifier ID			    	 {

									logout<<"Line no :"<<line_count<<" parameters:type_specifier ID\n\n";
									 $$=$1;cout<<"eeeee\n\n";
						
								}




 		| type_specifier				 {	
									logout<<"Line no: "<<line_count<<" parameters:type_specifier\n\n";$$=$1;


								}
 
 		;





 		
compound_statement : LCURL statements RCURL		{

								logout<<"Line no :"<<line_count<<" compound_statement: LCURL statements RCURL\n\n";


							}




 		    | LCURL RCURL			{
								logout<<"Line no :"<<line_count<<" compound_statement: LCURL RCURL\n\n";
		

							}
 		    ;


 		    
var_declaration : type_specifier declaration_list SEMICOLON	{

									logout<<"Line no: "<<line_count<<" var_declaration:type_specifier declaration_list SEMICOLON\n\n";
									for(int i=0;i<counter;i++){
													if(dec_list[i]->getType()=="ARRAY"){ cout<<"chagol\n\n"; 
													string s= $1->datatype;  table->set_arrtable(dec_list[i]->getname(),$1->datatype);}
                                                                                           
												        table->insert_datatype(dec_list[i]->getname(),$1->datatype);
													//cout<<dec_list[i]->getname()<<"   "<<dec_list[i]->datatype<<"   "<<"\n\n";
													dec_list[i]=NULL;
										}
									counter=0; table->printAll();





}
 		 ;



 		 
type_specifier	: INT		{

					logout<<"Line no :"<<line_count<<" type_specifier: INT\n\n";
					SymbolInfo* x=new SymbolInfo("INT","int");x->datatype="int";
					$$=x; //logout<<$$->getType()<<"\n\n";

				}



 		| FLOAT		{
					
					logout<<"Line no :"<<line_count<<" type_specifier: FLOAT\n\n";
					SymbolInfo* x=new SymbolInfo("FLOAT","float");x->datatype="float";
					$$=x;

			}



 		| VOID		{

					logout<<"Line no :"<<line_count<<" type_specifier: VOID\n\n";
					SymbolInfo* x=new SymbolInfo("VOID","void");x->datatype="void";
					$$=x;
					

				}
 		;
 		
declaration_list : declaration_list COMMA ID { logout<<"Line no: "<<line_count<<" declaration_list: declaration_list COMMA ID\n\n";
						dec_list[counter]=$3; counter++; table->Insert_here($3->getname(),$3->getType());
							// cout<<$3->getname()<<"\n\n";
							//cout<<dec_list[counter]->getname()<<dec_list[counter]->getType()<<"\n\n";
						


						}



 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD	{
										logout<<"Line no :"<<line_count<<" declaration_list: declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n";		
										SymbolInfo* x=new SymbolInfo($3->getname(),"ARRAY"); x->setsize($5->value);cout<<"abjgysguehbjb"<<"       "<<x->siz<<"\n\n"; 
										table->Insert_here($3->getname(),"ARRAY"); table->insert_size($3->getname(),$5->value);
										dec_list[counter]=x; counter++; $$=x;






									}



 		  | ID				{


							logout<<"Line no :"<<line_count<<" declaration_list: ID\n\n";	
							dec_list[counter]=$1; counter++; table->Insert_here($1->getname(),$1->getType()); //cout<<$1->getname()<<$1->getType()<<"\n\n";
							//cout<<$1->getname()<<"\n\n";
							

						}
			


 		  | ID LTHIRD CONST_INT RTHIRD		{

								logout<<"Line no :"<<line_count<<" declaration_list: ID LTHIRD CONST_INT RTHIRD\n\n";
								SymbolInfo* x=new SymbolInfo($1->getname(),"ARRAY"); x->setsize($3->value); 
								table->Insert_here($1->getname(),"ARRAY"); table->insert_size($1->getname(),$3->value);
								dec_list[counter]=x; counter++; $$=x; cout<<"abjgysguehbjb"<<"       "<<x->siz<<"\n\n";


							}
 		  ;
 


		  
statements : statement		{logout<<"Line no :"<<line_count<<" statements: statement\n\n";}



	   | statements statement	{logout<<"Line no :"<<line_count<<" statements :statements statement\n\n";}
	   ;




	   
statement : var_declaration		{logout<<"Line no :"<<line_count<<" statement: var_declaratio\n\n";$$=$1;}


	  | expression_statement	{logout<<"Line no :"<<line_count<<" statement:expression_statement\n\n";$$=$1;}



	  | compound_statement		{logout<<"Line no :"<<line_count<<" statement:compound_statement\n\n";$$=$1;}


	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement	{logout<<"Line no :"<<line_count<<" statement: FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n";}





	  | IF LPAREN expression RPAREN statement  %prec LOWER_THAN_ELSE 	{logout<<"Line no :"<<line_count<<" statement: IF LPAREN expression RPAREN statement\n\n";}




	  | IF LPAREN expression RPAREN statement ELSE statement	{logout<<"Line no :"<<line_count<<" statement: IF LPAREN expression RPAREN statement ELSE statement\n\n";}




	  | WHILE LPAREN expression RPAREN statement		 {logout<<"Line no :"<<line_count<<" statement:WHILE LPAREN expression RPAREN statement\n\n";}




	  | PRINTLN LPAREN ID RPAREN SEMICOLON			{logout<<"Line no :"<<line_count<<" statement:PRINTLN LPAREN ID RPAREN SEMICOLON\n\n";}






	  | RETURN expression SEMICOLON		{logout<<"Line no :"<<line_count<<" statement:RETURN expression SEMICOLON\n\n";}
	  ;
	  
expression_statement 	: SEMICOLON		{logout<<"Line no :"<<line_count<<" expression_statement:SEMICOLON\n\n";$$=$1;}


			
			| expression SEMICOLON 		{logout<<"Line no :"<<line_count<<" expression_statement:expression SEMICOLON\n\n";}
			;
	  
variable : ID 		{logout<<"Line no :"<<line_count<<"variable:ID\n\n";$$=$1;table->Insert_here($1->getname(),$1->getType());}


	
	 | ID LTHIRD expression RTHIRD 		 {logout<<"Line no :"<<line_count<<" variable: ID LTHIRD expression RTHIRD\n\n";SymbolInfo* x=$1;
							if(($3->datatype=="int")&&($3->value<$1->siz)) {x->index=$3->value;cout<<"baame id*****"<<x->index ; $$=x;}    //check koro agey theke assign kora kina
						}




	 ;
	 
expression : logic_expression		{logout<<"Line no :"<<line_count<<" expression: logic_expression\n\n";$$=$1;}



	   | variable ASSIGN_OP logic_expression 	{logout<<"Line no :"<<line_count<<" expression:variable ASSIG_NOP logic_expression\n\n"; SymbolInfo* pp=table->Look_up($1->getname());
							cout<<$3->getname()<<$3->datatype<<$3->value;
						if(pp!=NULL){
							if($1->datatype==$3->datatype) {
							if($1->getType()=="ARRAY") { cout<<"vroomvroom  "<<$3->value<<"   "<<$1->index<<"\n\n"; if($1->datatype=="int") $1->arr[$1->index]=$3->value; 
											else $1->arr1[$1->index]=$3->value; 
											table->insert_arrval($1->getname(),$3->value); }

							else { $1->value=$3->value ;  //cout<<$1->getname()<<$1->datatype<<$1->value;
										table->insert_value($1->getname(),$1->value); }
							table->printCurrScope(); }
							}	
		}
	   ;
			
logic_expression : rel_expression 	{logout<<"Line no :"<<line_count<<" logic_expression: rel_expression\n\n";$$=$1;}	


		 | rel_expression LOGICOP rel_expression 	 {logout<<"Line no :"<<line_count<<" logic_expression:rel_expression LOGICOP rel_expression\n\n";
									string s=$2->getname();int p;
									if(s=="&&"){if($1->value && $3->value) p=1;else p=0;}
									else if(s=="||"){if($1->value || $3->value) p=1;else p=0;}
									SymbolInfo* x=new SymbolInfo("",""); x->datatype="int"; x->value=p; $$=x;
}


	
		 ;
			
rel_expression	: simple_expression 		{logout<<"Line no :"<<line_count<<" rel_expression:simple_expression\n\n";$$=$1;}



		| simple_expression RELOP simple_expression	{logout<<"Line no :"<<line_count<<" rel_expression:simple_expression RELOP simple_expression\n\n";
								string s=$2->getname();int p;
								if(s=="<"){if($1->value<$3->value) p=1;else p=0;}
								else if(s==">"){if($1->value>$3->value) p=1;else p=0;}
								else if(s=="<="){if($1->value<=$3->value) p=1;else p=0;}
								else if(s==">="){if($1->value>=$3->value) p=1;else p=0;}
								else if(s=="=="){if($1->value==$3->value) p=1;else p=0;}
								else if(s=="!="){if($1->value!=$3->value) p=1;else p=0;}
								SymbolInfo* x=new SymbolInfo("",""); x->datatype="int"; x->value=p; $$=x;
								}


		;
				
simple_expression : term 		{logout<<"Line no :"<<line_count<<" simple_expression:term\n\n";$$=$1;}



		  | simple_expression ADDOP term 	 {logout<<"Line no :"<<line_count<<" simple_expression:simple_expression ADDOP term\n\n";string s;
							 if(($1->datatype=="float")||($3->datatype=="float")) s="float";
							 else s="int";
							 SymbolInfo* x=new SymbolInfo("","");x->datatype=s;
							 if($2->getname()=="+") x->value=$1->value+$3->value;
							 else x->value=$1->value-$3->value;
							 $$=x;
}



		  ;
					
term :	unary_expression		{logout<<"Line no :"<<line_count<<" term:unary_expression\n\n";$$=$1;}
				






     |  term MULOP unary_expression		{logout<<"Line no :"<<line_count<<" term:term MULOP unary_expression\n\n";string s;
							 if(($1->datatype=="float")||($3->datatype=="float")) s="float";
							 else s="int";
							 SymbolInfo* x=new SymbolInfo("","");x->datatype=s;
							 if($2->getname()=="*") x->value=$1->value*$3->value;
							 else if($2->getname()=="/") x->value=$1->value/$3->value;
							 else if((s=="int")&&($2->getname()=="%")) x->value=int($1->value)%int($3->value);
							 $$=x;
}






     ;

unary_expression : ADDOP unary_expression 		{logout<<"Line no :"<<line_count<<" unary_expression:ADDOP unary_expression\n\n";SymbolInfo* x=new SymbolInfo("","");x->datatype=$2->datatype;
							 if($1->getname()=="-") x->value=-$2->value;
							 else x->value=$2->value;
							 $$=x;
	}


 
		 | NOT unary_expression 		{logout<<"Line no :"<<line_count<<" unary_expression: NOT unary_expression\n\n";SymbolInfo* x=new SymbolInfo("","");x->datatype=$2->datatype;
							 x->value=!$2->value; $$=x;
	}




		 | factor 				{logout<<"Line no :"<<line_count<<" unary_expression : factor\n\n";$$=$1;}



		 ;
	
factor	: variable 		{logout<<"Line no :"<<line_count<<" factor:variable\n\n";SymbolInfo* x=new SymbolInfo("","");
					if($1->getType()=="ARRAY") { if($1->datatype=="int") x->value=$1->arr[$1->index];
									else x->value=$1->arr1[$1->index];
									 x->datatype=$1->datatype; $$=x; cout<<"brovrodo"<<x->value<<"\n\n";}
					else $$=$1;
}

									
				



	| ID LPAREN argument_list RPAREN	{logout<<"Line no :"<<line_count<<" factor:ID LPAREN argument_list RPAREN\n\n";}



	| LPAREN expression RPAREN		{logout<<"Line no :"<<line_count<<" factor : LPAREN expression RPAREN\n\n";}



	| CONST_INT 				{logout<<"Line no :"<<line_count<<" factor : CONST_INT\n\n";$$=$1;}


	| CONST_FLOAT				{logout<<"Line no :"<<line_count<<" factor : CONST_FLOAT\n\n";$$=$1;}


	
	| variable INCOP 			{  logout<<"Line no :"<<line_count<<" factor : variable INCOP\n\n";SymbolInfo* x=new SymbolInfo("","");
						
						if($1->getType()=="ARRAY"){if($1->datatype=="int")  x->value=$1->arr[$1->index]+1;
										else x->value=$1->arr1[$1->index]+1;
										table->insert_arrval($1->getname(),x->value) ; }
						else 	x->value=$1->value+1; 
						x->datatype=$1->datatype; $$=x;
						}


	| variable DECOP			{logout<<"Line no :"<<line_count<<" factor : variable DECOP\n\n";
						SymbolInfo* x=new SymbolInfo("","");
						if($1->getType()=="ARRAY"){if($1->datatype=="int")  x->value=$1->arr[$1->index]-1;
										else x->value=$1->arr1[$1->index]-1;
										table->insert_arrval($1->getname(),x->value) ; }
						else 	x->value=$1->value-1; 
						x->datatype=$1->datatype; $$=x;
						}




	;

argument_list : arguments {logout<<"Line no :"<<line_count<<" argument_list:arguments\n\n";} 
	       
		|

  	        ;

arguments : arguments COMMA logic_expression		{logout<<"Line no :"<<line_count<<" arguments:arguments COMMA logic_expression\n\n";}



	      | logic_expression				{logout<<"Line no :"<<line_count<<" arguments: logic_expression\n\n";}


	      ;
 
%%




int main(int argc,char *argv[])
{


	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}
	SymbolTable *table=new SymbolTable;
	SymbolInfo ** dec_list=new SymbolInfo*[50];
	yylval=new SymbolInfo();
	int counter=0;
	logout.open("parse.txt");
	fp2= fopen("log.txt","w");
	symbol=fopen("symbol.txt","w");
	loglog=fopen("lexlog.txt","w");
	//fclose(fp2);
	//fp3= fopen(argv[3],"w");
	//fclose(fp3);
	
	fp2= fopen("log.txt","a");
	//fp3= fopen(argv[3],"a");
	

	yyin=fp;
	yyparse();
	
	fclose(symbol);
	fclose(fp2);
	fclose(loglog);
	
	return 0;
}

