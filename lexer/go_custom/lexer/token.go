package lexer

type TokenType string

const (
	Illegal = "illegal"
	Eof     = "eof"

	Whitespace = "whitespace"
	Comment    = "comment"

	Identifier = "id"
	Integer    = "integer"
	Float      = "float"
	String     = "string"

	// Operators
	Assign         = "="
	Plus           = "+"
	Minus          = "-"
	Multiply       = "*"
	Divide         = "/"
	Mod            = "%"
	Pow            = "^"
	Concat         = "~"
	Equal          = "=="
	NotEqual       = "!="
	LessThan       = "<"
	GreaterThan    = ">"
	LessEqual      = "<="
	GreaterEqual   = ">="
	AssignPlus     = "+="
	AssignMinus    = "-="
	AssignMultiply = "*="
	AssignDivide   = "/="
	AssignMod      = "%="
	AssignConcat   = "~="

	// Delimiters
	Lparen    = "("
	Rparen    = ")"
	Lbracket  = "["
	Rbracket  = "]"
	Lcurly    = "{"
	Rcurly    = "}"
	Semicolon = ";"
	Colon     = ":"
	Comma     = ","

	// Keywords
	Let      = "let"
	True     = "true"
	False    = "false"
	If       = "if"
	Else     = "else"
	While    = "while"
	Foreach  = "foreach"
	As       = "as"
	Not      = "not"
	And      = "and"
	Or       = "or"
	Xor      = "xor"
	Function = "function"
	Return   = "return"
)

type Token struct {
	Type    TokenType
	LineNo  uint
	ColNo   uint
	Literal string
}

var keywords = map[string]TokenType{
	"let":      Let,
	"true":     True,
	"false":    False,
	"if":       If,
	"else":     Else,
	"while":    While,
	"foreach":  Foreach,
	"as":       As,
	"and":      And,
	"or":       Or,
	"xor":      Xor,
	"not":      Not,
	"function": Function,
	"return":   Return,
}

func LookupIdenitifer(id string) TokenType {
	if tok, ok := keywords[id]; ok {
		return tok
	}
	return Identifier
}
