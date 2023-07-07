#include "lexer.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

uint8_t is_digit(char c) { return (c >= '0' && c <= '9') ? 1 : 0; }

uint8_t is_letter(char c) {
  return ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_') ? 1 : 0;
}

uint8_t is_whitespace(char c) {
  return c == ' ' || c == '\t' || c == '\r' || c == '\n';
}

struct _Lexer {
  size_t pos;
  char ch;
  char la;
  size_t line_no;
  size_t col_no;
  size_t input_len;
  char *input;
};

void lexer_read_char(Lexer *l);

Lexer *lexer_new(char *input, size_t input_len) {
  Lexer *l;
  l = calloc(1, sizeof *l);
  if (l == NULL) {
    return NULL;
  }
  l->line_no = 1;
  l->col_no = 1;
  l->input = input;
  l->input_len = input_len;
  return l;
}

void lexer_read_string(Lexer *l, Token *tok) {
  tok->type = TT_STRING;
  while (l->la != '\0' && l->la != '"') {
    if (l->la == '\\') {
      lexer_read_char(l);
      ++(tok->length);
    }
    lexer_read_char(l);
    ++(tok->length);
  }
  if (l->la == '"') {
    lexer_read_char(l);
    ++(tok->length);
  }
}

void lexer_read_whitespace(Lexer *l, Token *tok) {
  tok->type = TT_WHITESPACE;
  while (is_whitespace(l->la)) {
    lexer_read_char(l);
    ++(tok->length);
  }
}

void lexer_read_comment(Lexer *l, Token *tok) {
  tok->type = TT_COMMENT;
  while (l->la != '\0' && l->la != '\n') {
    lexer_read_char(l);
    ++(tok->length);
  }
  if (l->la == '\n') {
    lexer_read_char(l);
    ++(tok->length);
  }
}

void lexer_read_number(Lexer *l, Token *tok) {
  tok->type = TT_INTEGER;
  while (is_digit(l->la) || l->la == '_') {
    lexer_read_char(l);
    ++(tok->length);
  }
  if (l->la == '.') {
    tok->type = TT_FLOAT;
    lexer_read_char(l);
    ++(tok->length);
    while (is_digit(l->la) || l->la == '_') {
      lexer_read_char(l);
      ++(tok->length);
    }
  }
  if (l->la == 'e' || l->la == 'E') {
    tok->type = TT_FLOAT;
    lexer_read_char(l);
    ++(tok->length);
    if (l->la == '+' || l->la == '-') {
      lexer_read_char(l);
      ++(tok->length);
    }
    while (is_digit(l->la) || l->la == '_') {
      lexer_read_char(l);
      ++(tok->length);
    }
  }
}

typedef struct {
  char *const word;
  size_t word_length;
  int const type;
} Keyword;

Keyword const keywords[] = {
    {"let", 3, TT_LET},
    {"true", 4, TT_TRUE},
    {"false", 5, TT_FALSE},
    {"and", 3, TT_AND},
    {"or", 2, TT_OR},
    {"xor", 3, TT_XOR},
    {"not", 3, TT_NOT},
    {"if", 2, TT_IF},
    {"else", 4, TT_ELSE},
    {"while", 5, TT_WHILE},
    {"foreach", 7, TT_FOREACH},
    {"as", 2, TT_AS},
    {"function", 8, TT_FUNCTION},
    {"return", 6, TT_RETURN},
};

size_t const KEYWORD_LEN = sizeof(keywords) / sizeof(keywords[0]);

void lexer_read_identifier(Lexer *l, Token *tok) {
  tok->type = TT_IDENTIFIER;
  size_t length = 1;
  while (is_letter(l->la) || is_digit(l->la)) {
    lexer_read_char(l);
    ++length;
  }
  tok->length = (int)length;
  for (size_t i = 0; i < KEYWORD_LEN; i++) {
    Keyword keyword = keywords[i];
    if (keyword.word_length == length &&
        (strncmp(keyword.word, tok->str, length) == 0)) {
      tok->type = keyword.type;
      break;
    }
  }
}

void lexer_match_if(Lexer *l, Token *tok, char c, TokenType if_type,
                    TokenType else_type) {
  if (l->la == c) {
    tok->type = if_type;
    ++(tok->length);
    lexer_read_char(l);
  } else {
    tok->type = else_type;
  }
}

