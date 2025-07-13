mod lexer;

use std::env;
use std::fs::File;
use std::io::{self, BufWriter, Read, Write};

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        eprintln!("Usage: {} <input-file> <output-file>", args[0]);
        std::process::exit(1);
    }

    let input_path = &args[1];
    let output_path = &args[2];

    let mut buffer = Vec::new();
    File::open(input_path)?.read_to_end(&mut buffer)?;

    let out_file = File::create(output_path)?;
    let mut writer = BufWriter::new(out_file);

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
