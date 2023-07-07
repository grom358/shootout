use std::fmt::Display;

#[derive(PartialEq)]
pub enum TokenType {
    Illegal,
    Eof,

    Whitespace,
    Comment,

    Identifier,
    Integer,
    Float,
    StringLiteral,

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
    AssignMulitply,
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
}

impl Display for TokenType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        return match self {
            TokenType::Illegal => write!(f, "illegal"),
            TokenType::Eof => write!(f, "eof"),
            TokenType::Whitespace => write!(f, "whitespace"),
            TokenType::Comment => write!(f, "comment"),
            TokenType::Identifier => write!(f, "id"),
            TokenType::Integer => write!(f, "integer"),
            TokenType::Float => write!(f, "float"),
            TokenType::StringLiteral => write!(f, "string"),
            TokenType::Assign => write!(f, "="),
            TokenType::Plus => write!(f, "+"),
            TokenType::Minus => write!(f, "-"),
            TokenType::Multiply => write!(f, "*"),
            TokenType::Divide => write!(f, "/"),
            TokenType::Mod => write!(f, "%"),
            TokenType::Pow => write!(f, "^"),
            TokenType::Concat => write!(f, "~"),
            TokenType::Equal => write!(f, "=="),
            TokenType::NotEqual => write!(f, "!="),
            TokenType::LessThan => write!(f, "<"),
            TokenType::GreaterThan => write!(f, ">"),
            TokenType::LessEqual => write!(f, "<="),
            TokenType::GreaterEqual => write!(f, ">="),
            TokenType::AssignPlus => write!(f, "+="),
            TokenType::AssignMinus => write!(f, "-="),
            TokenType::AssignMulitply => write!(f, "*="),
            TokenType::AssignDivide => write!(f, "/="),
            TokenType::AssignMod => write!(f, "%="),
            TokenType::AssignConcat => write!(f, "~="),
            TokenType::Lparen => write!(f, "("),
            TokenType::Rparen => write!(f, ")"),
            TokenType::Lbracket => write!(f, "["),
            TokenType::Rbracket => write!(f, "]"),
            TokenType::Lcurly => write!(f, "{{"),
            TokenType::Rcurly => write!(f, "}}"),
            TokenType::Semicolon => write!(f, ";"),
            TokenType::Colon => write!(f, ":"),
            TokenType::Comma => write!(f, ","),
            TokenType::Let => write!(f, "let"),
            TokenType::True => write!(f, "true"),
            TokenType::False => write!(f, "false"),
            TokenType::If => write!(f, "if"),
            TokenType::Else => write!(f, "else"),
            TokenType::While => write!(f, "while"),
            TokenType::Foreach => write!(f, "foreach"),
            TokenType::As => write!(f, "as"),
            TokenType::Not => write!(f, "not"),
            TokenType::And => write!(f, "and"),
            TokenType::Or => write!(f, "or"),
            TokenType::Xor => write!(f, "xor"),
            TokenType::Function => write!(f, "function"),
            TokenType::Return => write!(f, "return"),
        };
    }
}

pub struct Token {
    pub token_type: TokenType,
    pub line_no: usize,
    pub col_no: usize,
    pub literal: String,
}

pub struct Lexer {
    input: Vec<u8>,
    ch: u8,
    la: u8,
    read_pos: usize,
    read_line_no: usize,
    read_col_no: usize,
    pos: usize,
    line_no: usize,
    col_no: usize,
}

fn is_whitespace(ch: u8) -> bool {
    return ch == b' ' || ch == b'\t' || ch == b'\r' || ch == b'\n';
}

fn is_letter(ch: u8) -> bool {
    return (ch >= b'a' && ch <= b'z') || (ch >= b'A' && ch <= b'Z') || ch == b'_';
}

fn is_digit(ch: u8) -> bool {
    return ch >= b'0' && ch <= b'9';
}

impl Lexer {
    pub fn new(input: Vec<u8>) -> Lexer {
        let lexer = Lexer {
            read_pos: 0,
            read_line_no: 1,
            read_col_no: 1,
            pos: 0,
            line_no: 1,
            col_no: 1,
            ch: 0,
            la: 0,
            input,
        };
        return lexer;
    }

    fn read_char(&mut self) {
        if self.read_pos >= self.input.len() {
            self.ch = 0;
        } else {
            self.ch = self.input[self.read_pos];
            if self.ch == b'\n' {
                self.read_line_no += 1;
                self.read_col_no = 0;
            }
            self.read_col_no += 1;
            self.read_pos += 1;
        }
        if self.read_pos >= self.input.len() {
            self.la = 0;
        } else {
            self.la = self.input[self.read_pos];
        }
    }

    fn match_token(&self, token_type: TokenType) -> Token {
        let bytes = self.input[self.pos..self.read_pos].to_vec();
        let literal = unsafe { String::from_utf8_unchecked(bytes) };
        Token {
            token_type,
            line_no: self.line_no,
            col_no: self.col_no,
            literal,
        }
    }

