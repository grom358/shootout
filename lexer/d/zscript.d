import std.stdio;
import std.file;
import std.array;
import std.format.write : formattedWrite;

enum TokenType : int {
    ILLEGAL,
    EOF,

    WHITESPACE,
    COMMENT,

    IDENTIFIER,
    INTEGER,
    FLOAT,
    STRING,

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

    LPAREN,
    RPAREN,
    LBRACKET,
    RBRACKET,
    LCURLY,
    RCURLY,
    SEMICOLON,
    COLON,
    COMMA,

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

string toString(TokenType t) pure nothrow @nogc {
    final switch (t) {
    case TokenType.ILLEGAL:
        return "illegal";
    case TokenType.EOF:
        return "eof";

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
    }
}

struct Token {
    int lineNo;
    int colNo;
    TokenType type;
    immutable(char)[] text;
}

struct Lexer {
    private immutable(char)[] input;
    private size_t length;

    private char ch;
    private char la;
    private size_t readPosition;
    private int readLineNo = 1;
    private int readColNo = 1;

    private size_t position;
    private int lineNo;
    private int colNo;

    pragma(inline, true)
    static bool isLetter(char b) pure nothrow @nogc {
        return (b >= 'a' && b <= 'z') || (b >= 'A' && b <= 'Z') || b == '_';
    }

    pragma(inline, true)
    static bool isDigit(char b) pure nothrow @nogc {
        return b >= '0' && b <= '9';
    }

    pragma(inline, true)
    static bool isWhitespace(char b) pure nothrow @nogc {
        return b == ' ' || b == '\t' || b == '\r' || b == '\n';
    }

    this(string input) {
        this.input = input;
        this.length = input.length;
        this.ch = 0;
        this.la = 0;
        this.readPosition = 0;
    }

    pragma(inline, true)
    void readChar() nothrow @nogc {
        if (readPosition >= length) {
            ch = 0;
        } else {
            ch = input[readPosition];
            if (ch == '\n') {
                readLineNo++;
                readColNo = 0;
            }
            readColNo++;
            readPosition++;
        }
        if (readPosition >= length) {
            la = 0;
        } else {
            la = input[readPosition];
        }
    }

    pragma(inline, true)
    Token match(TokenType type) nothrow @nogc {
        immutable(char)[] text = input[position .. readPosition];
        return Token(lineNo, colNo, type, text);
    }

    pragma(inline, true)
    Token matchIf(char ifCh, TokenType ifType, TokenType elseType) nothrow @nogc {
        if (la == ifCh) {
            readChar();
            return match(ifType);
        } else {
            return match(elseType);
        }
    }

    pragma(inline, true)
    Token matchString() nothrow @nogc {
        readChar(); // consume '"'
        while (ch != '"' && ch != 0) {
            if (ch == '\\') {
                readChar();
            }
            readChar();
        }
        return match(TokenType.STRING);
    }

    pragma(inline, true)
    Token matchComment() nothrow @nogc {
        while (ch != 0 && ch != '\n') {
            readChar();
        }
        return match(TokenType.COMMENT);
    }

    pragma(inline, true)
    Token matchWhitespace() nothrow @nogc {
        while (isWhitespace(la)) {
            readChar();
        }
        return match(TokenType.WHITESPACE);
    }

    pragma(inline, true)
    Token matchIdentifier() nothrow @nogc {
        while (isLetter(la) || isDigit(la)) {
            readChar();
        }
        immutable(char)[] text = input[position .. readPosition];
        auto type = lookupKeyword(text);
        return Token(lineNo, colNo, type, text);
    }

    pragma(inline, true)
    static TokenType lookupKeyword(string identifier) pure nothrow @nogc {
        switch (identifier) {
        case "function":
            return TokenType.KEYWORD_FUNCTION;
        case "return":
            return TokenType.KEYWORD_RETURN;
        case "true":
            return TokenType.KEYWORD_TRUE;
        case "false":
            return TokenType.KEYWORD_FALSE;
        case "and":
            return TokenType.KEYWORD_AND;
        case "or":
            return TokenType.KEYWORD_OR;
        case "xor":
            return TokenType.KEYWORD_XOR;
        case "not":
            return TokenType.KEYWORD_NOT;
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
        default:
            return TokenType.IDENTIFIER;
        }
    }

