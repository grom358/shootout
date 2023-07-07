#ifndef __LEXER_H__
#define __LEXER_H__

#include <cstddef>
#include <string_view>

using namespace std;

enum TokenType {
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
  TT_RETURN
};

const char* tokenTypeName(TokenType type);

TokenType tokenTypeKeyword(string_view literal);

struct Token {
  TokenType type;
  size_t line_no;
  size_t col_no;
  string_view text;
};

class Lexer {
public:
  Lexer(string_view input);
  Token getNextToken();

private:
  size_t read_position = 0;
  size_t position = 0;
  size_t read_line_no = 1;
  size_t line_no = 1;
  size_t read_col_no = 1;
  size_t col_no = 1;
  char ch = '\0';
  char la = '\0';
  size_t length;
  string_view input;

  inline void readChar();
  inline Token match(TokenType token_type);
  inline Token matchIf(char if_ch, TokenType if_token_type, TokenType else_token_type);
  inline Token matchWhitespace();
  inline Token matchComment();
  inline Token matchString();
  inline Token matchIdentifier();
  inline Token matchNumber();
};

#endif