    fn match_if(
        &mut self,
        if_ch: u8,
        if_token_type: TokenType,
        else_token_type: TokenType,
    ) -> Token {
        if self.la == if_ch {
            self.read_char();
            return self.match_token(if_token_type);
        } else {
            return self.match_token(else_token_type);
        }
    }

    fn match_string(&mut self) -> Token {
        self.read_char();
        while self.la != 0 && self.la != b'"' {
            if self.la == b'\\' {
                self.read_char();
            }
            self.read_char();
        }
        if self.la == b'"' {
            self.read_char();
        }
        return self.match_token(TokenType::StringLiteral);
    }

    fn match_comment(&mut self) -> Token {
        while self.ch != 0 && self.ch != b'\n' {
            self.read_char();
        }
        return self.match_token(TokenType::Comment);
    }

    fn match_whitespace(&mut self) -> Token {
        while is_whitespace(self.la) {
            self.read_char();
        }
        return self.match_token(TokenType::Whitespace);
    }

    fn match_identifier(&mut self) -> Token {
        while is_letter(self.la) || is_digit(self.la) {
            self.read_char();
        }
        let mut tok = self.match_token(TokenType::Identifier);
        match tok.literal.as_str() {
            "let" => {
                tok.token_type = TokenType::Let;
            }
            "true" => {
                tok.token_type = TokenType::True;
            }
            "false" => {
                tok.token_type = TokenType::False;
            }
            "if" => {
                tok.token_type = TokenType::If;
            }
            "else" => {
                tok.token_type = TokenType::Else;
            }
            "while" => {
                tok.token_type = TokenType::While;
            }
            "foreach" => {
                tok.token_type = TokenType::Foreach;
            }
            "as" => {
                tok.token_type = TokenType::As;
            }
            "and" => {
                tok.token_type = TokenType::And;
            }
            "or" => {
                tok.token_type = TokenType::Or;
            }
            "xor" => {
                tok.token_type = TokenType::Xor;
            }
            "not" => {
                tok.token_type = TokenType::Not;
            }
            "function" => {
                tok.token_type = TokenType::Function;
            }
            "return" => {
                tok.token_type = TokenType::Return;
            }
            &_ => { /* identifier */ }
        }
        return tok;
    }

    fn read_digits(&mut self) {
        while is_digit(self.la) || self.la == b'_' {
            self.read_char();
        }
    }

    fn match_number(&mut self) -> Token {
        self.read_digits();
        if self.la == b'.' {
            self.read_char();
            self.read_digits();
            if self.la == b'e' || self.la == b'E' {
                self.read_char();
                if self.la == b'-' || self.la == b'+' {
                    self.read_char();
                }
                self.read_digits();
            }
            return self.match_token(TokenType::Float);
        } else {
            return self.match_token(TokenType::Integer);
        }
    }

    pub fn next_token(&mut self) -> Token {
        self.pos = self.read_pos;
        self.line_no = self.read_line_no;
        self.col_no = self.read_col_no;
        self.read_char();

        match self.ch {
            b'(' => return self.match_token(TokenType::Lparen),
            b')' => return self.match_token(TokenType::Rparen),
            b'[' => return self.match_token(TokenType::Lbracket),
            b']' => return self.match_token(TokenType::Rbracket),
            b'{' => return self.match_token(TokenType::Lcurly),
            b'}' => return self.match_token(TokenType::Rcurly),
            b',' => return self.match_token(TokenType::Comma),
            b';' => return self.match_token(TokenType::Semicolon),
            b':' => return self.match_token(TokenType::Colon),
            b'^' => return self.match_token(TokenType::Pow),
            b'+' => return self.match_if(b'=', TokenType::AssignPlus, TokenType::Plus),
            b'-' => return self.match_if(b'=', TokenType::AssignMinus, TokenType::Minus),
            b'*' => return self.match_if(b'=', TokenType::AssignMulitply, TokenType::Multiply),
            b'/' => return self.match_if(b'=', TokenType::AssignDivide, TokenType::Divide),
            b'%' => return self.match_if(b'=', TokenType::AssignMod, TokenType::Mod),
            b'<' => return self.match_if(b'=', TokenType::LessEqual, TokenType::LessThan),
            b'>' => return self.match_if(b'=', TokenType::GreaterEqual, TokenType::GreaterThan),
            b'=' => return self.match_if(b'=', TokenType::Equal, TokenType::Assign),
            b'!' => return self.match_if(b'=', TokenType::NotEqual, TokenType::Illegal),
            b'~' => return self.match_if(b'=', TokenType::AssignConcat, TokenType::Concat),
            b'"' => return self.match_string(),
            b'#' => return self.match_comment(), 
            0 => return self.match_token(TokenType::Eof),
            _ => {
                if is_whitespace(self.ch) {
                    return self.match_whitespace();
                } else if is_letter(self.ch) {
                    return self.match_identifier();
                } else if is_digit(self.ch) {
                    return self.match_number();
                }
                return self.match_token(TokenType::Illegal);
            }
        }
    }
}
