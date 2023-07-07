mod lexer;

use std::io::{self, BufWriter, Read, Write};

fn main() -> io::Result<()> {
    let mut buffer = Vec::new();
    let stdin = io::stdin();
    stdin.lock().read_to_end(&mut buffer)?;
    let stdout = io::stdout().lock();
    let mut writer = BufWriter::new(stdout);
    let mut lexer = lexer::Lexer::new(buffer);
    loop {
        let token = lexer.next_token();
        if token.token_type == lexer::TokenType::Eof {
            break;
        }
        let mut literal = token.literal;
        let len = literal.len();
        if token.token_type == lexer::TokenType::StringLiteral {
            literal = literal[1..len - 1].to_string();
        }
        if token.token_type == lexer::TokenType::StringLiteral
            || token.token_type == lexer::TokenType::Comment
        {
            literal = literal.replace("\"", "\"\"");
        }
        write!(
            writer,
            "{},{},\"{}\",\"{}\"\n",
            token.line_no, token.col_no, literal, token.token_type
        )?;
    }
    writer.flush()?;
    Ok(())
}
