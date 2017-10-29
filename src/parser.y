%{
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern FILE* yyin;

void yyerror(const char* s);

extern int yylineno;

extern void define_label(char* name, int address);
extern void wanted_label(char* name, int address);
extern void buffer_writeByte(uint8_t byte);
extern void change_org(int address);
extern int currentBufferAddress();
extern void die(char* error);

%}

%union {
	int ival;
	char* sval;
}

%token<ival> REGISTER_Vx;
%token<ival> NUMBER;
%token<sval> IDENTIFIER;

%token KEYWORD_CLS;
%token KEYWORD_RET;
%token KEYWORD_SYS;
%token KEYWORD_JP;
%token KEYWORD_CALL;
%token KEYWORD_SE;
%token KEYWORD_SNE;
%token KEYWORD_LD;
%token KEYWORD_ADD;
%token KEYWORD_OR;
%token KEYWORD_AND;
%token KEYWORD_XOR;
%token KEYWORD_SUB;
%token KEYWORD_SHR;
%token KEYWORD_SUBN;
%token KEYWORD_SHL;
%token KEYWORD_RND;
%token KEYWORD_DRW;
%token KEYWORD_SKP;
%token KEYWORD_SKNP;
%token KEYWORD_SCD;
%token KEYWORD_SCR;
%token KEYWORD_SCL;
%token KEYWORD_EXIT;
%token KEYWORD_LOW;
%token KEYWORD_HIGH;

%token KEYWORD_I;
%token KEYWORD_DT;
%token KEYWORD_K;
%token KEYWORD_ST;
%token KEYWORD_F;
%token KEYWORD_B;
%token KEYWORD_HF;
%token KEYWORD_R;

%token TOK_LBRACKET;
%token TOK_RBRACKET;
%token TOK_COMMA;
%token TOK_COLON;
%token TOK_NEWLINE;

%token KEYWORD_ORG;
%token KEYWORD_DB;

%start program

%%

program
	: org_directive TOK_NEWLINE program
	| org_directive TOK_NEWLINE
	| org_directive
	| db_directive TOK_NEWLINE program
	| db_directive TOK_NEWLINE
	| db_directive
	| instruction TOK_NEWLINE program
	| instruction TOK_NEWLINE
	| instruction
	| label_definition program
	| label_definition
	| TOK_NEWLINE program
	| TOK_NEWLINE
	| 
	;
	
label_definition
	: IDENTIFIER TOK_COLON {
		define_label($1, currentBufferAddress());
	}
	| IDENTIFIER {
		define_label($1, currentBufferAddress());
	}
	;
	
instruction
	: instruction_cls
	| instruction_ret
	| instruction_sys
	| instruction_jp
	| instruction_call
	| instruction_se
	| instruction_sne
	| instruction_ld
	| instruction_add
	| instruction_or
	| instruction_and
	| instruction_xor
	| instruction_sub
	| instruction_shr
	| instruction_subn
	| instruction_shl
	| instruction_rnd
	| instruction_drw
	| instruction_skp
	| instruction_sknp
	| instruction_scd
	| instruction_scr
	| instruction_scl
	| instruction_exit
	| instruction_low
	| instruction_high
	;
	
instruction_cls
	: KEYWORD_CLS {
		buffer_writeByte(0x00);
		buffer_writeByte(0xe0);
	}
	;

instruction_ret
	: KEYWORD_RET {
		buffer_writeByte(0x00);
		buffer_writeByte(0xee);
	}
	;
	
instruction_sys
	: KEYWORD_SYS NUMBER {
		buffer_writeByte(0x00 | (($2 >> 8) & 0x0f));
		buffer_writeByte($2 & 0xff);
	}
	| KEYWORD_SYS IDENTIFIER {
		wanted_label($2, currentBufferAddress());
		buffer_writeByte(0x00);
		buffer_writeByte(0x00);
	}
	;
	
