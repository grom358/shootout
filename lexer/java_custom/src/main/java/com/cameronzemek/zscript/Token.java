package com.cameronzemek.zscript;

import java.util.Objects;

public class Token {
  private final int lineNo;
  private final int columnNo;
  private final TokenType type;
  private final String text;

  public Token(int lineNo, int columnNo, TokenType type, String text) {
    this.lineNo = lineNo;
    this.columnNo = columnNo;
    this.type = type;
    this.text = text;
  }

  public int getLineNo() { return lineNo; }

  public int getColumnNo() { return columnNo; }

  public TokenType getType() { return type; }

  public String getText() { return text; }

  @Override
  public boolean equals(Object o) {
    if (this == o)
      return true;
    if (o == null || getClass() != o.getClass())
      return false;
    Token token = (Token)o;
    return lineNo == token.lineNo && columnNo == token.columnNo &&
        type == token.type && Objects.equals(text, token.text);
  }

  @Override
  public int hashCode() {
    return Objects.hash(lineNo, columnNo, type, text);
  }

  @Override
  public String toString() {
    return "Token{"
        + "lineNo=" + lineNo + ", columnNo=" + columnNo + ", type=" + type +
        ", text='" + text + '\'' + '}';
  }
}
