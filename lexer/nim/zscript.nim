import os, strutils

# -------------------------
# Token types
# -------------------------
type
  TokenType = enum
    Illegal, Eof, Whitespace, Comment, Identifier, Integer, Float, String,
    Assign, Plus, Minus, Multiply, Divide, Mod, Pow, Concat, Equal, NotEqual,
    LessThan, GreaterThan, LessEqual, GreaterEqual,
    AssignPlus, AssignMinus, AssignMultiply, AssignDivide, AssignMod, AssignConcat,
    Lparen, Rparen, Lbracket, Rbracket, Lcurly, Rcurly,
    Semicolon, Colon, Comma, Let, True, False, If, Else, While, Foreach, As,
    Not, And, Or, Xor, Function, Return

  Token = object
    line_no: uint
    col_no: uint
    typ: TokenType
    literal: string

# -------------------------
# Token type conversion
# -------------------------
proc tokenTypeString(tt: TokenType): string =
  case tt
  of Illegal: return "illegal"
  of Eof: return "eof"
  of Whitespace: return "whitespace"
  of Comment: return "comment"
  of Identifier: return "id"
  of Float: return "float"
  of Integer: return "integer"
  of String: return "string"
  of Assign: return "="
  of Plus: return "+"
  of Minus: return "-"
  of Multiply: return "*"
  of Divide: return "/"
  of Mod: return "%"
  of Pow: return "^"
  of Concat: return "~"
  of Equal: return "=="
  of NotEqual: return "!="
  of LessThan: return "<"
  of GreaterThan: return ">"
  of LessEqual: return "<="
  of GreaterEqual: return ">="
  of AssignPlus: return "+="
  of AssignMinus: return "-="
  of AssignMultiply: return "*="
  of AssignDivide: return "/="
  of AssignMod: return "%="
  of AssignConcat: return "~="
  of Lparen: return "("
  of Rparen: return ")"
  of Lbracket: return "["
  of Rbracket: return "]"
  of Lcurly: return "{"
  of Rcurly: return "}"
  of Semicolon: return ";"
  of Colon: return ":"
  of Comma: return ","
  of Let: return "let"
  of True: return "true"
  of False: return "false"
  of If: return "if"
  of Else: return "else"
  of While: return "while"
  of Foreach: return "foreach"
  of As: return "as"
  of Not: return "not"
  of And: return "and"
  of Or: return "or"
  of Xor: return "xor"
  of Function: return "function"
  of Return: return "return"

proc tokenTypeKeyword(id: string): TokenType =
  case id
  of "let": return Let
  of "true": return True
  of "false": return False
  of "if": return If
  of "else": return Else
  of "while": return While
  of "foreach": return Foreach
  of "as": return As
  of "not": return Not
  of "and": return And
  of "or": return Or
  of "xor": return Xor
  of "function": return Function
  of "return": return Return
  else: return Identifier

# -------------------------
# Helpers
# -------------------------
proc isWhitespace(ch: char): bool =
  ch == ' ' or ch == '\t' or ch == '\r' or ch == '\n'

