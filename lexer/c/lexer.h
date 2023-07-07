#ifndef __LEXER_H__
#define __LEXER_H__

#include <stddef.h>

typedef enum {
  TT_ILLEGAL,
  TT_EOF,

  TT_WHITESPACE,
  TT_COMMENT,

  TT_SEMICOLON,
  TT_COLON,
  TT_COMMA,

  TT_LPAREN,
  TT_RPAREN,
  TT_LBRACKET,
  TT_RBRACKET,
  TT_LCURLY,
  TT_RCURLY,

  TT_CONCAT,
  TT_ADD,
  TT_SUBTRACT,
  TT_MULTIPLY,
  TT_DIVIDE,
  TT_MOD,
  TT_POW,
  TT_ASSIGN,
  TT_ASSIGN_CONCAT,
  TT_ASSIGN_ADD,
  TT_ASSIGN_SUBTRACT,
  TT_ASSIGN_MULTIPLY,
  TT_ASSIGN_DIVIDE,
  TT_ASSIGN_MOD,
  TT_EQUAL,
  TT_NOT_EQUAL,
  TT_LESS_THAN,
  TT_LESS_EQUAL,
  TT_GREATER_THAN,
  TT_GREATER_EQUAL,

  TT_INTEGER,
  TT_FLOAT,
  TT_STRING,
  TT_IDENTIFIER,

  TT_LET,
  TT_TRUE,
  TT_FALSE,
  TT_AND,
  TT_OR,
  TT_XOR,
  TT_NOT,
  TT_IF,
  TT_ELSE,
  TT_WHILE,
  TT_FOREACH,
  TT_AS,
  TT_FUNCTION,
  TT_RETURN,
} TokenType;

typedef struct {
  TokenType type;
  size_t line_no;
  size_t col_no;
  int length;
  char *str;
} Token;

typedef struct _Lexer Lexer;

extern Lexer *lexer_new(char *input, size_t input_len);
extern void lexer_next_token(Lexer *l, Token *token);
extern char *token_type_str(TokenType t);

#endif
