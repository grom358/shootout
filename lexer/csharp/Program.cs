using Zscript;

string input = Console.In.ReadToEnd();
TextWriter bufferedWriter =
    new StreamWriter(Console.OpenStandardOutput()) { AutoFlush = false };
Console.SetOut(bufferedWriter);

Lexer lexer = new Lexer(input);
while (true) {
  Token token = lexer.GetNextToken();
  if (token.type == TokenType.EOF) {
    break;
  }
  string text = token.text;
  if (token.type == TokenType.STRING) {
    text = text.Substring(1, text.Length - 2);
  }
  if (token.type == TokenType.STRING || token.type == TokenType.COMMENT) {
    text = text.Replace("\"", "\"\"");
  }
  Console.WriteLine("{0},{1},\"{2}\",\"{3}\"", token.lineNo, token.colNo, text,
                    Utils.ToString(token.type));
}
bufferedWriter.Flush();
