const std = @import("std");

pub fn main() !void {
    const backingAllocator = std.heap.page_allocator;
    var arena = std.heap.ArenaAllocator.init(backingAllocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 3) {
        std.debug.print("Usage: {s} <input-file> <output-file>\n", .{args[0]});
        return;
    }

    const input_path = args[1];
    const output_path = args[2];

    const input_file = try std.fs.cwd().openFile(input_path, .{});
    defer input_file.close();
    const input = try input_file.readToEndAlloc(allocator, 1024 * 1024 * 1024 * 4);

    const output_file = try std.fs.cwd().createFile(output_path, .{ .truncate = true });
    defer output_file.close();
    var bufferedWriter = std.io.bufferedWriter(output_file.writer());
    var out = bufferedWriter.writer();

    var lexer = Lexer.init(input);

    while (true) {
        const token = lexer.nextToken();
        if (token.tokenType == TokenType.Eof) {
            break;
        }
        const tokenType = token.tokenType.toString();
        var literal = token.literal;
        if (token.tokenType == TokenType.String) {
            literal = literal[1 .. literal.len - 1];
        }
        if (token.tokenType == TokenType.String or token.tokenType == TokenType.Comment) {
            literal = std.mem.replaceOwned(
                u8,
                allocator,
                literal,
                "\"",
                "\"\"",
            ) catch @panic("out of memory");
            defer allocator.free(literal);
            try out.print("{d},{d},\"{s}\",\"{s}\"\n", .{ token.lineNo, token.colNo, literal, tokenType });
        } else {
            try out.print("{d},{d},\"{s}\",\"{s}\"\n", .{ token.lineNo, token.colNo, literal, tokenType });
        }
    }
    try bufferedWriter.flush();
}

const TokenType = enum {
    Illegal,
    Eof,
    Whitespace,
    Comment,
    Identifier,
    Integer,
    Float,
    String,
    Assign,
    Plus,
    Minus,
    Multiply,
    Divide,
    Mod,
    Pow,
    Concat,
    Equal,
    NotEqual,
    LessThan,
    GreaterThan,
    LessEqual,
    GreaterEqual,
    AssignPlus,
    AssignMinus,
    AssignMultiply,
    AssignDivide,
    AssignMod,
    AssignConcat,
    Lparen,
    Rparen,
    Lbracket,
    Rbracket,
    Lcurly,
    Rcurly,
    Semicolon,
    Colon,
    Comma,
    Let,
    True,
    False,
    If,
    Else,
    While,
    Foreach,
    As,
    Not,
    And,
    Or,
    Xor,
    Function,
    Return,

    pub fn toString(self: TokenType) []const u8 {
        const str = switch (self) {
            .Illegal => "illegal",
            .Eof => "eof",
            .Whitespace => "whitespace",
            .Comment => "comment",
            .Identifier => "id",
            .Integer => "integer",
            .Float => "float",
            .String => "string",
            .Assign => "=",
            .Plus => "+",
            .Minus => "-",
            .Multiply => "*",
            .Divide => "/",
            .Mod => "%",
            .Pow => "^",
            .Concat => "~",
            .Equal => "==",
            .NotEqual => "!=",
            .LessThan => "<",
            .GreaterThan => ">",
            .LessEqual => "<=",
            .GreaterEqual => ">=",
            .AssignPlus => "+=",
            .AssignMinus => "-=",
            .AssignMultiply => "*=",
            .AssignDivide => "/=",
            .AssignMod => "%=",
            .AssignConcat => "~=",
            .Lparen => "(",
            .Rparen => ")",
            .Lbracket => "[",
            .Rbracket => "]",
            .Lcurly => "{",
            .Rcurly => "}",
            .Semicolon => ";",
            .Colon => ":",
            .Comma => ",",
            .Let => "let",
            .True => "true",
            .False => "false",
            .If => "if",
            .Else => "else",
            .While => "while",
            .Foreach => "foreach",
            .As => "as",
            .Not => "not",
            .And => "and",
            .Or => "or",
            .Xor => "xor",
            .Function => "function",
            .Return => "return",
        };
        return str;
    }

    fn keyword(ident: []const u8) ?TokenType {
        const map = std.StaticStringMap(TokenType).initComptime(.{
            .{ "let", .Let },
            .{ "true", .True },
            .{ "false", .False },
            .{ "if", .If },
            .{ "else", .Else },
            .{ "while", .While },
            .{ "foreach", .Foreach },
            .{ "as", .As },
            .{ "not", .Not },
            .{ "and", .And },
            .{ "or", .Or },
            .{ "xor", .Xor },
            .{ "function", .Function },
            .{ "return", .Return },
        });
        return map.get(ident);
    }
};

const Token = struct {
    tokenType: TokenType,
    lineNo: usize,
    colNo: usize,
    literal: []const u8,
};

inline fn isLetter(ch: u8) bool {
    return std.ascii.isAlphabetic(ch) or ch == '_';
}

inline fn isDigit(ch: u8) bool {
    return std.ascii.isDigit(ch);
}

inline fn isAlphanumeric(ch: u8) bool {
    return isLetter(ch) or isDigit(ch);
}

