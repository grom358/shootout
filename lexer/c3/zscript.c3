import std::io;

enum TokenType : uint (String label)
{
	ILLEGAL         { "illegal" },
	EOF             { "eof" },

	WHITESPACE      { "whitespace" },
	COMMENT         { "comment" },

	SEMICOLON       { ";" },
	COLON           { ":" },
	COMMA           { "," },

	LPAREN          { "(" },
	RPAREN          { ")" },
	LBRACKET        { "[" },
	RBRACKET        { "]" },
	LCURLY          { "{" },
	RCURLY          { "}" },

	CONCAT          { "~" },
	ADD             { "+" },
	SUBTRACT        { "-" },
	MULTIPLY        { "*" },
	DIVIDE          { "/" },
	MOD             { "%" },
	POW             { "^" },
	ASSIGN          { "=" },
	ASSIGN_CONCAT   { "~=" },
	ASSIGN_ADD      { "+=" },
	ASSIGN_SUBTRACT { "-=" },
	ASSIGN_MULTIPLY { "*=" },
	ASSIGN_DIVIDE   { "/=" },
	ASSIGN_MOD      { "%=" },
	EQUAL           { "==" },
	NOT_EQUAL       { "!=" },
	LESS_THAN       { "<" },
	LESS_EQUAL      { "<=" },
	GREATER_THAN    { ">" },
	GREATER_EQUAL   { ">=" },

	INTEGER         { "integer" },
	FLOAT           { "float" },
	STRING          { "string" },
	IDENTIFIER      { "id" },

	LET             { "let" },
	TRUE            { "true" },
	FALSE           { "false" },
	AND             { "and" },
	OR              { "or" },
	XOR             { "xor" },
	NOT             { "not" },
	IF              { "if" },
	ELSE            { "else" },
	WHILE           { "while" },
	FOREACH         { "foreach" },
	AS              { "as" },
	FUNCTION        { "function" },
	RETURN          { "return" },
}

struct Token
{
	TokenType type;
	usz line_no;
	usz col_no;
	String text;
}

struct Lexer
{
	usz pos;
	char ch;
	char la;
	usz line_no;
	usz col_no;
	String input;
}

fn void Lexer.init(Lexer* l, String input)
{
	l.line_no = 1;
	l.col_no = 1;
	l.input = input;
	l.pos = 0;
	l.ch = '\0';
	l.la = '\0';
}

fn void Lexer.read_char(Lexer* l) @inline
{
	usz len = l.input.len;
	if (l.pos >= len)
	{
		l.ch = '\0';
		l.la = '\0';
	}
	else
	{
		l.ch = l.input[l.pos++];
		if (l.ch == '\n')
		{
			l.line_no++;
			l.col_no = 0;
		}
		l.col_no++;
		if (l.pos < len)
		{
			l.la = l.input[l.pos];
		}
		else
		{
			l.la = '\0';
		}
	}
}

fn void Lexer.read_whitespace(Lexer* l, Token* tok) @inline
{
	tok.type = TokenType.WHITESPACE;
	while (ascii::@is_space(l.la))
	{
		l.read_char();
	}
}

fn void Lexer.read_comment(Lexer* l, Token* tok) @inline
{
	tok.type = TokenType.COMMENT;
	while (l.la != '\0' && l.la != '\n')
	{
		l.read_char();
	}
	if (l.la == '\n')
	{
		l.read_char();
	}
}

fn void Lexer.read_string(Lexer* l, Token* tok) @inline
{
	tok.type = TokenType.STRING;
	while (l.la != '\0' && l.la != '"')
	{
		if (l.la == '\\')
		{
			l.read_char();
		}
		l.read_char();
	}
	if (l.la == '"')
	{
		l.read_char();
	}
}

fn void Lexer.read_number(Lexer* l, Token* tok) @inline
{
	tok.type = TokenType.INTEGER;
	while (ascii::@is_digit(l.la) || l.la == '_')
	{
		l.read_char();
	}
	if (l.la == '.')
	{
		tok.type = TokenType.FLOAT;
		l.read_char();
		while (ascii::@is_digit(l.la) || l.la == '_')
		{
			l.read_char();
		}
	}
	if (l.la == 'e' || l.la == 'E')
	{
		tok.type = TokenType.FLOAT;
		l.read_char();
		if (l.la == '+' || l.la == '-')
		{
			l.read_char();
		}
		while (ascii::@is_digit(l.la) || l.la == '_')
		{
			l.read_char();
		}
	}
}

struct Keyword
{
	String word;
	TokenType type;
}

const Keyword[] KEYWORDS = {
	{"let", TokenType.LET},
	{"true", TokenType.TRUE},
	{"false", TokenType.FALSE},
	{"and", TokenType.AND},
	{"or", TokenType.OR},
	{"xor", TokenType.XOR},
	{"not", TokenType.NOT},
	{"if", TokenType.IF},
	{"else", TokenType.ELSE},
	{"while", TokenType.WHILE},
	{"foreach", TokenType.FOREACH},
	{"as", TokenType.AS},
	{"function", TokenType.FUNCTION},
	{"return", TokenType.RETURN}};

