#include "lexer.h"

const char *tokenTypeName(TokenType type) {
  switch (type) {
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
  default:
    return "unknown";
  }
}

TokenType tokenTypeKeyword(string_view literal) {
  if (literal == "let") {
    return TT_LET;
  } else if (literal == "true") {
    return TT_TRUE;
  } else if (literal == "false") {
    return TT_FALSE;
  } else if (literal == "if") {
    return TT_IF;
  } else if (literal == "else") {
    return TT_ELSE;
  } else if (literal == "while") {
    return TT_WHILE;
  } else if (literal == "foreach") {
    return TT_FOREACH;
  } else if (literal == "as") {
    return TT_AS;
  } else if (literal == "not") {
    return TT_NOT;
  } else if (literal == "and") {
    return TT_AND;
  } else if (literal == "or") {
    return TT_OR;
  } else if (literal == "xor") {
    return TT_XOR;
  } else if (literal == "function") {
    return TT_FUNCTION;
  } else if (literal == "return") {
    return TT_RETURN;
  } else {
    return TT_IDENTIFIER;
  }
}

Lexer::Lexer(string_view input) : length(input.length()), input(input) {}

inline bool isWhitespace(char ch) {
  return ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n';
}

inline bool isLetter(char ch) {
  return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_';
}

inline bool isDigit(char ch) { return ch >= '0' && ch <= '9'; }

inline bool isAlphanumeric(char ch) { return isLetter(ch) || isDigit(ch); }

Token Lexer::getNextToken() {
  position = read_position;
  line_no = read_line_no;
  col_no = read_col_no;
  readChar();
  switch (ch) {
  case 0:
    return match(TT_EOF);
  case '(':
    return match(TT_LPAREN);
  case ')':
    return match(TT_RPAREN);
  case '[':
    return match(TT_LBRACKET);
  case ']':
    return match(TT_RBRACKET);
  case '{':
    return match(TT_LCURLY);
  case '}':
    return match(TT_RCURLY);
  case ';':
    return match(TT_SEMICOLON);
  case ':':
    return match(TT_COLON);
  case ',':
    return match(TT_COMMA);
  case '^':
    return match(TT_POW);
  case '+':
    return matchIf('=', TT_ASSIGN_ADD, TT_ADD);
  case '-':
    return matchIf('=', TT_ASSIGN_SUBTRACT, TT_SUBTRACT);
  case '*':
    return matchIf('=', TT_ASSIGN_MULTIPLY, TT_MULTIPLY);
  case '/':
    return matchIf('=', TT_ASSIGN_DIVIDE, TT_DIVIDE);
  case '%':
    return matchIf('=', TT_ASSIGN_MOD, TT_MOD);
  case '<':
    return matchIf('=', TT_LESS_EQUAL, TT_LESS_THAN);
  case '>':
    return matchIf('=', TT_GREATER_EQUAL, TT_GREATER_THAN);
  case '=':
    return matchIf('=', TT_EQUAL, TT_ASSIGN);
  case '!':
    return matchIf('=', TT_NOT_EQUAL, TT_ILLEGAL);
  case '~':
    return matchIf('=', TT_ASSIGN_CONCAT, TT_CONCAT);
  case '"':
    return matchString();
  case '#':
    return matchComment();
  default:
    if (isWhitespace(ch)) {
      return matchWhitespace();
    } else if (isLetter(ch)) {
      return matchIdentifier();
    } else if (isDigit(ch)) {
      return matchNumber();
    } else {
      return match(TT_ILLEGAL);
    }
  }
}

inline void Lexer::readChar() {
  if (read_position >= length) {
    ch = 0;
  } else {
    ch = input[read_position];
    if (ch == '\n') {
      ++read_line_no;
      read_col_no = 0;
    }
    ++read_col_no;
    ++read_position;
  }
  if (read_position >= length) {
    la = 0;
  } else {
    la = input[read_position];
  }
}

inline Token Lexer::match(TokenType token_type) {
  Token token;
  token.type = token_type;
  token.line_no = line_no;
  token.col_no = col_no;
  token.text = input.substr(position, read_position - position);
  return token;
}

inline Token Lexer::matchIf(char if_ch, TokenType if_token_type,
                            TokenType else_token_type) {
  if (la == if_ch) {
    readChar();
    return match(if_token_type);
  } else {
    return match(else_token_type);
  }
}

inline Token Lexer::matchWhitespace() {
  while (isWhitespace(la)) {
    readChar();
  }
  return match(TT_WHITESPACE);
}

inline Token Lexer::matchComment() {
  while (ch != 0 && ch != '\n') {
    readChar();
  }
  return match(TT_COMMENT);
}

inline Token Lexer::matchString() {
  while (la != 0 && la != '"') {
    if (la == '\\') {
      readChar();
    }
    readChar();
  }
  if (la == '"') {
    readChar();
  }
  return match(TT_STRING);
}

inline Token Lexer::matchIdentifier() {
  while (isAlphanumeric(la)) {
    readChar();
  }
  Token token = match(TT_IDENTIFIER);
  token.type = tokenTypeKeyword(token.text);
  return token;
}

inline Token Lexer::matchNumber() {
  while (isDigit(la) || la == '_') {
    readChar();
  }
  if (la == '.') {
    readChar();
    while (isDigit(la) || la == '_') {
      readChar();
    }
    if (la == 'e' || la == 'E') {
      readChar();
      if (la == '+' || la == '-') {
        readChar();
      }
      while (isDigit(la) || la == '_') {
        readChar();
      }
    }
    return match(TT_FLOAT);
  } else {
    return match(TT_INTEGER);
  }
}