const Lexer = struct {
    ch: u8,
    la: u8,
    readPosition: usize,
    readLineNo: usize,
    readColNo: usize,
    position: usize,
    lineNo: usize,
    colNo: usize,
    input: []const u8,

    pub fn init(input: []u8) Lexer {
        return Lexer{
            .ch = 0,
            .la = 0,
            .readPosition = 0,
            .readLineNo = 1,
            .readColNo = 1,
            .position = 0,
            .lineNo = 1,
            .colNo = 1,
            .input = input,
        };
    }

    inline fn readChar(self: *Lexer) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
            if (self.ch == '\n') {
                self.readLineNo += 1;
                self.readColNo = 0;
            }
            self.readColNo += 1;
            self.readPosition += 1;
        }
        if (self.readPosition >= self.input.len) {
            self.la = 0;
        } else {
            self.la = self.input[self.readPosition];
        }
    }

    inline fn match(self: *Lexer, tokenType: TokenType) Token {
        const literal = self.input[self.position..self.readPosition];
        return Token{
            .tokenType = tokenType,
            .lineNo = self.lineNo,
            .colNo = self.colNo,
            .literal = literal,
        };
    }

    inline fn matchIf(self: *Lexer, ifChar: u8, ifTokenType: TokenType, elseTokenType: TokenType) Token {
        if (self.la == ifChar) {
            self.readChar();
            return self.match(ifTokenType);
        } else {
            return self.match(elseTokenType);
        }
    }

    inline fn matchComment(self: *Lexer) Token {
        while (self.ch != 0 and self.ch != '\n') {
            self.readChar();
        }
        return self.match(TokenType.Comment);
    }

    inline fn matchString(self: *Lexer) Token {
        while (self.la != 0 and self.la != '"') {
            if (self.la == '\\') {
                self.readChar();
            }
            self.readChar();
        }
        if (self.la == '"') {
            self.readChar();
        }
        return self.match(TokenType.String);
    }

    inline fn matchWhitespace(self: *Lexer) Token {
        while (std.ascii.isWhitespace(self.la)) {
            self.readChar();
        }
        return self.match(TokenType.Whitespace);
    }

    inline fn matchIdentifier(self: *Lexer) Token {
        while (isAlphanumeric(self.la)) {
            self.readChar();
        }
        var token = self.match(TokenType.Identifier);
        if (TokenType.keyword(token.literal)) |tokenType| {
            token.tokenType = tokenType;
        }
        return token;
    }

    inline fn matchNumber(self: *Lexer) Token {
        var tokenType = TokenType.Integer;
        while (isDigit(self.la) or self.la == '_') {
            self.readChar();
        }
        if (self.la == '.') {
            tokenType = TokenType.Float;
            self.readChar();
            while (isDigit(self.la) or self.la == '_') {
                self.readChar();
            }
            if (self.la == 'e' or self.la == 'E') {
                self.readChar();
                if (self.la == '+' or self.la == '-') {
                    self.readChar();
                }
                while (isDigit(self.la) or self.la == '_') {
                    self.readChar();
                }
            }
        }
        return self.match(tokenType);
    }

    pub fn nextToken(self: *Lexer) Token {
        self.position = self.readPosition;
        self.lineNo = self.readLineNo;
        self.colNo = self.readColNo;
        self.readChar();
        const token = switch (self.ch) {
            '(' => self.match(TokenType.Lparen),
            ')' => self.match(TokenType.Rparen),
            '[' => self.match(TokenType.Lbracket),
            ']' => self.match(TokenType.Rbracket),
            '{' => self.match(TokenType.Lcurly),
            '}' => self.match(TokenType.Rcurly),
            ';' => self.match(TokenType.Semicolon),
            ':' => self.match(TokenType.Colon),
            ',' => self.match(TokenType.Comma),
            '^' => self.match(TokenType.Pow),
            '+' => self.matchIf('=', TokenType.AssignPlus, TokenType.Plus),
            '-' => self.matchIf('=', TokenType.AssignMinus, TokenType.Minus),
            '*' => self.matchIf('=', TokenType.AssignMultiply, TokenType.Multiply),
            '/' => self.matchIf('=', TokenType.AssignDivide, TokenType.Divide),
            '%' => self.matchIf('=', TokenType.AssignMod, TokenType.Mod),
            '~' => self.matchIf('=', TokenType.AssignConcat, TokenType.Concat),
            '<' => self.matchIf('=', TokenType.LessEqual, TokenType.LessThan),
            '>' => self.matchIf('=', TokenType.GreaterEqual, TokenType.GreaterThan),
            '=' => self.matchIf('=', TokenType.Equal, TokenType.Assign),
            '!' => self.matchIf('=', TokenType.NotEqual, TokenType.Illegal),
            '#' => self.matchComment(),
            '"' => self.matchString(),
            0 => self.match(TokenType.Eof),
            else => {
                if (std.ascii.isWhitespace(self.ch)) {
                    return self.matchWhitespace();
                } else if (isLetter(self.ch)) {
                    return self.matchIdentifier();
                } else if (isDigit(self.ch)) {
                    return self.matchNumber();
                } else {
                    return self.match(TokenType.Illegal);
                }
            },
        };
        return token;
    }
};
