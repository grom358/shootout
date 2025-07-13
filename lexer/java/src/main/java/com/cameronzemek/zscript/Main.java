package com.cameronzemek.zscript;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Main {
  public static void main(String[] args) throws IOException {
    if (args.length < 2) {
      System.err.println("Usage: zscript <input-file> <output-file>");
      System.exit(1);
    }

    String inputFile = args[0];
    String outputFile = args[1];

    byte[] bytes = Files.readAllBytes(Paths.get(inputFile));
    String input = new String(bytes);

    OutputStream out = new BufferedOutputStream(new FileOutputStream(outputFile));

    Lexer lexer = new Lexer(input);
    Token token;
    while ((token = lexer.getNext()).getType() != TokenType.EOF) {
      String text = token.getText();
      if (token.getType() == TokenType.STRING) {
        text = text.substring(1, text.length() - 1);
      }
      if (token.getType() == TokenType.STRING ||
          token.getType() == TokenType.COMMENT) {
        text = text.replaceAll("\"", "\"\"");
      }
      // Its more natural to use PrintWriter and format string here. Eg.
      // printWriter.printf("%d,%d,\"%s\",\"%s\"\n",
      //                    token.getLineNo(), token.getColumnNo()
      //                    text, token.getType());
      // However the format machinery is slow and PrintWriter uses locking.
      out.write(Integer.toString(token.getLineNo()).getBytes());
      out.write(",".getBytes());
      out.write(Integer.toString(token.getColumnNo()).getBytes());
      out.write(",\"".getBytes());
      out.write(text.getBytes());
      out.write("\",\"".getBytes());
      out.write(token.getType().toString().getBytes());
      out.write("\"\n".getBytes());
    }
    out.flush();
  }
}
