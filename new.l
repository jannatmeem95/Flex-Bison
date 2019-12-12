%{
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include "1405095.h"
//#include "SymbolInfo.h"
#include "y.tab.h"


using namespace std;

char ch;

char abc[80];
char xyz[80];
int x=0;
int y=0;
int ll;

extern YYSTYPE yylval;
extern SymbolTable *table;
void yyerror(char *);
extern FILE *loglog;
int line_count=1;
int error_count=0;


%}



WHITESPACE [ \t\f\r\v]+
DIGIT [0-9]
NUMBER {DIGIT}*(\.{DIGIT}+)?(E[+-]?{DIGIT}+)?
ERROR_NUM {DIGIT}*([\.]+{DIGIT}+)+(E[+-]?[\.]+?{DIGIT}+)?
ERROR_NUM_E {DIGIT}*(\.{DIGIT}+)?(E[+-]?([\.]*{DIGIT}+[\.]+?{DIGIT}*)+)
LETTER [A-Za-z]
id [a-zA-Z_][a-zA-Z0-9_]*
SPECIAL_CHAR (("\\n")|("\\t")|("\\\\")|("\\\"")|("\\a")|("\\f")|("\\r")|("\\b")|("\\v"))
CONST_CHAR (.|("\\n")|("\\t")|("\\\\")|("\\\"")|("\\a")|("\\f")|("\\r")|("\\b")|("\\v"))
UNFINISHED_CHAR '.|("\\")'
MULTI_CHAR '({LETTER}{LETTER}+)'
UNTERM_CHAR ("\\")
%x MYSTATE_STR
%x LINE_COM
%x MULTI_COM

NEWLINE \n




%%
{NEWLINE} {line_count++;}

"if"	{
			//fprintf(tokenout," <IF> ");
			//fprintf(loglog,"Line no %d: TOKEN <IF> Lexeme %s found\n\n",line_count,yytext);
			return IF;
		}
		
"else"	{
			//fprintf(tokenout," <ELSE> ");
			//fprintf(loglog,"Line no %d: TOKEN <ELSE> Lexeme %s found\n\n",line_count,yytext);
			//return ELSE;
		}
"for" {
			//fprintf(tokenout," <FOR> ");
			//fprintf(loglog,"Line no %d: TOKEN <FOR> Lexeme %s found\n\n",line_count,yytext);
			return FOR;
		}
"while" {
			//fprintf(tokenout," <WHILE> ");
			//fprintf(loglog,"Line no %d: TOKEN <WHILE> Lexeme %s found\n\n",line_count,yytext);
			return  WHILE;
		}

"int" {
			//fprintf(tokenout," <INT> ");
			//fprintf(loglog,"Line no %d: TOKEN <INT> Lexeme %s found\n\n",line_count,yytext);
			return INT;
		}
"char" {
			//fprintf(tokenout," <CHAR> ");
			//fprintf(loglog,"Line no %d: TOKEN <CHAR> Lexeme %s found\n\n",line_count,yytext);
			return CHAR;
		}
"float" {
			//fprintf(tokenout," <FLOAT> ");
			//fprintf(loglog,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n\n",line_count,yytext);
			return FLOAT;
		}
"double" {
			//fprintf(tokenout," <DOUBLE> ");
			//fprintf(loglog,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n\n",line_count,yytext);
			return DOUBLE;
		}
"void" {
			//fprintf(tokenout," <VOID> ");
			//fprintf(loglog,"Line no %d: TOKEN <VOID> Lexeme %s found\n\n",line_count,yytext);
			return VOID;
		}
"return" {
			//fprintf(tokenout," <RETURN> ");
			//fprintf(loglog,"Line no %d: TOKEN <RETURN> Lexeme %s found\n\n",line_count,yytext);
			return RETURN;
		}
"do" {
			//fprintf(tokenout," <DO> ");
			//fprintf(loglog,"Line no %d: TOKEN <DO> Lexeme %s found\n\n",line_count,yytext);
			return DO;
		}

"default" {
			//fprintf(tokenout," <DEFAULT> ");
			//fprintf(loglog,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n\n",line_count,yytext);
			return DEFAULT;
		}
"continue" {
			//fprintf(tokenout," <CONTINUE> ");
			//fprintf(loglog,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n\n",line_count,yytext);
			return CONTINUE;
		}


"+"		|

"-"		{
			//fprintf(tokenout," <ADDOP,%s> ",yytext);
			//fprintf(loglog,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n\n",line_count,yytext);
			SymbolInfo *temp=new SymbolInfo(yytext,"ADDOP");
			yylval=(YYSTYPE)temp;
			return ADDOP;
			
		}
		
