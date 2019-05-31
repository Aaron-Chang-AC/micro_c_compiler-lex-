/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void c_comment(void);
	void cpp_comment(void);
	void c_quota(void);
	void count_add(void);
%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
number {digit}+


/* Rules section */
%%

"//" 	{printf("%s",yytext); cpp_comment(); printf(" \t C++ comment\n");}
"/*" 	{printf("%s",yytext); c_comment(); printf(" \t C comment\n");}

"+" 	{ printf("%s \t ADD\n", yytext); }
"-"		{ printf("%s \t SUB\n", yytext); }
"*" 	{printf("%s \t MUL\n", yytext);}
"/"	{printf("%s \t DIV\n",yytext);}
"%"	{printf("%s \t MOD\n",yytext);}
"++" 	{printf("%s \t INC\n",yytext);}
"--" 	{printf("%s \t DEC\n",yytext);}
">" 	{printf("%s \t MT\n",yytext);}
"<" 	{printf("%s \t LT\n",yytext);}
">="    {printf("%s \t MTE\n",yytext);}
"<="    {printf("%s \t LTE\n",yytext);}
"==" 	{printf("%s \t EQ\n",yytext);}
"!=" 	{printf("%s \t NE\n",yytext);}
"["	{printf("%s \t LSB\n",yytext);}
"]"	{printf("%s \t RSB\n",yytext);}
","	{printf("%s \t COMMA\n",yytext);}
";"     {printf("%s \t SEMICOLON\n",yytext);}
"\""	{printf("%s \t QUOTA\n",yytext); c_quota();}
"print"	{printf("%s \t PRINT\n",yytext);}
"if"	{printf("%s \t IF\n",yytext);}
"else"	{printf("%s \t ELSE\n",yytext);}
"for"	{printf("%s \t FOR\n",yytext);}
"while"	{printf("%s \t WHILE\n",yytext);}
"string"	{printf("%s \t STRING\n",yytext);}
"int"	{printf("%s \t INT\n",yytext);}
"float"	{printf("%s \t FLOAT\n",yytext);}
"="	{printf("%s \t ASGN\n",yytext);}
"+="	{printf("%s \t ADDASGN\n",yytext);}
"-="	{printf("%s \t SUBASGN\n",yytext);}
"*="	{printf("%s \t MULASGN\n",yytext);}
"/="	{printf("%s \t DIVASGN\n",yytext);}
"%="	{printf("%s \t MODASGN\n",yytext);}
"&&"	{printf("%s \t AND\n",yytext);}
"||"	{printf("%s \t OR\n",yytext);}
"!"	{printf("%s \t NOT\n",yytext);}
"("	{printf("%s \t LB\n",yytext);}
")"	{printf("%s \t RB\n",yytext);}
"{"	{printf("%s \t LCB\n",yytext);}
"}"	{printf("%s \t RCB\n",yytext);}
"void"	{printf("%s \t VOID\n",yytext);}
"bool"	{printf("%s \t BOOL\n",yytext);}
"true"	{printf("%s \t TRUE\n",yytext);}
"false"	{printf("%s \t FALSE\n",yytext);}
"return"	{printf("%s \t RET\n",yytext);}
"continue"	{printf("%s \t CONT\n",yytext);}
"break"	{printf("%s \t BREAK\n",yytext);}
{number}	{printf("%s \t I_CONST\n",yytext);}
{number}+.{number}+	{printf("%s \t F_CONST\n",yytext);}



{id}	{ printf("%s \t ID\n", yytext); }
[ \t\f\v]			{;}
[\n]	{count_add();}

%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}
int count=0;
int comment_count=0;
void c_comment(){
	comment_count++;
	char ipt;
	while(1){
		while(ipt=input()){
			putchar(ipt);
			if(ipt == '\n'){
				comment_count++;
				count++;
			}
			if(ipt == '*' || ipt == 0){
				break;
				
			}
		}
		ipt=input();
		putchar(ipt);
		if(ipt == '/' || ipt == 0){
			if((ipt=input()) == '\n'){
				count++;
			}
			break;
		}
		else{
			if(ipt == '\n'){
				comment_count++;
				count++;
			}
			continue;
		}
	}
	return;
}
void cpp_comment(){
	char ipt;
	comment_count++;
	while(ipt=input()){
		if((ipt != '\n') && (ipt != EOF)){
			putchar(ipt);
		}
		else{
			if(ipt == '\n'){
				count++;
			}
			break;
		}
	}
	return;
}
void c_quota(){
	char ipt;
	char S[100000];
	int i=0,j=0;
	int cnt_c=0;
	memset(S,'\0',100000);
	while(ipt=input()){
		if(ipt == '\"' && S[j]!='\\'){
			break;
		}
		else{
			S[i]=ipt;
			j=i;
			i++;
			cnt_c++;
		}
	}
	if(cnt_c != 0){
		printf("%s \t STR_CONST\n",S);
	}
	printf("%c \t QUOTA\n",ipt);
	return;
}
void count_add(){
	count++;
	return;
}
int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d.\n\n",count);
	printf("comment: %d lines\n\n",comment_count);

	return 0;
}
