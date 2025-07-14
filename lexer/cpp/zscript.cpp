#include "lexer.h"
#include <fstream>
#include <iostream>
#include <iterator>
#include <string>
#include <string_view>
#include <vector>
#include <system_error>

using namespace std;

int main(int argc, char** argv) {
  if (argc != 3) {
    cerr << "Usage: " << argv[0] << " <input.zs> <output.csv>\n";
    return 1;
  }

  const char *input_path = argv[1];
  const char *output_path = argv[2];

  ifstream input_file(input_path, ios::binary);
  if (!input_file) {
    error_code ec(errno, generic_category());
    cerr << "Failed to open input file: '" << input_path << "': " << ec.message() << endl;
    return 1;
  }

  vector<char> bytes{istreambuf_iterator<char>(input_file),
                     istreambuf_iterator<char>()};
  string input_raw(bytes.begin(), bytes.end());
  string_view input(input_raw);

  ofstream output_file(output_path, ios::binary);
  if (!output_file) {
    error_code ec(errno, generic_category());
    cerr << "Failed to open output file: '" << output_path << "': " << ec.message() << endl;
    return 1;
  }

  Lexer lexer(input);
  Token token;
  while (true) {
    token = lexer.getNextToken();
    if (token.type == TT_EOF) {
      break;
    }
    output_file << token.line_no << "," << token.col_no << ",\"";
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
      output_file << text;
    } else {
      output_file << token.text;
    }
    output_file << "\",\"" << tokenTypeName(token.type) << "\"\n";
  }

  return 0;
}
