package main

import "core:fmt"
import "core:io"
import "core:bufio"
import "core:os"
import "core:strings"

ChunkSize :: 4096

main :: proc() {
	buffer := [dynamic]u8{}
	chunk := [ChunkSize]u8{}
	stdin := os.stream_from_handle(os.stdin)
	stdout := os.stream_from_handle(os.stdout)
	buf_writer: bufio.Writer
	bufio.writer_init(&buf_writer, stdout)
	//writer := bufio.writer_to_writer(&buf_writer)

	for {
		num_read, err := io.read(stdin, chunk[0:ChunkSize])
		if num_read == 0 {
			break
		}
		if err != nil {
			fmt.println("Error reading:", err)
			return
		}
		append(&buffer, ..chunk[0:num_read])
	}
	lexer := lexer_init(buffer[:])
	builder: strings.Builder
	strings.builder_init_len_cap(&builder, 0, ChunkSize)
	for {
		defer free_all(context.temp_allocator)
		token := lexer_next_token(&lexer)
		if token.type == TokenType.Eof {
			break
		}
		type := token_type_string(token.type)
		literal := token.literal
		if token.type == TokenType.String {
			literal = literal[1:len(literal) - 1]
		}
		if token.type == TokenType.String || token.type == TokenType.Comment {
			literal, _ = strings.replace_all(literal, "\"", "\"\"", context.temp_allocator)
		}
		// The format machinery is slow. Instead of
		// fmt.wprintf(writer, "%d,%d,\"%s\",\"%s\"\n", token.line_no, token.col_no, literal, type)
		// build the string and write
		strings.write_uint(&builder, token.line_no)
		strings.write_rune(&builder, ',')
		strings.write_uint(&builder, token.col_no)
		strings.write_string(&builder, ",\"")
		strings.write_string(&builder, literal)
		strings.write_string(&builder, "\",\"")
		strings.write_string(&builder, token_type_string(token.type))
		strings.write_string(&builder, "\"\n")
		bufio.writer_write_string(&buf_writer, strings.to_string(builder))
		strings.builder_reset(&builder)
	}
	bufio.writer_flush(&buf_writer)
}

TokenType :: enum {
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
}

token_type_string :: proc(token_type: TokenType) -> string {
	switch token_type {
	case .Illegal:
		return "illegal"
	case .Eof:
		return "eof"
	case .Whitespace:
		return "whitespace"
	case .Comment:
		return "comment"
	case .Identifier:
		return "id"
	case .Float:
		return "float"
	case .Integer:
		return "integer"
	case .String:
		return "string"
	case .Assign:
		return "="
	case .Plus:
		return "+"
	case .Minus:
		return "-"
	case .Multiply:
		return "*"
	case .Divide:
		return "/"
	case .Mod:
		return "%"
	case .Pow:
		return "^"
	case .Concat:
		return "~"
	case .Equal:
		return "=="
	case .NotEqual:
		return "!="
	case .LessThan:
		return "<"
	case .GreaterThan:
		return ">"
	case .LessEqual:
		return "<="
	case .GreaterEqual:
		return ">="
	case .AssignPlus:
		return "+="
	case .AssignMinus:
		return "-="
	case .AssignMultiply:
		return "*="
	case .AssignDivide:
		return "/="
	case .AssignMod:
		return "%="
	case .AssignConcat:
		return "~="
	case .Lparen:
		return "("
	case .Rparen:
		return ")"
	case .Lbracket:
		return "["
	case .Rbracket:
		return "]"
	case .Lcurly:
		return "{"
	case .Rcurly:
		return "}"
	case .Semicolon:
		return ";"
	case .Colon:
		return ":"
	case .Comma:
		return ","
	case .Let:
		return "let"
	case .True:
		return "true"
	case .False:
		return "false"
	case .If:
		return "if"
	case .Else:
		return "else"
	case .While:
		return "while"
	case .Foreach:
		return "foreach"
	case .As:
		return "as"
	case .Not:
		return "not"
	case .And:
		return "and"
	case .Or:
		return "or"
	case .Xor:
		return "xor"
	case .Function:
		return "function"
	case .Return:
		return "return"
	}
	return "unknown"
}

token_type_keyword :: proc(id: string) -> TokenType {
	using TokenType
	switch id {
	case "let":
		return Let
	case "true":
		return True
	case "false":
		return False
	case "if":
		return If
	case "else":
		return Else
	case "while":
		return While
	case "foreach":
		return Foreach
	case "as":
		return As
	case "not":
		return Not
	case "and":
		return And
	case "or":
		return Or
	case "xor":
		return Xor
	case "function":
		return Function
	case "return":
		return Return
	case:
		return Identifier
	}
}

Token :: struct {
	line_no: uint,
	col_no:  uint,
	type:    TokenType,
	literal: string,
}

is_whitespace :: proc(ch: u8) -> bool {
	return ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n'
}

is_letter :: proc(ch: u8) -> bool {
	return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_'
}

is_digit :: proc(ch: u8) -> bool {
	return ch >= '0' && ch <= '9'
}

is_alphanumeric :: proc(ch: u8) -> bool {
	return is_letter(ch) || is_digit(ch)
}

Lexer :: struct {
	ch:            u8,
	la:            u8,
	read_position: uint,
	read_line_no:  uint,
	read_col_no:   uint,
	position:      uint,
	line_no:       uint,
	col_no:        uint,
	length:        uint,
	input:         []u8,
}