{DIGIT}+ 	{
				//fprintf(tokenout," <CONST_INT,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n\n",line_count,yytext);
				//bool p=sym.Insert_here(yytext,"CONST_INT");
				//if(p==true) sym.printCurrScope(loglog);
				//yylval.value=atof(yytext);
				SymbolInfo *temp=new SymbolInfo(yytext,"CONST_INT");
				temp->value=atof(yytext);
				temp->datatype="int";
				yylval=(YYSTYPE)temp;
				return CONST_INT;
			}
{NUMBER}	{
				//fprintf(tokenout," <CONST_FLOAT,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n\n",line_count,yytext);
				//bool p=sym.Insert_here(yytext,"CONST_FLOAT");
				//if(p==true) sym.printCurrScope(loglog);
				//yylval.value=atof(yytext);
				SymbolInfo *temp=new SymbolInfo(yytext,"CONST_FLOAT");
				temp->value=atof(yytext);
				temp->datatype="float";
				yylval=(YYSTYPE)temp;
				return CONST_FLOAT;
				
			} 

\'{CONST_CHAR}\' {
				char ch[yyleng-1];
				char c;
				
				for(int i=1;i<yyleng-1;i++) ch[i-1]=*(yytext+i);
				ch[yyleng-2]='\0';
				if(ch[0]!='\\') c=ch[0];
				else{
					if(ch[1]=='n') c='\n';
					else if(ch[1]=='t') c='\t';
					else if(ch[1]=='a') c='\a';
					else if(ch[1]=='f') c='\f';
					else if(ch[1]=='r') c='\r';
					else if(ch[1]=='b') c='\b';
					else if(ch[1]=='v') c='\v';
					else if(ch[1]=='0') c='\0';
					else if(ch[1]=='\\') c='\\';
					else if(ch[1]=='\"') c='\"';
					
				}
				

				//fprintf(tokenout," <CONST_CHAR, %c> ",c);
				//fprintf(loglog,"Line No. %d: token <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
				//bool p=sym.Insert_here(yytext,"CONST_CHAR");
				//if(p==true) sym.printCurrScope(loglog);
			SymbolInfo *s= new  SymbolInfo(yytext,"CONST_INT");
			yylval = (YYSTYPE)s;
			
			return CONST_CHAR;
				
			}

			
\'{UNTERM_CHAR}\'       {
			fprintf(loglog,"Error at line %d:Unterminated character %s\n\n",line_count,yytext);
			error_count=error_count+1;


	}
	



"<" |
"<=" |
">" |
">=" |
"==" |
"!="     {
				//fprintf(tokenout," <RELOP,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <RELOP> Lexeme %s found\n\n",line_count,yytext);
		SymbolInfo *s= new  SymbolInfo(yytext,"RELOP");
		yylval = (YYSTYPE)s;
		return RELOP;
				
			} 
"&&" |
"||"      {
				//fprintf(tokenout," <LOGICOP,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n\n",line_count,yytext);
			SymbolInfo *s= new  SymbolInfo(yytext, "LOGICOP");
			yylval = (YYSTYPE)s;
			
			return LOGICOP;
				
			} 


"!" {
				//fprintf(tokenout," <NOT,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <NOT> Lexeme %s found\n\n",line_count,yytext);
				
			return NOT;
			}
"=" {
				//fprintf(tokenout," <ASSIGN_OP,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <ASSIGN_OP> Lexeme %s found\n\n",line_count,yytext);
			return ASSIGN_OP;
				
			}
"*" |
"/" |
"%" {
				//fprintf(tokenout," <MULOP,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <MULOP> Lexeme %s found\n\n",line_count,yytext);
			SymbolInfo *s= new  SymbolInfo(yytext, "MULOP");
			yylval = (YYSTYPE)s;
			
			return MULOP;
				
			}
"++" {
				//fprintf(tokenout," <INCOP,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <INCOP> Lexeme %s found\n\n",line_count,yytext);
				
			return INCOP;
			}

"--" {
				//fprintf(tokenout," <INCOP,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <INCOP> Lexeme %s found\n\n",line_count,yytext);
				
			return DECOP;
			}

"(" {
				//fprintf(tokenout," <LPAREN,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n\n",line_count,yytext);
			return LPAREN;
				
			} 
")" {
				//fprintf(tokenout," <RPAREN,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n\n",line_count,yytext);
			return RPAREN;
				
			} 
