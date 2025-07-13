using Zscript;

if (args.Length < 2) {
  Console.Error.WriteLine("Usage: zscript <input-file> <output-file>");
  return;
}

string inputPath = args[0];
string outputPath = args[1];

string input = File.ReadAllText(inputPath);

using FileStream outStream = new FileStream(outputPath, FileMode.Create, FileAccess.Write, FileShare.None);
TextWriter bufferedWriter =
    new StreamWriter(outStream) { AutoFlush = false };

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
  bufferedWriter.WriteLine("{0},{1},\"{2}\",\"{3}\"", token.lineNo, token.colNo, text,
                    Utils.ToString(token.type));
}
bufferedWriter.Flush();
