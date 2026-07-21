open Printf

let () =
  if Array.length Sys.argv <> 3 then (
    eprintf "Usage: mandelbrot <size> <output.pbm>\n%!";
    exit 1);

  let size =
    try int_of_string Sys.argv.(1)
    with _ ->
      eprintf "Failed to parse size argument\n%!";
      exit 1
  in

  let output_path = Sys.argv.(2) in
  let out_chan = open_out_bin output_path in

  Fun.protect
    ~finally:(fun () ->
      flush out_chan;
      close_out out_chan)
    (fun () ->
      let limit = 2.0 in
      let max_iter = 50 in

      (* Write P4 binary PBM header *)
      fprintf out_chan "P4\n%d %d\n" size size;

      let bit_num = ref 0 in
      let byte_acc = ref 0 in

      for y = 0 to size - 1 do
        let ci = (2.0 *. float_of_int y /. float_of_int size) -. 1.0 in
        for x = 0 to size - 1 do
          let cr = (2.0 *. float_of_int x /. float_of_int size) -. 1.5 in
          let zr = ref 0.0 in
          let zi = ref 0.0 in
          let tr = ref 0.0 in
          let ti = ref 0.0 in

          let i = ref 0 in
          while !i < max_iter && !tr +. !ti <= limit *. limit do
            zi := (2.0 *. !zr *. !zi) +. ci;
            zr := !tr -. !ti +. cr;
            tr := !zr *. !zr;
            ti := !zi *. !zi;
            incr i
          done;

          byte_acc := !byte_acc lsl 1;
          if !tr +. !ti <= limit *. limit then byte_acc := !byte_acc lor 0x01;

          incr bit_num;

          if !bit_num = 8 then (
            output_char out_chan (Char.chr !byte_acc);
            byte_acc := 0;
            bit_num := 0)
          else if x = size - 1 then (
            byte_acc := !byte_acc lsl (8 - (size mod 8));
            output_char out_chan (Char.chr !byte_acc);
            byte_acc := 0;
            bit_num := 0)
        done
      done)