"{" {
				//fprintf(tokenout," <LCURL,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <LCURL> Lexeme %s found\n\n",line_count,yytext);
			table->EnterScope();
			return LCURL;
				
			} 
"}" {
				//fprintf(tokenout," <RCURL,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <RCURL> Lexeme %s found\n\n",line_count,yytext);
			table->ExitScope();
			return RCURL;
				
			} 
"[" {
				//fprintf(tokenout," <LTHIRD,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n\n",line_count,yytext);
			return LTHIRD;
				
			} 
"]" {
				//fprintf(tokenout," <RTHIRD,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);
			return RTHIRD;
				
			} 
"," {
				//fprintf(tokenout," <COMMA,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <COMMA> Lexeme %s found\n\n",line_count,yytext);
			return COMMA;
				
			} 
";" {
				//fprintf(tokenout," <SEMICOLON,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n\n",line_count,yytext);
			return SEMICOLON;
				
			} 
{id} {
				//fprintf(tokenout," <ID,%s> ",yytext);
				//fprintf(loglog,"Line no %d: TOKEN <ID> Lexeme %s found\n\n",line_count,yytext);
			
				//bool p=sym.Insert_here(yytext,"ID");
				//if(p==true) sym.printCurrScope(loglog);
				SymbolInfo *s= table->Look_up(yytext);
				if(s==NULL)
				{					
					s= new SymbolInfo(yytext,"ID");
				}
				//cout<<"sdsf";
				yylval = (YYSTYPE)s;
				//cout<<"sdsf";
				return ID;
			} 


\"	{ 			BEGIN MYSTATE_STR;
				ll=line_count;
				xyz[y]='\"';
				y++;
			}

<MYSTATE_STR>(\")	{	BEGIN INITIAL;
				/*fprintf(tokenout," <STRING,");
				for(int i=0;i<x;i++) fprintf(tokenout,"%c",abc[i]);
				fprintf(tokenout,"> "); */
				
				fprintf(loglog,"Line no %d: TOKEN <STRING> Lexeme ",ll);
				xyz[y]='\"';
				for(int i=0;i<=y;i++) fprintf(loglog,"%c",xyz[i]);
				
				fprintf(loglog," found\n\n");
				x=0;
				y=0;
				
			}

<MYSTATE_STR>{WHITESPACE}* {	
				for(int i=0;i<yyleng;i++)
				{ 
					abc[x]=yytext[i];
					xyz[y]=yytext[i];
					x++;
					y++;
				}
			}

<MYSTATE_STR>{SPECIAL_CHAR} {
					char ch[yyleng];
					char c;
					for(int i=0;i<yyleng;i++) ch[i]=*(yytext+i);

					if(ch[1]=='n') c='\n';
					else if(ch[1]=='t') c='\t';
					else if(ch[1]=='a') c='\a';
					else if(ch[1]=='f') c='\f';
					else if(ch[1]=='r') c='\r';
					else if(ch[1]=='b') c='\b';
					else if(ch[1]=='v') c='\v';
					else if(ch[1]=='0') c='\0';
					else if(ch[1]=='\\') c='\\';
					else if(ch[1]=='\"') c='\"';


					for(int i=0;i<yyleng;i++)
					{
						xyz[y]=ch[i];
						y++;
					}
					abc[x]=c;
					x++;

				}




<MYSTATE_STR>("\\"){NEWLINE}  {		
				xyz[y]='\\';
				y++;
				xyz[y]='\n';
				y++;
				line_count++;
			}

<MYSTATE_STR>{NEWLINE} {
				BEGIN INITIAL;
				fprintf(loglog,"Error at Line no %d:Unterminated string",ll);
				for(int i=0;i<y;i++) fprintf(loglog,"%c",xyz[i]);
				fprintf(loglog,"\n\n");
				y=0;
				x=0;
				error_count=error_count+1;
				line_count++;
				
			}


<MYSTATE_STR><<EOF>> {		
		
			fprintf(loglog,"Error at Line no %d:Unterminated string",ll);
			for(int i=0;i<y;i++) fprintf(loglog,"%c",xyz[i]);
			fprintf(loglog,"\n");
			y=0;
			x=0;
			//sym.printCurrScope(loglog);
			error_count=error_count+1;
			fprintf(loglog,"Total Lines: %d\n\n",line_count); 
			fprintf(loglog,"Total Errors: %d\n\n",error_count);
			
			return 0;
	}
			

<MYSTATE_STR>.	{		for(int i=0;i<yyleng;i++)
				{ 
					abc[x]=yytext[i];
					x++;
					xyz[y]=yytext[i];
					y++;
				}
			}




