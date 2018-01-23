%{
#include<stdio.h>
#include<string.h>
int constructors = 0;
int methods = 0;
int copyConstructor = 0;
int destructor = 0;
int overloaded = 0;
int newMethods = 0;
char *class;
char *allMethods[30];
char *metMethods[30]; /*refactoring rule of 30*/
%}

%s INSIDECLASS

className [A-Z][A-Za-z0-9]*
methodName [a-z][A-Za-z0-9_]*
accessModifiers public|private|protected
signs unsigned|signed
types {signs}*[ ]*int[*]*[ ]|{signs}*[ ]*float[*]*[ ]|{signs}*[ ]*double[*]*[ ]|{signs}*[ ]*char[*]*[ ]|void[ ]
constructor {className}[ ]*"("
method {methodName}[ ]*"("
destructor "~"{className}
copyconstructor "const "{className}" &"
parameter {methodName}[ ]*
linecomment "//".*"\n"|"/*".*"*/"
insidecomment .*\n*
extendedcomment "/*"{insidecomment}*"*/"
localVariable {types}[ *A-Za-z0-9,_]*"\["*[0-9]*"\]"*[ =]*[0-9\.]*";"
empty [\n][ \t]*[\n]

%%

<INITIAL>{className}	{ class = (char*)malloc(yyleng * sizeof(char));
	/*store name of the class*/
	strcpy(class, yytext);
	/*reinitializez*/
	copyConstructor = 0; destructor = 0; constructors = 0;
	methods = 0; newMethods = 0;
	BEGIN(INSIDECLASS); ECHO; printf("\n"); }
					
	/*get rid of comments*/	
<INSIDECLASS>.?[ \t]*{linecomment}	{ printf("\n"); }

<INSIDECLASS>{extendedcomment}	;

<INSIDECLASS>{localVariable}	;

	/*find constructors*/
<INSIDECLASS>{constructor}	{ if (yytext[yyleng-2] == ' ') 
		yyless(yyleng-2);
	else
		yyless(yyleng-1);
	if (!strcmp(class, yytext)) {
		printf ("Constructor: ");
		ECHO; constructors++;} }

<INSIDECLASS>{method}	{ int added = 0;
	allMethods[methods] = (char*)malloc(yyleng * sizeof(char));
	if (yytext[yyleng-2] == ' ') 
		yyless(yyleng-2);
	else
		yyless(yyleng-1);
	ECHO;
	/*store all methods inhere*/
	strcpy(allMethods[methods], yytext);
	if (methods > 0) {
		for (int i = 0; i < newMethods; i++) {
			if (strcmp(metMethods[i], yytext) == 0) {
				added = 1;
				break;
			}
		}
		/*store the first apparition of each method (metMethods)*/
		if (added != 1) {
			metMethods[newMethods] = (char*)malloc(yyleng * sizeof(char));
			strcpy(metMethods[newMethods], yytext);
			newMethods++;
		}
	} else {
		/*the case of the first method*/
		metMethods[newMethods] = (char*)malloc(yyleng * sizeof(char));
		strcpy(metMethods[newMethods], yytext); 
		newMethods++; }
	methods++; }

	/*get rid of parameters of a method and keep only the type of them*/
<INSIDECLASS>{parameter}")"|{parameter}","|{parameter}";"	{ char isVoid[5]; 
	strncpy(isVoid, yytext, 4);
	isVoid[5] = '\0';
	if(strcmp(isVoid, "void") == 0) {
		ECHO;
	} else {
		if (yytext[yyleng-1] == ',') 
			printf(",");
		if (yytext[yyleng-1] == ')')
			printf(")");} }

	/*find the copy constructor and destructor*/
<INSIDECLASS>{destructor}	{ printf("Destructor: "); ECHO; destructor = 1; }

<INSIDECLASS>{className}[ ]*"("[ ]*{copyconstructor}	{ 
	printf("Copy Constructor: "); ECHO; copyConstructor = 1; }

<INSIDECLASS>public|private|protected	;

<INSIDECLASS>[ \t]+	putchar(' ');

	/*at the end of a class print all variables and jump to INITIAL state*/
<INSIDECLASS>"};"	{ int contor;
	for (int i = 0; i < newMethods; i++) {
		contor = 0;
		for (int j = 0; j < methods; j++) {
			if (strcmp(metMethods[i],allMethods[j]) == 0) {
				contor++;
			}
		}
		if (contor > 1)
			overloaded += contor;
	}
	printf("  \n-constructors: %d\n", constructors);
	printf("-copy constructor: %d\n", copyConstructor);
	printf("-destructor: %d\n", destructor);
	printf("-methods: %d\n", methods);
	printf("-overloaded methods: %d\n", overloaded);
	BEGIN(INITIAL); }

	/*delete remainings*/
;|\}|\{|:	;

%%

void main()
{
yylex();
}
