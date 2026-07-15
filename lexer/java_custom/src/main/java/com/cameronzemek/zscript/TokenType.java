package com.cameronzemek.zscript;

public enum TokenType {
  ILLEGAL("illegal"),
  EOF("eof"),

  WHITESPACE("whitespace"),
  COMMENT("comment"),

  IDENTIFIER("id"),
  INTEGER("integer"),
  FLOAT("float"),
  STRING("string"),

  ASSIGN("="),
  PLUS("+"),
  MINUS("-"),
  MULTIPLY("*"),
  DIVIDE("/"),
  MOD("%"),
  POW("^"),
  CONCAT("~"),
  ASSIGN_PLUS("+="),
  ASSIGN_MINUS("-="),
  ASSIGN_MULTIPLY("*="),
  ASSIGN_DIVIDE("/="),
  ASSIGN_MOD("%="),
  ASSIGN_CONCAT("~="),
  EQUAL("=="),
  NOT_EQUAL("!="),
  LESS_THAN("<"),
  LESS_EQUAL("<="),
  GREATER_THAN(">"),
  GREATER_EQUAL(">="),

  LPAREN("("),
  RPAREN(")"),
  LBRACKET("["),
  RBRACKET("]"),
  LCURLY("{"),
  RCURLY("}"),
  SEMICOLON(";"),
  COLON(":"),
  COMMA(","),

  KEYWORD_LET("let"),
  KEYWORD_TRUE("true"),
  KEYWORD_FALSE("false"),
  KEYWORD_NOT("not"),
  KEYWORD_AND("and"),
  KEYWORD_OR("or"),
  KEYWORD_XOR("xor"),
  KEYWORD_WHILE("while"),
  KEYWORD_IF("if"),
  KEYWORD_ELSE("else"),
  KEYWORD_FOREACH("foreach"),
  KEYWORD_AS("as"),
  KEYWORD_FUNCTION("function"),
  KEYWORD_RETURN("return");

  private final String name;

  TokenType(String name) { this.name = name; }

  @Override
  public String toString() {
    return name;
  }
}
