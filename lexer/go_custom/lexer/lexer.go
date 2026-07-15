package lexer

func isLetter(ch byte) bool {
	return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
}

func isDigit(ch byte) bool {
	return '0' <= ch && ch <= '9'
}

func isWhitespace(ch byte) bool {
	return ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n'
}

type Lexer struct {
	input string

	// Reader state
	ch           byte // Current read character
	la           byte // Lookahead character (ie. next character in input)
	readPosition int
	readLineNo   uint
	readColNo    uint

	// Current position
	position int
	lineNo   uint
	colNo    uint
}

func New(input string) *Lexer {
	l := &Lexer{input: input, readLineNo: 1, readColNo: 1}
	return l
}

func (l *Lexer) NextToken() Token {
	l.position = l.readPosition
	l.lineNo = l.readLineNo
	l.colNo = l.readColNo
	l.readChar()

	switch l.ch {
	case '(':
		return l.match(Lparen)
	case ')':
		return l.match(Rparen)
	case '[':
		return l.match(Lbracket)
	case ']':
		return l.match(Rbracket)
	case '{':
		return l.match(Lcurly)
	case '}':
		return l.match(Rcurly)
	case ';':
		return l.match(Semicolon)
	case ':':
		return l.match(Colon)
	case ',':
		return l.match(Comma)
	case '+':
		return l.matchIf('=', AssignPlus, Plus)
	case '-':
		return l.matchIf('=', AssignMinus, Minus)
	case '*':
		return l.matchIf('=', AssignMultiply, Multiply)
	case '/':
		return l.matchIf('=', AssignDivide, Divide)
	case '%':
		return l.matchIf('=', AssignMod, Mod)
	case '<':
		return l.matchIf('=', LessEqual, LessThan)
	case '>':
		return l.matchIf('=', GreaterEqual, GreaterThan)
	case '=':
		return l.matchIf('=', Equal, Assign)
	case '!':
		return l.matchIf('=', NotEqual, Illegal)
	case '~':
		return l.matchIf('=', AssignConcat, Concat)
	case '^':
		return l.match(Pow)
	case '"':
		return l.matchString()
	case '#':
		return l.matchComment()
	case 0:
		return l.match(Eof)
	default:
		if isLetter(l.ch) {
			return l.matchIdentifier()
		} else if isDigit(l.ch) {
			return l.matchNumber()
		} else if isWhitespace(l.ch) {
			return l.matchWhitespace()
		} else {
			return l.match(Illegal)
		}
	}
}

func (l *Lexer) readChar() {
	if l.readPosition >= len(l.input) {
		l.ch = 0
	} else {
		l.ch = l.input[l.readPosition]
		if l.ch == '\n' {
			l.readLineNo += 1
			l.readColNo = 0
		}
		l.readColNo += 1
		l.readPosition += 1
	}
	if l.readPosition >= len(l.input) {
		l.la = 0
	} else {
		l.la = l.input[l.readPosition]
	}
}

func (l *Lexer) match(tokenType TokenType) Token {
	return Token{
		LineNo:  l.lineNo,
		ColNo:   l.colNo,
		Type:    tokenType,
		Literal: l.input[l.position:l.readPosition]}
}

func (l *Lexer) matchIf(
	test byte,
	typeIf TokenType,
	typeElse TokenType) Token {
	if l.la == test {
		l.readChar()
		return l.match(typeIf)
	} else {
		return l.match(typeElse)
	}
}

func (l *Lexer) matchIdentifier() Token {
	for isLetter(l.la) || isDigit(l.la) {
		l.readChar()
	}
	tok := l.match(Identifier)
	tok.Type = LookupIdenitifer(tok.Literal)
	return tok
}

func (l *Lexer) matchWhitespace() Token {
	for isWhitespace(l.la) {
		l.readChar()
	}
	return l.match(Whitespace)
}

func (l *Lexer) matchComment() Token {
	for l.ch != 0 && l.ch != '\n' {
		l.readChar()
	}
	return l.match(Comment)
}

func (l *Lexer) matchNumber() Token {
	for isDigit(l.la) || l.la == '_' {
		l.readChar()
	}
	if l.la == '.' {
		l.readChar()
		for isDigit(l.la) || l.la == '_' {
			l.readChar()
		}
		if l.la == 'e' || l.la == 'E' {
			l.readChar()
			if l.la == '-' || l.la == '+' {
				l.readChar()
			}
			for isDigit(l.la) || l.la == '_' {
				l.readChar()
			}
		}
		return l.match(Float)
	}
	return l.match(Integer)
}

func (l *Lexer) matchString() Token {
	l.readChar()
	for l.la != 0 && l.la != '"' {
		if l.la == '\\' {
			l.readChar()
		}
		l.readChar()
	}
	if l.la == '"' {
		l.readChar()
	}
	return l.match(String)
}