proc isLetter(ch: char): bool =
  (ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or ch == '_'

proc isDigit(ch: char): bool =
  ch >= '0' and ch <= '9'

proc isAlphanumeric(ch: char): bool =
  isLetter(ch) or isDigit(ch)

# -------------------------
# Lexer
# -------------------------
type Lexer = object
  ch, la: char
  read_position: int
  read_line_no, read_col_no: uint
  position: int
  line_no, col_no: uint
  length: int
  input: string

proc lexerInit(input: string): Lexer =
  Lexer(ch: '\0', la: '\0', read_position: 0, read_line_no: 1, read_col_no: 1,
        position: 0, line_no: 1, col_no: 1, length: input.len, input: input)

proc lexerReadChar(lexer: var Lexer) =
  if lexer.read_position >= lexer.length:
    lexer.ch = '\0'
  else:
    lexer.ch = lexer.input[lexer.read_position]
    if lexer.ch == '\n':
      lexer.read_line_no.inc()
      lexer.read_col_no = 0
    lexer.read_col_no.inc()
    lexer.read_position.inc()
  if lexer.read_position >= lexer.length:
    lexer.la = '\0'
  else:
    lexer.la = lexer.input[lexer.read_position]

proc lexerMatch(lexer: Lexer, typ: TokenType): Token =
  let literal = cast[string](lexer.input[lexer.position..<lexer.read_position])
  Token(line_no: lexer.line_no, col_no: lexer.col_no, typ: typ, literal: literal)

proc lexerMatchIf(lexer: var Lexer, test: char, typIf: TokenType, typElse: TokenType): Token =
  if lexer.la == test:
    lexerReadChar(lexer)
    return lexerMatch(lexer, typIf)
  else:
    return lexerMatch(lexer, typElse)

proc lexerMatchWhitespace(lexer: var Lexer): Token =
  while isWhitespace(lexer.la):
    lexerReadChar(lexer)
  return lexerMatch(lexer, Whitespace)

proc lexerMatchComment(lexer: var Lexer): Token =
  while lexer.ch != '\0' and lexer.ch != '\n':
    lexerReadChar(lexer)
  return lexerMatch(lexer, Comment)

proc lexerMatchString(lexer: var Lexer): Token =
  while lexer.la != '\0' and lexer.la != '"':
    if lexer.la == '\\':
      lexerReadChar(lexer)
    lexerReadChar(lexer)
  if lexer.la == '"':
    lexerReadChar(lexer)
  return lexerMatch(lexer, TokenType.String)

proc lexerMatchNumber(lexer: var Lexer): Token =
  while isDigit(lexer.la) or lexer.la == '_':
    lexerReadChar(lexer)
  if lexer.la == '.':
    lexerReadChar(lexer)
    while isDigit(lexer.la) or lexer.la == '_':
      lexerReadChar(lexer)
    if lexer.la == 'e' or lexer.la == 'E':
      lexerReadChar(lexer)
      if lexer.la == '-' or lexer.la == '+':
        lexerReadChar(lexer)
      while isDigit(lexer.la) or lexer.la == '_':
        lexerReadChar(lexer)
    return lexerMatch(lexer, Float)
  else:
    return lexerMatch(lexer, Integer)

proc lexerMatchIdentifier(lexer: var Lexer): Token =
  while isAlphanumeric(lexer.la):
    lexerReadChar(lexer)
  var token = lexerMatch(lexer, Identifier)
  token.typ = tokenTypeKeyword(token.literal)
  return token

proc lexerNextToken(lexer: var Lexer): Token =
  lexer.position = lexer.read_position
  lexer.line_no = lexer.read_line_no
  lexer.col_no = lexer.read_col_no
  lexerReadChar(lexer)

  case lexer.ch
  of '(': return lexerMatch(lexer, Lparen)
  of ')': return lexerMatch(lexer, Rparen)
  of '[': return lexerMatch(lexer, Lbracket)
  of ']': return lexerMatch(lexer, Rbracket)
  of '{': return lexerMatch(lexer, Lcurly)
  of '}': return lexerMatch(lexer, Rcurly)
  of ';': return lexerMatch(lexer, Semicolon)
  of ':': return lexerMatch(lexer, Colon)
  of ',': return lexerMatch(lexer, Comma)
  of '^': return lexerMatch(lexer, Pow)
  of '+': return lexerMatchIf(lexer, '=', AssignPlus, Plus)
  of '-': return lexerMatchIf(lexer, '=', AssignMinus, Minus)
  of '*': return lexerMatchIf(lexer, '=', AssignMultiply, Multiply)
  of '/': return lexerMatchIf(lexer, '=', AssignDivide, Divide)
  of '%': return lexerMatchIf(lexer, '=', AssignMod, Mod)
  of '=': return lexerMatchIf(lexer, '=', Equal, Assign)
  of '!': return lexerMatchIf(lexer, '=', NotEqual, Not)
  of '~': return lexerMatchIf(lexer, '=', AssignConcat, Concat)
  of '>': return lexerMatchIf(lexer, '=', GreaterEqual, GreaterThan)
  of '<': return lexerMatchIf(lexer, '=', LessEqual, LessThan)
  of '"': return lexerMatchString(lexer)
  of '#': return lexerMatchComment(lexer)
  of '\0': return lexerMatch(lexer, Eof)
  else:
    if isWhitespace(lexer.ch):
      return lexerMatchWhitespace(lexer)
    elif isLetter(lexer.ch):
      return lexerMatchIdentifier(lexer)
    elif isDigit(lexer.ch):
      return lexerMatchNumber(lexer)
    else:
      return lexerMatch(lexer, Illegal)

# -------------------------
# Main
# -------------------------
proc main() =
  if paramCount() != 2:
    echo "Usage: zscript <input.zs> <output.csv>"
    quit(1)

  let inputPath = paramStr(1)
  let outputPath = paramStr(2)

  # Read input file
  let input = readFile(inputPath)

  # Open output
  let fOut = open(outputPath, fmWrite)
  defer: fOut.close()

  var lexer = lexerInit(input)

  while true:
    let token = lexerNextToken(lexer)
    if token.typ == Eof:
      break

    var literal = token.literal
    if token.typ == String:
      if literal.len >= 2:
        literal = literal[1..^2]  # strip quotes
    if token.typ in {String, Comment}:
      literal = literal.replace("\"", "\"\"")

    fOut.writeLine($token.line_no & "," & $token.col_no & ",\"" & literal &
                "\",\"" & tokenTypeString(token.typ) & "\"")

when isMainModule:
  main()