fn void Lexer.read_identifier(Lexer* l, Token* tok)
{
	tok.type = TokenType.IDENTIFIER;
	usz start_pos = l.pos - 1;
	usz len = 1;
	while (ascii::@is_alpha(l.la) || ascii::@is_digit(l.la) || l.la == '_')
	{
		l.read_char();
		len++;
	}
	String text = l.input [start_pos:len];
	tok.text = text;

	// Check if identifier is keyword.
	for (usz i = 0; i < KEYWORDS.len; i++)
	{
		Keyword keyword = KEYWORDS[i];
		if (keyword.word.compare_to(text) == 0)
		{
			tok.type = keyword.type;
			break;
		}
	}
}

fn void Lexer.match_if(Lexer* l, Token* tok, char c, TokenType if_type, TokenType else_type) @inline
{
	if (l.la == c)
	{
		tok.type = if_type;
		l.read_char();
	}
	else
	{
		tok.type = else_type;
	}
}

fn void Lexer.next_token(Lexer* l, Token* tok)
{
	tok.line_no = l.line_no;
	tok.col_no = l.col_no;
	usz start_pos = l.pos;

	l.read_char();

	switch (l.ch)
	{
		case '\0':
			tok.type = TokenType.EOF;
			tok.text = "";
			return;
		case '#':
			l.read_comment(tok);
		case ';':
			tok.type = TokenType.SEMICOLON;
		case ':':
			tok.type = TokenType.COLON;
		case ',':
			tok.type = TokenType.COMMA;
		case '(':
			tok.type = TokenType.LPAREN;
		case ')':
			tok.type = TokenType.RPAREN;
		case '[':
			tok.type = TokenType.LBRACKET;
		case ']':
			tok.type = TokenType.RBRACKET;
		case '{':
			tok.type = TokenType.LCURLY;
		case '}':
			tok.type = TokenType.RCURLY;
		case '^':
			tok.type = TokenType.POW;
		case '~':
			l.match_if(tok, '=', TokenType.ASSIGN_CONCAT, TokenType.CONCAT);
		case '+':
			l.match_if(tok, '=', TokenType.ASSIGN_ADD, TokenType.ADD);
		case '-':
			l.match_if(tok, '=', TokenType.ASSIGN_SUBTRACT, TokenType.SUBTRACT);
		case '*':
			l.match_if(tok, '=', TokenType.ASSIGN_MULTIPLY, TokenType.MULTIPLY);
		case '/':
			l.match_if(tok, '=', TokenType.ASSIGN_DIVIDE, TokenType.DIVIDE);
		case '%':
			l.match_if(tok, '=', TokenType.ASSIGN_MOD, TokenType.MOD);
		case '=':
			l.match_if(tok, '=', TokenType.EQUAL, TokenType.ASSIGN);
		case '!':
			l.match_if(tok, '=', TokenType.NOT_EQUAL, TokenType.ILLEGAL);
		case '<':
			l.match_if(tok, '=', TokenType.LESS_EQUAL, TokenType.LESS_THAN);
		case '>':
			l.match_if(tok, '=', TokenType.GREATER_EQUAL, TokenType.GREATER_THAN);
		case '"':
			l.read_string(tok);
		default:
			if (ascii::@is_space(l.ch))
			{
				l.read_whitespace(tok);
			}
			else if (ascii::@is_digit(l.ch))
			{
				l.read_number(tok);
			}
			else if (ascii::@is_alpha(l.ch) || l.ch == '_')
			{
				l.read_identifier(tok);
				return;
			}
			else
			{
				tok.type = TokenType.ILLEGAL;
			}
	}
	usz tok_len = l.pos - start_pos;
	tok.text = l.input[start_pos:tok_len];
}

// Copied from standard library.
fn void? out_putstream_fn(void* data, char c) @private
{
	OutStream* stream = data;
	return (*stream).write_byte(c);
}

fn int main(String[] args)
{
	if (args.len != 3)
	{
		io::eprintfn("Usage: %s <input.zs> <output.csv>", args[0]);
		return 1;
	}

	String? input = (String) file::load(mem, args[1]);
	if (catch err = input)
	{
		io::eprintfn("Unable to load '%s': %s", args[1], err);
		return 1;
	}

	String output_path = args[2];
	File? fout = file::open(output_path, "wb");
	if (catch err = fout)
	{
		io::eprintfn("Unable to open '%s': %s", output_path, err);
		return 1;
	}
	WriteBuffer out;
	char[4096] write_buffer;
	out.init(&fout, &write_buffer);

	Formatter formatter;
	formatter.init(&out_putstream_fn, &out);

	DynamicArenaAllocator arena;
	arena.init(mem, 4096);
	defer arena.free();

	Lexer lexer;
	lexer.init(input);
	Token token;
	for (;;)
	{
		lexer.next_token(&token);
		if (token.type == TokenType.EOF)
		{
			break;
		}
		String text = token.text;
		if (token.type == TokenType.STRING)
		{
			text = text [1:text.len - 2];
		}
		if (token.type == TokenType.STRING || token.type == TokenType.COMMENT)
		{
			text = text.replace(&arena, "\"", "\"\"");
		}
		if (catch err = formatter.printf("%d,%d,\"%s\",\"%s\"\n", token.line_no, token.col_no, text, token.type.label)) {
			io::eprintfn("Error writing to '%s': %s", output_path, err);
			return 1;
		}
		arena.reset();
	}
	if (catch err = out.flush()) {
		io::eprintfn("Error writing to '%s': %s", output_path, err);
		return 1;
	}
	if (catch err = out.close()) {
		io::eprintfn("Error closing '%s': %s", output_path, err);
		return 1;
	}
	return 0;
}
