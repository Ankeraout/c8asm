%{
#include "parser.h"

#define YY_DECL int yylex()

%}

%option yylineno
%option noyywrap
%option caseless

%%

[\t ] {}
\n|\r|\r\n { return TOK_NEWLINE; }

CLS { return KEYWORD_CLS; }
RET { return KEYWORD_RET; }
SYS { return KEYWORD_SYS; }
JP { return KEYWORD_JP; }
CALL { return KEYWORD_CALL; }
SE { return KEYWORD_SE; }
SNE { return KEYWORD_SNE; }
LD { return KEYWORD_LD; }
ADD { return KEYWORD_ADD; }
OR { return KEYWORD_OR; }
AND { return KEYWORD_AND; }
XOR { return KEYWORD_XOR; }
SUBN { return KEYWORD_SUBN; }
SUB { return KEYWORD_SUB; }
SHR { return KEYWORD_SHR; }
SHL { return KEYWORD_SHL; }
RND { return KEYWORD_RND; }
DRW { return KEYWORD_DRW; }
SKP { return KEYWORD_SKP; }
SKNP { return KEYWORD_SKNP; }
SCD { return KEYWORD_SCD; }
SCR { return KEYWORD_SCR; }
SCL { return KEYWORD_SCL; }
EXIT { return KEYWORD_EXIT; }
LOW { return KEYWORD_LOW; }
HIGH { return KEYWORD_HIGH; }

I { return KEYWORD_I; }
DT { return KEYWORD_DT; }
K { return KEYWORD_K; }
ST { return KEYWORD_ST; }
F { return KEYWORD_F; }
B { return KEYWORD_B; }
HF { return KEYWORD_HF; }
R { return KEYWORD_R; }

\[ { return TOK_LBRACKET; }
\] { return TOK_RBRACKET; }
, { return TOK_COMMA; }
: { return TOK_COLON; }
;.*\n {}

- { return TOK_MINUS; }
\+ { return TOK_PLUS; }
\* { return TOK_MULTIPLY; }
\/ { return TOK_DIVIDE; }
\<\< { return TOK_SHIFT_LEFT; }
\>\> { return TOK_SHIFT_RIGHT; }
& { return TOK_AND; }
\| { return TOK_OR; }
\^ { return TOK_XOR; }
! { return TOK_NOT; }
\( { return TOK_LPAREN; }
\) { return TOK_RPAREN; }

ORG { return KEYWORD_ORG; }
DB { return KEYWORD_DB; }

V[0-9A-F] {
	if(yytext[1] >= '0' && yytext[1] <= '9') {
		yylval.ival = yytext[1] - '0';
	} else if(yytext[1] >= 'A' && yytext[1] <= 'F') {
		yylval.ival = yytext[1] - 'A' + 10;
	} else {
		yylval.ival = yytext[1] - 'a' + 10;
	}
	
	return REGISTER_Vx;
}

0b[01]+ { 
	yylval.ival = 0;
	
	int i = 2;
	
	while(yytext[i] != '\0') {
		yylval.ival *= 2;
		yylval.ival += yytext[i] - '0';
		i++;
	}
	
	return NUMBER;
}

0o[0-7]+ {
	yylval.ival = 0;
	
	int i = 2;
	
	while(yytext[i] != '\0') {
		yylval.ival *= 8;
		yylval.ival += yytext[i] - '0';
		i++;
	}
	
	return NUMBER;
}

0d[0-9]+ {
	yylval.ival = 0;
	
	int i = 2;
	
	while(yytext[i] != '\0') {
		yylval.ival *= 10;
		yylval.ival += yytext[i] - '0';
		i++;
	}
	
	return NUMBER;
}

0x[0-9A-F]+ {
	yylval.ival = 0;
	
	int i = 2;
	
	while(yytext[i] != '\0') {
		yylval.ival *= 16;
		
		if(yytext[i] >= '0' && yytext[i] <= '9') {
			yylval.ival += yytext[i] - '0';
		} else if(yytext[i] >= 'A' && yytext[i] <= 'F') {
			yylval.ival += yytext[i] - 'A' + 10;
		} else {
			yylval.ival += yytext[i] - 'a' + 10;
		}
		
		i++;
	}
	
	return NUMBER;
}

[0-9]+ {
	yylval.ival = 0;
	
	int i = 0;
	
	while(yytext[i] != '\0') {
		yylval.ival *= 10;
		yylval.ival += yytext[i] - '0';
		i++;
	}
	
	return NUMBER;
}

[A-Z_][A-Z0-9_]* {
	yylval.sval = strdup(yytext);
	return IDENTIFIER;
}

. {
	fprintf(stderr, "Error: Unexpected character '%c' on line %d.\n", yytext[0], yylineno);
	exit(1);
}

%%
