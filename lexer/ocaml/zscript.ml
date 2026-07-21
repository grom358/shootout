open Printf

let escape_csv_quotes s = String.split_on_char '"' s |> String.concat "\"\""

let read_file_bytes filename =
  In_channel.with_open_bin filename (fun ic ->
      In_channel.input_all ic |> Bytes.of_string)

let () =
  if Array.length Sys.argv <> 3 then (
    eprintf "Usage: %s <input.zs> <output.csv>\n%!" Sys.argv.(0);
    exit 1);

  let input_path = Sys.argv.(1) in
  let output_path = Sys.argv.(2) in

  let buffer = read_file_bytes input_path in

  let out_chan = open_out output_path in

  let lexer = Lexer.create_lexer buffer in

  let rec loop () =
    let token = Lexer.next_token lexer in

    if token.token_type = Lexer.Eof then ()
    else begin
      let literal = ref token.literal in
      if token.token_type = Lexer.StringLiteral then begin
        let l = String.length !literal in
        if l >= 2 then literal := String.sub !literal 1 (l - 2)
      end;

      if
        token.token_type = Lexer.StringLiteral
        || token.token_type = Lexer.Comment
      then literal := escape_csv_quotes !literal;

      fprintf out_chan "%d,%d,\"%s\",\"%s\"\n" token.line_no token.col_no
        !literal
        (Lexer.string_of_token_type token.token_type);

      loop ()
    end
  in
  loop ();

  flush out_chan;
  close_out out_chan
