%{
#include<stdio.h>
%}

signs unsigned|signed
types {signs}*[ ]*int[*]*[ ]|{signs}*[ ]*float[*]*[ ]|{signs}*[ ]*double[*]*[ ]|{signs}*[ ]*char[*]*[ ]|void[ ]

%%

{types}.*"(".*")"	{ printf(" Method:"); ECHO; }
	/*cleaning stuff*/
\n[ \t]?\n	;

%%

void main()
{
yylex();
}