instruction_jp
	: KEYWORD_JP REGISTER_Vx TOK_COMMA IDENTIFIER {
		if($2 == 0) {
			wanted_label($4, currentBufferAddress());
			buffer_writeByte(0xb0);
			buffer_writeByte(0x00);
		} else {
			die("Only V0 is allowed here");
		}
	}
	| KEYWORD_JP REGISTER_Vx TOK_COMMA NUMBER {
		if($2 == 0) {
			buffer_writeByte(0xb0 | (($4 >> 8) & 0x0f));
			buffer_writeByte($4 & 0xff);
		} else {
			die("Only V0 is allowed here");
		}
	} 
	| KEYWORD_JP IDENTIFIER {
		wanted_label($2, currentBufferAddress());
		buffer_writeByte(0x10);
		buffer_writeByte(0x00);
	}
	| KEYWORD_JP NUMBER {
		buffer_writeByte(0x10 | (($2 >> 8) & 0x0f));
		buffer_writeByte($2 & 0xff);
	}
	;
	
instruction_call
	: KEYWORD_CALL IDENTIFIER {
		wanted_label($2, currentBufferAddress());
		buffer_writeByte(0x20);
		buffer_writeByte(0x00);
	}
	| KEYWORD_CALL NUMBER {
		buffer_writeByte(0x20 | (($2 >> 8) & 0x0f));
		buffer_writeByte($2 & 0xff);
	}
	;
	
instruction_se
	: KEYWORD_SE REGISTER_Vx TOK_COMMA NUMBER {
		buffer_writeByte(0x30 | $2);
		buffer_writeByte($4 & 0xff);
	}
	| KEYWORD_SE REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x50 | $2);
		buffer_writeByte($4 << 4);
	}
	;
	
instruction_sne
	: KEYWORD_SNE REGISTER_Vx TOK_COMMA NUMBER {
		buffer_writeByte(0x40 | $2);
		buffer_writeByte($4 & 0xff);
	}
	| KEYWORD_SNE REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x90 | $2);
		buffer_writeByte($4 << 4);
	}
	;
	
instruction_ld
	: KEYWORD_LD REGISTER_Vx TOK_COMMA NUMBER {
		buffer_writeByte(0x60 | $2);
		buffer_writeByte($4);
	}
	| KEYWORD_LD REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte($4 << 4);
	}
	| KEYWORD_LD KEYWORD_I TOK_COMMA IDENTIFIER {
		wanted_label($4, currentBufferAddress());
		buffer_writeByte(0xa0);
		buffer_writeByte(0x00);
	}
	| KEYWORD_LD KEYWORD_I TOK_COMMA NUMBER {
		buffer_writeByte(0xa0 | (($4 >> 8) & 0x0f));
		buffer_writeByte($4 & 0xff);
	}
	| KEYWORD_LD REGISTER_Vx TOK_COMMA KEYWORD_DT {
		buffer_writeByte(0xf0 | $2);
		buffer_writeByte(0x07);
	}
	| KEYWORD_LD REGISTER_Vx TOK_COMMA KEYWORD_K {
		buffer_writeByte(0xf0 | $2);
		buffer_writeByte(0x0a);
	}
	| KEYWORD_LD KEYWORD_DT TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $4);
		buffer_writeByte(0x15);
	}
	| KEYWORD_LD KEYWORD_ST TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $4);
		buffer_writeByte(0x08);
	}
	| KEYWORD_LD KEYWORD_F TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $4);
		buffer_writeByte(0x29);
	}
	| KEYWORD_LD KEYWORD_B TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $4);
		buffer_writeByte(0x33);
	}
	| KEYWORD_LD TOK_LBRACKET KEYWORD_I TOK_RBRACKET TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $6);
		buffer_writeByte(0x55);
	}
	| KEYWORD_LD REGISTER_Vx TOK_COMMA TOK_LBRACKET KEYWORD_I TOK_RBRACKET {
		buffer_writeByte(0xf0 | $2);
		buffer_writeByte(0x65);
	}
	| KEYWORD_LD KEYWORD_HF TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $4);
		buffer_writeByte(0x30);
	}
	| KEYWORD_LD KEYWORD_R TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $4);
		buffer_writeByte(0x75);
	}
	| KEYWORD_LD REGISTER_Vx TOK_COMMA KEYWORD_R {
		buffer_writeByte(0xf0 | $2);
		buffer_writeByte(0x85);
	}
	;
	
