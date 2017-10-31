/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_SRC_PARSER_H_INCLUDED
# define YY_YY_SRC_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    REGISTER_Vx = 258,
    NUMBER = 259,
    IDENTIFIER = 260,
    KEYWORD_CLS = 261,
    KEYWORD_RET = 262,
    KEYWORD_SYS = 263,
    KEYWORD_JP = 264,
    KEYWORD_CALL = 265,
    KEYWORD_SE = 266,
    KEYWORD_SNE = 267,
    KEYWORD_LD = 268,
    KEYWORD_ADD = 269,
    KEYWORD_OR = 270,
    KEYWORD_AND = 271,
    KEYWORD_XOR = 272,
    KEYWORD_SUB = 273,
    KEYWORD_SHR = 274,
    KEYWORD_SUBN = 275,
    KEYWORD_SHL = 276,
    KEYWORD_RND = 277,
    KEYWORD_DRW = 278,
    KEYWORD_SKP = 279,
    KEYWORD_SKNP = 280,
    KEYWORD_SCD = 281,
    KEYWORD_SCR = 282,
    KEYWORD_SCL = 283,
    KEYWORD_EXIT = 284,
    KEYWORD_LOW = 285,
    KEYWORD_HIGH = 286,
    KEYWORD_I = 287,
    KEYWORD_DT = 288,
    KEYWORD_K = 289,
    KEYWORD_ST = 290,
    KEYWORD_F = 291,
    KEYWORD_B = 292,
    KEYWORD_HF = 293,
    KEYWORD_R = 294,
    TOK_LBRACKET = 295,
    TOK_RBRACKET = 296,
    TOK_COMMA = 297,
    TOK_COLON = 298,
    TOK_NEWLINE = 299,
    KEYWORD_ORG = 300,
    KEYWORD_DB = 301
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 22 "src/parser.y" /* yacc.c:1909  */

	int ival;
	char* sval;

#line 106 "src/parser.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_PARSER_H_INCLUDED  */
