package com.cameronzemek.zscript;

public class Lexer {
  private String input;
  private int length;

  private char ch;
  private char la;
  private int readPosition;
  private int readLineNo = 1;
  private int readColNo = 1;

  private int position;
  private int lineNo;
  private int colNo;

  private static boolean isLetter(char b) {
    return (b >= 'a' && b <= 'z') || (b >= 'A' && b <= 'Z') || b == '_';
  }

  private static boolean isDigit(char b) { return b >= '0' && b <= '9'; }

  private static boolean isWhitespace(char b) {
    return b == ' ' || b == '\t' || b == '\r' || b == '\n';
  }

  public Lexer(String input) {
    this.input = input;
    this.length = input.length();
  }

  private void readChar() {
    if (readPosition >= length) {
      ch = 0;
    } else {
      ch = input.charAt(readPosition);
      if (ch == '\n') {
        readLineNo++;
        readColNo = 0;
      }
      readColNo++;
      readPosition++;
    }
    if (readPosition >= length) {
      la = 0;
    } else {
      la = input.charAt(readPosition);
    }
  }

  private Token match(TokenType type) {
    String text = input.substring(position, readPosition);
    return new Token(lineNo, colNo, type, text);
  }

  private Token matchIf(char ifCh, TokenType ifType, TokenType elseType) {
    if (la == ifCh) {
      readChar();
      return match(ifType);
    } else {
      return match(elseType);
    }
  }

  private Token matchString() {
    readChar(); // consume '"'
    while (ch != '"' && ch != 0) {
      if (ch == '\\') {
        readChar();
      }
      readChar();
    }
    return match(TokenType.STRING);
  }

  private Token matchComment() {
    while (ch != 0 && ch != '\n') {
      readChar();
    }
    return match(TokenType.COMMENT);
  }

  private Token matchWhitespace() {
    while (isWhitespace(la)) {
      readChar();
    }
    return match(TokenType.WHITESPACE);
  }

  private Token matchIdentifier() {
    while (isLetter(la) || isDigit(la)) {
      readChar();
    }
    String text = input.substring(position, readPosition);
    TokenType type = lookupKeyword(text);
    return new Token(lineNo, colNo, type, text);
  }

  private static TokenType lookupKeyword(String identifier) {
    switch (identifier) {
    case "function":
      return TokenType.KEYWORD_FUNCTION;
    case "return":
      return TokenType.KEYWORD_RETURN;
    case "true":
      return TokenType.KEYWORD_TRUE;
    case "false":
      return TokenType.KEYWORD_FALSE;
    case "and":
      return TokenType.KEYWORD_AND;
    case "or":
      return TokenType.KEYWORD_OR;
    case "xor":
      return TokenType.KEYWORD_XOR;
    case "not":
      return TokenType.KEYWORD_NOT;
    case "let":
      return TokenType.KEYWORD_LET;
    case "if":
      return TokenType.KEYWORD_IF;
    case "else":
      return TokenType.KEYWORD_ELSE;
    case "while":
      return TokenType.KEYWORD_WHILE;
    case "foreach":
      return TokenType.KEYWORD_FOREACH;
    case "as":
      return TokenType.KEYWORD_AS;
    default:
      return TokenType.IDENTIFIER;
    }
  }

  private Token matchNumber() {
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
        if (la == '-' || la == '+') {
          readChar();
        }
        while (isDigit(la) || la == '_') {
          readChar();
        }
      }
      return match(TokenType.FLOAT);
    } else {
      return match(TokenType.INTEGER);
    }
  }

  public Token getNext() {
    position = readPosition;
    lineNo = readLineNo;
    colNo = readColNo;
    readChar();

    switch (ch) {
    case 0:
      return match(TokenType.EOF);
    case '^':
      return match(TokenType.POW);
    case ';':
      return match(TokenType.SEMICOLON);
    case ':':
      return match(TokenType.COLON);
    case ',':
      return match(TokenType.COMMA);
    case '{':
      return match(TokenType.LCURLY);
    case '}':
      return match(TokenType.RCURLY);
    case '[':
      return match(TokenType.LBRACKET);
    case ']':
      return match(TokenType.RBRACKET);
    case '(':
      return match(TokenType.LPAREN);
    case ')':
      return match(TokenType.RPAREN);
    case '+':
      return matchIf('=', TokenType.ASSIGN_PLUS, TokenType.PLUS);
    case '-':
      return matchIf('=', TokenType.ASSIGN_MINUS, TokenType.MINUS);
    case '*':
      return matchIf('=', TokenType.ASSIGN_MULTIPLY, TokenType.MULTIPLY);
    case '/':
      return matchIf('=', TokenType.ASSIGN_DIVIDE, TokenType.DIVIDE);
    case '%':
      return matchIf('=', TokenType.ASSIGN_MOD, TokenType.MOD);
    case '~':
      return matchIf('=', TokenType.ASSIGN_CONCAT, TokenType.CONCAT);
    case '=':
      return matchIf('=', TokenType.EQUAL, TokenType.ASSIGN);
    case '>':
      return matchIf('=', TokenType.GREATER_EQUAL, TokenType.GREATER_THAN);
    case '<':
      return matchIf('=', TokenType.LESS_EQUAL, TokenType.LESS_THAN);
    case '!':
      return matchIf('=', TokenType.NOT_EQUAL, TokenType.ILLEGAL);
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
      }
      return match(TokenType.ILLEGAL);
    }
  }
}
