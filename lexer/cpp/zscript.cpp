#include "lexer.h"
#include <iostream>
#include <iterator>
#include <string>
#include <string_view>
#include <vector>

using namespace std;

int main() {
  vector<char> bytes{istreambuf_iterator<char>(cin),
                     istreambuf_iterator<char>()};
  string input_raw(bytes.begin(), bytes.end());
  string_view input(input_raw);

  Lexer lexer(input);
  Token token;
  while (true) {
    token = lexer.getNextToken();
    if (token.type == TT_EOF) {
      break;
    }
    cout << token.line_no << "," << token.col_no << ",\"";
    if (token.type == TT_STRING || token.type == TT_COMMENT) {
      string text(token.text);
      if (token.type == TT_STRING) {
        text = text.substr(1, text.length() - 2);
      }
      size_t pos = 0;
      while ((pos = text.find("\"", pos)) != string::npos) {
        text.replace(pos, 1, "\"\"");
        pos += 2; // Move past the inserted ""
      }
      cout << text;
    } else {
      cout << token.text;
    }
    cout << "\",\"" << tokenTypeName(token.type) << "\"\n";
  }

  return 0;
}
