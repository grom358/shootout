type token_type =
  | Illegal
  | Eof
  | Whitespace
  | Comment
  | Identifier
  | Integer
  | Float
  | StringLiteral
  | Assign
  | Plus
  | Minus
  | Multiply
  | Divide
  | Mod
  | Pow
  | Concat
  | Equal
  | NotEqual
  | LessThan
  | GreaterThan
  | LessEqual
  | GreaterEqual
  | AssignPlus
  | AssignMinus
  | AssignMultiply
  | AssignDivide
  | AssignMod
  | AssignConcat
  | Lparen
  | Rparen
  | Lbracket
  | Rbracket
  | Lcurly
  | Rcurly
  | Semicolon
  | Colon
  | Comma
  | Let
  | True
  | False
  | If
  | Else
  | While
  | Foreach
  | As
  | Not
  | And
  | Or
  | Xor
  | Function
  | Return

let string_of_token_type = function
  | Illegal -> "illegal"
  | Eof -> "eof"
  | Whitespace -> "whitespace"
  | Comment -> "comment"
  | Identifier -> "id"
  | Integer -> "integer"
  | Float -> "float"
  | StringLiteral -> "string"
  | Assign -> "="
  | Plus -> "+"
  | Minus -> "-"
  | Multiply -> "*"
  | Divide -> "/"
  | Mod -> "%"
  | Pow -> "^"
  | Concat -> "~"
  | Equal -> "=="
  | NotEqual -> "!="
  | LessThan -> "<"
  | GreaterThan -> ">"
  | LessEqual -> "<="
  | GreaterEqual -> ">="
  | AssignPlus -> "+="
  | AssignMinus -> "-="
  | AssignMultiply -> "*="
  | AssignDivide -> "/="
  | AssignMod -> "%="
  | AssignConcat -> "~="
  | Lparen -> "("
  | Rparen -> ")"
  | Lbracket -> "["
  | Rbracket -> "]"
  | Lcurly -> "{"
  | Rcurly -> "}"
  | Semicolon -> ";"
  | Colon -> ":"
  | Comma -> ","
  | Let -> "let"
  | True -> "true"
  | False -> "false"
  | If -> "if"
  | Else -> "else"
  | While -> "while"
  | Foreach -> "foreach"
  | As -> "as"
  | Not -> "not"
  | And -> "and"
  | Or -> "or"
  | Xor -> "xor"
  | Function -> "function"
  | Return -> "return"

type token = {
  token_type : token_type;
  line_no : int;
  col_no : int;
  literal : string;
}

type lexer = {
  input : bytes;
  mutable ch : int;
  mutable la : int;
  mutable pos : int;
  mutable line_no : int;
  mutable col_no : int;
}

let is_whitespace ch =
  ch = Char.code ' '
  || ch = Char.code '\t'
  || ch = Char.code '\r'
  || ch = Char.code '\n'

let is_letter ch =
  (ch >= Char.code 'a' && ch <= Char.code 'z')
  || (ch >= Char.code 'A' && ch <= Char.code 'Z')
  || ch = Char.code '_'

let is_digit ch = ch >= Char.code '0' && ch <= Char.code '9'

let create_lexer input_bytes =
  {
    input = input_bytes;
    ch = 0;
    la = 0;
    pos = 0;
    line_no = 1;
    col_no = 1;
  }

let read_char lexer =
  let len = Bytes.length lexer.input in
  if lexer.pos >= len then lexer.ch <- 0
  else begin
    lexer.ch <- Char.code (Bytes.get lexer.input lexer.pos);
    if lexer.ch = Char.code '\n' then begin
      lexer.line_no <- lexer.line_no + 1;
      lexer.col_no <- 0
    end;
    lexer.col_no <- lexer.col_no + 1;
    lexer.pos <- lexer.pos + 1
  end;
  if lexer.pos >= len then lexer.la <- 0
  else lexer.la <- Char.code (Bytes.get lexer.input lexer.pos)

let match_if lexer if_ch if_token_type else_token_type =
  if lexer.la = Char.code if_ch then begin
    read_char lexer;
    if_token_type
  end
  else else_token_type

let match_string lexer =
  read_char lexer;
  while lexer.la <> 0 && lexer.la <> Char.code '"' do
    if lexer.la = Char.code '\\' then read_char lexer;
    read_char lexer
  done;
  if lexer.la = Char.code '"' then read_char lexer;
  StringLiteral

let match_comment lexer =
  while lexer.ch <> 0 && lexer.ch <> Char.code '\n' do
    read_char lexer
  done;
  Comment

let match_whitespace lexer =
  while is_whitespace lexer.la do
    read_char lexer
  done;
  Whitespace

let match_identifier lexer =
  while is_letter lexer.la || is_digit lexer.la do
    read_char lexer
  done;
  Identifier

let keyword_or_identifier = function
  | "let" -> Let
  | "true" -> True
  | "false" -> False
  | "if" -> If
  | "else" -> Else
  | "while" -> While
  | "foreach" -> Foreach
  | "as" -> As
  | "and" -> And
  | "or" -> Or
  | "xor" -> Xor
  | "not" -> Not
  | "function" -> Function
  | "return" -> Return
  | _ -> Identifier

let read_digits lexer =
  while is_digit lexer.la || lexer.la = Char.code '_' do
    read_char lexer
  done

let match_number lexer =
  read_digits lexer;
  if lexer.la = Char.code '.' then begin
    read_char lexer;
    read_digits lexer;
    if lexer.la = Char.code 'e' || lexer.la = Char.code 'E' then begin
      read_char lexer;
      if lexer.la = Char.code '-' || lexer.la = Char.code '+' then
        read_char lexer;
      read_digits lexer
    end;
    Float
  end
  else Integer

let next_token lexer =
  let start_pos = lexer.pos in
  let start_line = lexer.line_no in
  let start_col = lexer.col_no in

  read_char lexer;

  let tok_type =
    match Char.chr (if lexer.ch >= 0 && lexer.ch <= 255 then lexer.ch else 0) with
    | '(' -> Lparen
    | ')' -> Rparen
    | '[' -> Lbracket
    | ']' -> Rbracket
    | '{' -> Lcurly
    | '}' -> Rcurly
    | ',' -> Comma
    | ';' -> Semicolon
    | ':' -> Colon
    | '^' -> Pow
    | '+' -> match_if lexer '=' AssignPlus Plus
    | '-' -> match_if lexer '=' AssignMinus Minus
    | '*' -> match_if lexer '=' AssignMultiply Multiply
    | '/' -> match_if lexer '=' AssignDivide Divide
    | '%' -> match_if lexer '=' AssignMod Mod
    | '<' -> match_if lexer '=' LessEqual LessThan
    | '>' -> match_if lexer '=' GreaterEqual GreaterThan
    | '=' -> match_if lexer '=' Equal Assign
    | '!' -> match_if lexer '=' NotEqual Illegal
    | '~' -> match_if lexer '=' AssignConcat Concat
    | '"' -> match_string lexer
    | '#' -> match_comment lexer
    | '\000' when lexer.ch = 0 -> Eof
    | _ ->
        if is_whitespace lexer.ch then match_whitespace lexer
        else if is_letter lexer.ch then match_identifier lexer
        else if is_digit lexer.ch then match_number lexer
        else Illegal
  in

  let len = lexer.pos - start_pos in
  let literal = Bytes.sub_string lexer.input start_pos len in
  let token_type =
    if tok_type = Identifier then keyword_or_identifier literal else tok_type
  in
  { token_type; line_no = start_line; col_no = start_col; literal }