void lexer_next_token(Lexer *l, Token *tok) {
  tok->line_no = l->line_no;
  tok->col_no = l->col_no;
  tok->str = l->input + l->pos;
  tok->length = 1;

  lexer_read_char(l);

  switch (l->ch) {
  case '\0':
    tok->type = TT_EOF;
    tok->str = "";
    tok->length = 0;
    return;
  case '#':
    lexer_read_comment(l, tok);
    return;
  case ';':
    tok->type = TT_SEMICOLON;
    return;
  case ':':
    tok->type = TT_COLON;
    return;
  case ',':
    tok->type = TT_COMMA;
    return;
  case '(':
    tok->type = TT_LPAREN;
    return;
  case ')':
    tok->type = TT_RPAREN;
    return;
  case '[':
    tok->type = TT_LBRACKET;
    return;
  case ']':
    tok->type = TT_RBRACKET;
    return;
  case '{':
    tok->type = TT_LCURLY;
    return;
  case '}':
    tok->type = TT_RCURLY;
    return;
  case '^':
    tok->type = TT_POW;
    return;
  case '~':
    lexer_match_if(l, tok, '=', TT_ASSIGN_CONCAT, TT_CONCAT);
    return;
  case '+':
    lexer_match_if(l, tok, '=', TT_ASSIGN_ADD, TT_ADD);
    return;
  case '-':
    lexer_match_if(l, tok, '=', TT_ASSIGN_SUBTRACT, TT_SUBTRACT);
    return;
  case '*':
    lexer_match_if(l, tok, '=', TT_ASSIGN_MULTIPLY, TT_MULTIPLY);
    return;
  case '/':
    lexer_match_if(l, tok, '=', TT_ASSIGN_DIVIDE, TT_DIVIDE);
    return;
  case '%':
    lexer_match_if(l, tok, '=', TT_ASSIGN_MOD, TT_MOD);
    return;
  case '=':
    lexer_match_if(l, tok, '=', TT_EQUAL, TT_ASSIGN);
    return;
  case '!':
    lexer_match_if(l, tok, '=', TT_NOT_EQUAL, TT_ILLEGAL);
    return;
  case '<':
    lexer_match_if(l, tok, '=', TT_LESS_EQUAL, TT_LESS_THAN);
    return;
  case '>':
    lexer_match_if(l, tok, '=', TT_GREATER_EQUAL, TT_GREATER_THAN);
    return;
  case '"':
    lexer_read_string(l, tok);
    return;
  default:
    if (is_whitespace(l->ch)) {
      lexer_read_whitespace(l, tok);
    } else if (is_digit(l->ch)) {
      lexer_read_number(l, tok);
    } else if (is_letter(l->ch)) {
      lexer_read_identifier(l, tok);
    } else {
      tok->type = TT_ILLEGAL;
    }
    return;
  }
}

void lexer_read_char(Lexer *l) {
  size_t len = l->input_len;
  if (l->pos >= len) {
    l->ch = 0;
    l->la = 0;
  } else {
    l->ch = l->input[l->pos++];
    if (l->ch == '\n') {
      l->line_no++;
      l->col_no = 0;
    }
    l->col_no++;
    if (l->pos < len) {
      l->la = l->input[l->pos];
    }
  }
}

char *token_type_str(TokenType t) {
  switch (t) {
  case TT_ILLEGAL:
    return "illegal";
  case TT_EOF:
    return "eof";
  case TT_WHITESPACE:
    return "whitespace";
  case TT_COMMENT:
    return "comment";
  case TT_SEMICOLON:
    return ";";
  case TT_COLON:
    return ":";
  case TT_COMMA:
    return ",";
  case TT_LPAREN:
    return "(";
  case TT_RPAREN:
    return ")";
  case TT_LBRACKET:
    return "[";
  case TT_RBRACKET:
    return "]";
  case TT_LCURLY:
    return "{";
  case TT_RCURLY:
    return "}";
  case TT_CONCAT:
    return "~";
  case TT_ADD:
    return "+";
  case TT_SUBTRACT:
    return "-";
  case TT_MULTIPLY:
    return "*";
  case TT_DIVIDE:
    return "/";
  case TT_MOD:
    return "%";
  case TT_POW:
    return "^";
  case TT_ASSIGN:
    return "=";
  case TT_ASSIGN_CONCAT:
    return "~=";
  case TT_ASSIGN_ADD:
    return "+=";
  case TT_ASSIGN_SUBTRACT:
    return "-=";
  case TT_ASSIGN_MULTIPLY:
    return "*=";
  case TT_ASSIGN_DIVIDE:
    return "/=";
  case TT_ASSIGN_MOD:
    return "%=";
  case TT_EQUAL:
    return "==";
  case TT_NOT_EQUAL:
    return "!=";
  case TT_LESS_THAN:
    return "<";
  case TT_LESS_EQUAL:
    return "<=";
  case TT_GREATER_THAN:
    return ">";
  case TT_GREATER_EQUAL:
    return ">=";
  case TT_INTEGER:
    return "integer";
  case TT_FLOAT:
    return "float";
  case TT_STRING:
    return "string";
  case TT_IDENTIFIER:
    return "id";
  case TT_LET:
    return "let";
  case TT_TRUE:
    return "true";
  case TT_FALSE:
    return "false";
  case TT_AND:
    return "and";
  case TT_OR:
    return "or";
  case TT_XOR:
    return "xor";
  case TT_NOT:
    return "not";
  case TT_IF:
    return "if";
  case TT_ELSE:
    return "else";
  case TT_WHILE:
    return "while";
  case TT_FOREACH:
    return "foreach";
  case TT_AS:
    return "as";
  case TT_FUNCTION:
    return "function";
  case TT_RETURN:
    return "return";
  }
  return "unknown";
}
