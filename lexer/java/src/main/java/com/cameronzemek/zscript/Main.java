package com.cameronzemek.zscript;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Main {
  public static void main(String[] args) throws IOException {
    if (args.length != 2) {
      System.err.println("Usage: zscript <input.zs> <output.csv>");
      System.exit(1);
    }

    String inputFile = args[0];
    String outputFile = args[1];

    byte[] bytes = Files.readAllBytes(Paths.get(inputFile));
    String input = new String(bytes);

    Lexer lexer = new Lexer(input);
    Token token;
    try (PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter(outputFile)), false)) {
      while ((token = lexer.getNext()).getType() != TokenType.EOF) {
        String text = token.getText();
        if (token.getType() == TokenType.STRING) {
          text = text.substring(1, text.length() - 1);
        }
        if (token.getType() == TokenType.STRING ||
        token.getType() == TokenType.COMMENT) {
          text = text.replaceAll("\"", "\"\"");
        }
        writer.printf("%d,%d,\"%s\",\"%s\"\n",
          token.getLineNo(), token.getColumnNo(),
          text, token.getType());
      }
    }
  }
}