    pragma(inline, true)
    Token matchNumber() nothrow @nogc {
        while (isDigit(la) || la == '_') {
            readChar();
        }
        if (la == '.') {
            readChar();
            while (isDigit(la) || la == '_') {
                readChar();
            }
            if (la == 'e' || la == 'E') {
                readChar();
                if (la == '-' || la == '+') {
                    readChar();
                }
                while (isDigit(la) || la == '_') {
                    readChar();
                }
            }
            return match(TokenType.FLOAT);
        } else {
            return match(TokenType.INTEGER);
        }
    }

    Token getNext() nothrow @nogc {
        position = readPosition;
        lineNo = readLineNo;
        colNo = readColNo;
        readChar();

        switch (ch) {
        case 0:
            return match(TokenType.EOF);
        case '^':
            return match(TokenType.POW);
        case ';':
            return match(TokenType.SEMICOLON);
        case ':':
            return match(TokenType.COLON);
        case ',':
            return match(TokenType.COMMA);
        case '{':
            return match(TokenType.LCURLY);
        case '}':
            return match(TokenType.RCURLY);
        case '[':
            return match(TokenType.LBRACKET);
        case ']':
            return match(TokenType.RBRACKET);
        case '(':
            return match(TokenType.LPAREN);
        case ')':
            return match(TokenType.RPAREN);
        case '+':
            return matchIf('=', TokenType.ASSIGN_PLUS, TokenType.PLUS);
        case '-':
            return matchIf('=', TokenType.ASSIGN_MINUS, TokenType.MINUS);
        case '*':
            return matchIf('=', TokenType.ASSIGN_MULTIPLY, TokenType.MULTIPLY);
        case '/':
            return matchIf('=', TokenType.ASSIGN_DIVIDE, TokenType.DIVIDE);
        case '%':
            return matchIf('=', TokenType.ASSIGN_MOD, TokenType.MOD);
        case '~':
            return matchIf('=', TokenType.ASSIGN_CONCAT, TokenType.CONCAT);
        case '=':
            return matchIf('=', TokenType.EQUAL, TokenType.ASSIGN);
        case '>':
            return matchIf('=', TokenType.GREATER_EQUAL, TokenType.GREATER_THAN);
        case '<':
            return matchIf('=', TokenType.LESS_EQUAL, TokenType.LESS_THAN);
        case '!':
            return matchIf('=', TokenType.NOT_EQUAL, TokenType.ILLEGAL);
        case '"':
            return matchString();
        case '#':
            return matchComment();
        default:
            if (isWhitespace(ch)) {
                return matchWhitespace();
            } else if (isLetter(ch)) {
                return matchIdentifier();
            } else if (isDigit(ch)) {
                return matchNumber();
            }
            return match(TokenType.ILLEGAL);
        }
    }
}

int main(string[] args) {
    if (args.length != 3) {
        stderr.writeln("Usage: zscript <input.zs> <output.csv>");
        return 1;
    }

    string inputFile = args[1];
    string outputFile = args[2];

    string input = cast(string) read(inputFile);

    auto output = File(outputFile, "wb");
    scope (exit) output.close();
    auto outputWriter = output.lockingTextWriter();

    auto lexer = new Lexer(input);
    Token token;

    while (true) {
        token = lexer.getNext();
        if (token.type == TokenType.EOF)
            break;

        auto text = token.text;

        if (token.type == TokenType.STRING) {
            // Remove surrounding quotes
            text = text[1 .. $ - 1];
        }
        if (token.type == TokenType.STRING ||
            token.type == TokenType.COMMENT) {
            // Escape double quotes by doubling them
            text = replace(text, "\"", "\"\"");
        }

        // Write CSV line
        // Format: lineNo,colNo,"text","tokenType"
        formattedWrite(outputWriter, "%d,%d,\"%s\",\"%s\"\n",
            token.lineNo,
            token.colNo,
            text,
            toString(token.type)
        );
    }

    output.flush();
    return 0;
}
