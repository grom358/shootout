namespace Zscript {
public enum TokenType {
  ILLEGAL = 0,
  EOF,

  WHITESPACE,
  COMMENT,

  IDENTIFIER,
  INTEGER,
  FLOAT,
  STRING,

  // Operators
  ASSIGN,
  PLUS,
  MINUS,
  MULTIPLY,
  DIVIDE,
  MOD,
  POW,
  CONCAT,
  ASSIGN_PLUS,
  ASSIGN_MINUS,
  ASSIGN_MULTIPLY,
  ASSIGN_DIVIDE,
  ASSIGN_MOD,
  ASSIGN_CONCAT,
  EQUAL,
  NOT_EQUAL,
  LESS_THAN,
  LESS_EQUAL,
  GREATER_THAN,
  GREATER_EQUAL,

  // Delimiters
  LPAREN,
  RPAREN,
  LBRACKET,
  RBRACKET,
  LCURLY,
  RCURLY,
  SEMICOLON,
  COLON,
  COMMA,

  // Keywords
  KEYWORD_LET,
  KEYWORD_TRUE,
  KEYWORD_FALSE,
  KEYWORD_NOT,
  KEYWORD_AND,
  KEYWORD_OR,
  KEYWORD_XOR,
  KEYWORD_WHILE,
  KEYWORD_IF,
  KEYWORD_ELSE,
  KEYWORD_FOREACH,
  KEYWORD_AS,
  KEYWORD_FUNCTION,
  KEYWORD_RETURN
}

public class Utils {
  public static string ToString(TokenType type) {
    switch (type) {
    case TokenType.EOF:
      return "eof";
    case TokenType.ILLEGAL:
      return "illegal";
    case TokenType.WHITESPACE:
      return "whitespace";
    case TokenType.COMMENT:
      return "comment";
    case TokenType.IDENTIFIER:
      return "id";
    case TokenType.INTEGER:
      return "integer";
    case TokenType.FLOAT:
      return "float";
    case TokenType.STRING:
      return "string";
    case TokenType.ASSIGN:
      return "=";
    case TokenType.PLUS:
      return "+";
    case TokenType.MINUS:
      return "-";
    case TokenType.MULTIPLY:
      return "*";
    case TokenType.DIVIDE:
      return "/";
    case TokenType.MOD:
      return "%";
    case TokenType.POW:
      return "^";
    case TokenType.CONCAT:
      return "~";
    case TokenType.ASSIGN_PLUS:
      return "+=";
    case TokenType.ASSIGN_MINUS:
      return "-=";
    case TokenType.ASSIGN_MULTIPLY:
      return "*=";
    case TokenType.ASSIGN_DIVIDE:
      return "/=";
    case TokenType.ASSIGN_MOD:
      return "%=";
    case TokenType.ASSIGN_CONCAT:
      return "~=";
    case TokenType.EQUAL:
      return "==";
    case TokenType.NOT_EQUAL:
      return "!=";
    case TokenType.LESS_THAN:
      return "<";
    case TokenType.LESS_EQUAL:
      return "<=";
    case TokenType.GREATER_THAN:
      return ">";
    case TokenType.GREATER_EQUAL:
      return ">=";
    case TokenType.LPAREN:
      return "(";
    case TokenType.RPAREN:
      return ")";
    case TokenType.LBRACKET:
      return "[";
    case TokenType.RBRACKET:
      return "]";
    case TokenType.LCURLY:
      return "{";
    case TokenType.RCURLY:
      return "}";
    case TokenType.SEMICOLON:
      return ";";
    case TokenType.COLON:
      return ":";
    case TokenType.COMMA:
      return ",";
    case TokenType.KEYWORD_LET:
      return "let";
    case TokenType.KEYWORD_TRUE:
      return "true";
    case TokenType.KEYWORD_FALSE:
      return "false";
    case TokenType.KEYWORD_NOT:
      return "not";
    case TokenType.KEYWORD_AND:
      return "and";
    case TokenType.KEYWORD_OR:
      return "or";
    case TokenType.KEYWORD_XOR:
      return "xor";
    case TokenType.KEYWORD_WHILE:
      return "while";
    case TokenType.KEYWORD_IF:
      return "if";
    case TokenType.KEYWORD_ELSE:
      return "else";
    case TokenType.KEYWORD_FOREACH:
      return "foreach";
    case TokenType.KEYWORD_AS:
      return "as";
    case TokenType.KEYWORD_FUNCTION:
      return "function";
    case TokenType.KEYWORD_RETURN:
      return "return";
    default:
      return "unknown";
    }
  }
}

public struct Token {
  public TokenType type;
  public int lineNo;
  public int colNo;
  public string text;
}

public class Lexer {
  private int readPosition = 0;
  private int readLineNo = 1;
  private int readColNo = 1;

  private int position;
  private int lineNo;
  private int colNo;

  private char ch;
  private char la;
  private string input;

  private static bool IsWhitespace(char ch) {
    return ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n';
  }

  private static bool IsLetter(char ch) {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_';
  }

  private static bool IsDigit(char ch) { return ch >= '0' && ch <= '9'; }

  private static bool IsAlphaNumeric(char ch) {
    return IsLetter(ch) || IsDigit(ch);
  }
  public Lexer(string input) { this.input = input; }

  private void ReadChar() {
    if (readPosition >= input.Length) {
      ch = '\0';
    } else {
      ch = input[readPosition++];
      if (ch == '\n') {
        readLineNo++;
        readColNo = 0;
      }
      readColNo++;
    }
    if (readPosition >= input.Length) {
      la = '\0';
    } else {
      la = input[readPosition];
    }
  }

  private Token Match(TokenType type) {
    string text = input.Substring(position, readPosition - position);
    return new Token { type = type, lineNo = lineNo, colNo = colNo,
                       text = text };
  }

  private Token MatchIf(char ifCh, TokenType ifType, TokenType elseType) {
    if (la == ifCh) {
      ReadChar();
      return Match(ifType);
    } else {
      return Match(elseType);
    }
  }

  private Token MatchComment() {
    while (ch != '\0' && ch != '\n') {
      ReadChar();
    }
    return Match(TokenType.COMMENT);
  }

  private Token MatchString() {
    ReadChar();
    while (ch != '\0' && ch != '"') {
      if (ch == '\\') {
        ReadChar();
      }
      ReadChar();
    }
    return Match(TokenType.STRING);
  }

  private Token MatchWhitespace() {
    while (IsWhitespace(la)) {
      ReadChar();
    }
    return Match(TokenType.WHITESPACE);
  }

  private Token MatchNumber() {
    while (IsDigit(la) || la == '_') {
      ReadChar();
    }
    if (la == '.') {
      ReadChar();
      while (IsDigit(la) || la == '_') {
        ReadChar();
      }
      if (la == 'e' || la == 'E') {
        ReadChar();
        if (la == '+' || la == '-') {
          ReadChar();
        }
        while (IsDigit(la) || la == '_') {
          ReadChar();
        }
      }
      return Match(TokenType.FLOAT);
    } else {
      return Match(TokenType.INTEGER);
    }
  }

  private static TokenType Keyword(string id) {
    switch (id) {
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
    case "true":
      return TokenType.KEYWORD_TRUE;
    case "false":
      return TokenType.KEYWORD_FALSE;
    case "not":
      return TokenType.KEYWORD_NOT;
    case "and":
      return TokenType.KEYWORD_AND;
    case "or":
      return TokenType.KEYWORD_OR;
    case "xor":
      return TokenType.KEYWORD_XOR;
    case "function":
      return TokenType.KEYWORD_FUNCTION;
    case "return":
      return TokenType.KEYWORD_RETURN;
    default:
      return TokenType.IDENTIFIER;
    }
  }

  private Token MatchIdentifier() {
    while (IsAlphaNumeric(la)) {
      ReadChar();
    }
    Token token = Match(TokenType.IDENTIFIER);
    token.type = Keyword(token.text);
    return token;
  }

  public Token GetNextToken() {
    position = readPosition;
    lineNo = readLineNo;
    colNo = readColNo;
    ReadChar();

    switch (ch) {
    case '\0':
      return Match(TokenType.EOF);
    case '^':
      return Match(TokenType.POW);
    case ';':
      return Match(TokenType.SEMICOLON);
    case ':':
      return Match(TokenType.COLON);
    case ',':
      return Match(TokenType.COMMA);
    case '(':
      return Match(TokenType.LPAREN);
    case ')':
      return Match(TokenType.RPAREN);
    case '[':
      return Match(TokenType.LBRACKET);
    case ']':
      return Match(TokenType.RBRACKET);
    case '{':
      return Match(TokenType.LCURLY);
    case '}':
      return Match(TokenType.RCURLY);
    case '+':
      return MatchIf('=', TokenType.ASSIGN_PLUS, TokenType.PLUS);
    case '-':
      return MatchIf('=', TokenType.ASSIGN_MINUS, TokenType.MINUS);
    case '*':
      return MatchIf('=', TokenType.ASSIGN_MULTIPLY, TokenType.MULTIPLY);
    case '/':
      return MatchIf('=', TokenType.ASSIGN_DIVIDE, TokenType.DIVIDE);
    case '%':
      return MatchIf('=', TokenType.ASSIGN_MOD, TokenType.MOD);
    case '~':
      return MatchIf('=', TokenType.ASSIGN_CONCAT, TokenType.CONCAT);
    case '=':
      return MatchIf('=', TokenType.EQUAL, TokenType.ASSIGN);
    case '<':
      return MatchIf('=', TokenType.LESS_EQUAL, TokenType.LESS_THAN);
    case '>':
      return MatchIf('=', TokenType.GREATER_EQUAL, TokenType.GREATER_THAN);
    case '!':
      return MatchIf('=', TokenType.NOT_EQUAL, TokenType.ILLEGAL);
    case '#':
      return MatchComment();
    case '"':
      return MatchString();
    default:
      if (IsWhitespace(ch)) {
        return MatchWhitespace();
      } else if (IsDigit(ch)) {
        return MatchNumber();
      } else if (IsLetter(ch)) {
        return MatchIdentifier();
      } else {
        return Match(TokenType.ILLEGAL);
      }
    }
  }
}
}