lexer_init :: proc(input: []u8) -> Lexer {
	return Lexer{0, 0, 0, 1, 1, 0, 1, 1, len(input), input}
}

lexer_read_char :: proc(lexer: ^Lexer) {
	if lexer.read_position >= lexer.length {
		lexer.ch = 0
	} else {
		lexer.ch = lexer.input[lexer.read_position]
		if lexer.ch == '\n' {
			lexer.read_line_no += 1
			lexer.read_col_no = 0
		}
		lexer.read_col_no += 1
		lexer.read_position += 1
	}
	if lexer.read_position >= lexer.length {
		lexer.la = 0
	} else {
		lexer.la = lexer.input[lexer.read_position]
	}
}

lexer_match :: proc(lexer: ^Lexer, token_type: TokenType) -> Token {
	using lexer
	literal := string(input[position:read_position])
	return Token{line_no, col_no, token_type, literal}
}

lexer_match_if :: proc(
	lexer: ^Lexer,
	if_ch: u8,
	if_token_type: TokenType,
	else_token_type: TokenType,
) -> Token {
	if lexer.la == if_ch {
		lexer_read_char(lexer)
		return lexer_match(lexer, if_token_type)
	} else {
		return lexer_match(lexer, else_token_type)
	}
}

lexer_match_string :: proc(lexer: ^Lexer) -> Token {
	for lexer.la != 0 && lexer.la != '"' {
		if lexer.la == '\\' {
			lexer_read_char(lexer)
		}
		lexer_read_char(lexer)
	}
	if lexer.la == '"' {
		lexer_read_char(lexer)
	}
	return lexer_match(lexer, TokenType.String)
}

lexer_match_whitespace :: proc(lexer: ^Lexer) -> Token {
	for is_whitespace(lexer.la) {
		lexer_read_char(lexer)
	}
	return lexer_match(lexer, TokenType.Whitespace)
}

lexer_match_comment :: proc(lexer: ^Lexer) -> Token {
	for lexer.ch != 0 && lexer.ch != '\n' {
		lexer_read_char(lexer)
	}
	return lexer_match(lexer, TokenType.Comment)
}

lexer_match_identifier :: proc(lexer: ^Lexer) -> Token {
	for is_alphanumeric(lexer.la) {
		lexer_read_char(lexer)
	}
	token := lexer_match(lexer, TokenType.Identifier)
	token.type = token_type_keyword(token.literal)
	return token
}

lexer_match_number :: proc(lexer: ^Lexer) -> Token {
	for is_digit(lexer.la) || lexer.la == '_' {
		lexer_read_char(lexer)
	}
	if lexer.la == '.' {
		lexer_read_char(lexer)
		for is_digit(lexer.la) || lexer.la == '_' {
			lexer_read_char(lexer)
		}
		if lexer.la == 'e' || lexer.la == 'E' {
			lexer_read_char(lexer)
			if lexer.la == '+' || lexer.la == '-' {
				lexer_read_char(lexer)
			}
			for is_digit(lexer.la) || lexer.la == '_' {
				lexer_read_char(lexer)
			}
		}
		return lexer_match(lexer, TokenType.Float)
	} else {
		return lexer_match(lexer, TokenType.Integer)
	}
}

lexer_next_token :: proc(lexer: ^Lexer) -> Token {
	lexer.position = lexer.read_position
	lexer.line_no = lexer.read_line_no
	lexer.col_no = lexer.read_col_no
	lexer_read_char(lexer)
	literal := lexer.input[lexer.position:lexer.read_position]
	using TokenType
	switch lexer.ch {
	case '(':
		return lexer_match(lexer, Lparen)
	case ')':
		return lexer_match(lexer, Rparen)
	case '[':
		return lexer_match(lexer, Lbracket)
	case ']':
		return lexer_match(lexer, Rbracket)
	case '{':
		return lexer_match(lexer, Lcurly)
	case '}':
		return lexer_match(lexer, Rcurly)
	case ';':
		return lexer_match(lexer, Semicolon)
	case ':':
		return lexer_match(lexer, Colon)
	case ',':
		return lexer_match(lexer, Comma)
	case '^':
		return lexer_match(lexer, Pow)
	case '+':
		return lexer_match_if(lexer, '=', AssignPlus, Plus)
	case '-':
		return lexer_match_if(lexer, '=', AssignMinus, Minus)
	case '*':
		return lexer_match_if(lexer, '=', AssignMultiply, Multiply)
	case '/':
		return lexer_match_if(lexer, '=', AssignDivide, Divide)
	case '%':
		return lexer_match_if(lexer, '=', AssignMod, Mod)
	case '<':
		return lexer_match_if(lexer, '=', LessEqual, LessThan)
	case '>':
		return lexer_match_if(lexer, '=', GreaterEqual, GreaterThan)
	case '=':
		return lexer_match_if(lexer, '=', Equal, Assign)
	case '!':
		return lexer_match_if(lexer, '=', NotEqual, Illegal)
	case '~':
		return lexer_match_if(lexer, '=', AssignConcat, Concat)
	case '"':
		return lexer_match_string(lexer)
	case '#':
		return lexer_match_comment(lexer)
	case 0:
		return lexer_match(lexer, Eof)
	case:
		if is_whitespace(lexer.ch) {
			return lexer_match_whitespace(lexer)
		} else if is_letter(lexer.ch) {
			return lexer_match_identifier(lexer)
		} else if is_digit(lexer.ch) {
			return lexer_match_number(lexer)
		} else {
			return lexer_match(lexer, Illegal)
		}
	}
}