(\/\/) 	{ 				
				BEGIN LINE_COM;
				ll=line_count;
				y=0;
				xyz[y]='/';
				xyz[1]='/';
				y+=2;
			}
<LINE_COM>("\\"){NEWLINE}  {		
				xyz[y]='\\';
				y++;
				xyz[y]='\n';
				y++;
				line_count++;
				
			}

<LINE_COM>{NEWLINE} {
				BEGIN INITIAL;
				fprintf(loglog,"Line no %d: TOKEN <COMMENT> Lexeme ",ll);
				for(int i=0;i<y;i++) fprintf(loglog,"%c",xyz[i]);
				
				fprintf(loglog," found\n\n");
				y=0;
				line_count++;
				
			}


<LINE_COM><<EOF>> {		
			fprintf(loglog,"Line no %d: TOKEN <COMMENT> Lexeme ",ll);
			for(int i=0;i<y;i++) fprintf(loglog,"%c",xyz[i]);
			fprintf(loglog,"\n\n");
			y=0;
			//sym.printCurrScope(loglog);
			fprintf(loglog,"Total Lines: %d\n\n",line_count); 
			fprintf(loglog,"Total Errors: %d\n\n",error_count);
			return 0;
	}

<LINE_COM>.	{		for(int i=0;i<yyleng;i++)
				{ 
					
					xyz[y]=yytext[i];
					y++;
				}
			}
			

(\/\*) { 				
				BEGIN MULTI_COM;
				ll=line_count;
				y=0;
				xyz[y]='/';
				xyz[1]='*';
				y+=2;
			} 

<MULTI_COM>{NEWLINE}  {		
				xyz[y]='\n';
				y++;
				line_count++;
				
			}

<MULTI_COM><<EOF>> {		
			fprintf(loglog,"Error at Line no %d:Unfinished comment",ll);
			for(int i=0;i<y;i++) fprintf(loglog,"%c",xyz[i]);
			fprintf(loglog," found\n");
			y=0;
			//sym.printCurrScope(loglog);
			error_count=error_count+1;
			fprintf(loglog,"Total Lines: %d\n\n",line_count); 
			fprintf(loglog,"Total Errors: %d\n\n",error_count);
			return 0;
	}


<MULTI_COM>(\*\/) {
				xyz[y]='*';
				y++;
				xyz[y]='/';	
				BEGIN INITIAL;
				fprintf(loglog,"Line no %d: TOKEN <COMMENT> Lexeme ",ll);
				for(int i=0;i<=y;i++) fprintf(loglog,"%c",xyz[i]);
				
				fprintf(loglog," found\n\n");
				y=0;
				
				
			}


<MULTI_COM>.	{		for(int i=0;i<yyleng;i++)
				{ 
					
					xyz[y]=yytext[i];
					y++;
				}
			}





\'\'    {			fprintf(loglog,"Error at Line no %d: Empty Character %s \n\n",line_count,yytext);
				error_count=error_count+1;
			}




{ERROR_NUM}     {
-				fprintf(loglog,"Error at Line no %d: Too many decimal point error for character sequence %s \n\n",line_count,yytext);
				error_count=error_count+1;
			} 
{ERROR_NUM_E}	{
				fprintf(loglog,"Error at Line no %d: Ill formed number %s \n\n",line_count,yytext);
				error_count=error_count+1;
			} 


{DIGIT}+[_a-zA-Z0-9]+ {
			fprintf(loglog,"Error at Line no %d: Invalid prefix on ID or invalid suffix on Number %s\n\n",line_count,yytext); 
			error_count++;
}





\'[^\n\'][^\n\']+\'   {
				fprintf(loglog,"Error at Line no %d: Multi character constant error %s \n\n",line_count,yytext);
				error_count=error_count+1;
			} 

\'[^\n\']*(\')?  {
				fprintf(loglog,"Error at line %d: Unterminated Character %s\n\n",line_count, yytext);
				error_count=error_count+1;
			}




{WHITESPACE} {}



<<EOF>>      	{
		
			//sym.printCurrScope(loglog);
			fprintf(loglog,"Total Lines: %d\n\n",line_count); 
			fprintf(loglog,"Total Errors: %d\n\n",error_count);
			
			return 0;


	}

. {
				fprintf(loglog,"Line no %d: Unrecognized character %s \n\n",line_count,yytext);
				error_count=error_count+1;
			} 



%% 

int yywrap(void)
{
	return 1;
}