instruction_add
	: KEYWORD_ADD REGISTER_Vx TOK_COMMA NUMBER {
		buffer_writeByte(0x70 | $2);
		buffer_writeByte($4);
	}
	| KEYWORD_ADD REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(($4 << 4) | 0x04);
	}
	| KEYWORD_ADD KEYWORD_I TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0xf0 | $4);
		buffer_writeByte(0x1e);
	}
	;
	
instruction_or
	: KEYWORD_OR REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(($4 << 4) | 0x01);
	}
	;
	
instruction_and
	: KEYWORD_AND REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(($4 << 4) | 0x02);
	}
	;
	
instruction_xor
	: KEYWORD_XOR REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(($4 << 4) | 0x03);
	}
	;
	
instruction_sub
	: KEYWORD_SUB REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(($4 << 4) | 0x05);
	}
	;
	
instruction_shr
	: KEYWORD_SHR REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(0x06);
	}
	;
	
instruction_subn
	: KEYWORD_SUBN REGISTER_Vx TOK_COMMA REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(($4 << 4) | 0x07);
	}
	;
	
instruction_shl
	: KEYWORD_SHL REGISTER_Vx {
		buffer_writeByte(0x80 | $2);
		buffer_writeByte(0x0e);
	}
	;
	
instruction_rnd
	: KEYWORD_RND REGISTER_Vx TOK_COMMA NUMBER {
		buffer_writeByte(0xc0 | $2);
		buffer_writeByte($4);
	}
	;
	
instruction_drw
	: KEYWORD_DRW REGISTER_Vx TOK_COMMA REGISTER_Vx TOK_COMMA NUMBER {
		buffer_writeByte(0xd | $2);
		buffer_writeByte(($4 << 4) | $6);
	}
	;
	
instruction_skp
	: KEYWORD_SKP REGISTER_Vx {
		buffer_writeByte(0xe0 | $2);
		buffer_writeByte(0x9e);
	}
	;
	
instruction_sknp
	: KEYWORD_SKNP REGISTER_Vx {
		buffer_writeByte(0xe0 | $2);
		buffer_writeByte(0xa1);
	}
	;
	
instruction_scd
	: KEYWORD_SCD NUMBER {
		buffer_writeByte(0x00);
		buffer_writeByte(0xc0 | $2);
	}
	;
	
instruction_scr
	: KEYWORD_SCR {
		buffer_writeByte(0x00);
		buffer_writeByte(0xfb);
	}
	;
	
instruction_scl
	: KEYWORD_SCL {
		buffer_writeByte(0x00);
		buffer_writeByte(0xfc);
	}
	;
	
instruction_exit
	: KEYWORD_EXIT {
		buffer_writeByte(0x00);
		buffer_writeByte(0xfd);
	}
	;
	
instruction_low
	: KEYWORD_LOW {
		buffer_writeByte(0x00);
		buffer_writeByte(0xfe);
	}
	;
	
instruction_high
	: KEYWORD_HIGH {
		buffer_writeByte(0x00);
		buffer_writeByte(0xff);
	}
	;
	
org_directive
	: KEYWORD_ORG NUMBER {
		change_org($2);
	}
	;
	
db_directive
	: KEYWORD_DB NUMBER {
		buffer_writeByte($2);
	}
	;

%%

void yyerror(const char* s) {
	fprintf(stderr, "Error: %s on line %d.\n", s, yylineno);
	exit(1);
}
