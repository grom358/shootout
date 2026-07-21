open Printf

let count_nucleotides data k =
  let module Kmer = struct
    type t = int
    let equal i j =
      let rec loop n =
        if n = k then true
        else if String.unsafe_get data (i + n) <> String.unsafe_get data (j + n) then false
        else loop (n + 1)
      in
      loop 0

    let hash i =
      let h = ref 0 in
      for n = 0 to k - 1 do
        h := (!h * 31) + Char.code (String.unsafe_get data (i + n))
      done;
      !h
  end in

  let module H = Hashtbl.Make(Kmer) in
  let counts = H.create 1024 in
  let end_index = String.length data - k in

  for i = 0 to end_index do
    try
      let c = H.find counts i in
      c := !c + 1
    with Not_found ->
      H.add counts i (ref 1)
  done;

  let result = Hashtbl.create (H.length counts) in
  H.iter (fun i c -> Hashtbl.add result (String.sub data i k) !c) counts;
  result

let print_frequencies out_chan data k =
  let counts = count_nucleotides data k in
  let total = Hashtbl.fold (fun _ v acc -> acc + v) counts 0 in

  let sorted_entries =
    Hashtbl.fold (fun k v acc -> (k, v) :: acc) counts []
    |> List.sort (fun (_, count1) (_, count2) -> compare count2 count1)
  in

  List.iter
    (fun (key, value) ->
      let frequency = float_of_int value /. float_of_int total *. 100.0 in
      fprintf out_chan "%s %.3f\n" (String.uppercase_ascii key) frequency)
    sorted_entries;
  fprintf out_chan "\n"

let print_sample_count out_chan data sample =
  let k = String.length sample in
  let counts = count_nucleotides data k in
  let sample_lower = String.lowercase_ascii sample in
  let count =
    match Hashtbl.find_opt counts sample_lower with Some c -> c | None -> 0
  in
  fprintf out_chan "%d\t%s\n" count sample

let read_sequence_three in_chan =
  let rec find_three () =
    match input_line in_chan with
    | line ->
        if String.starts_with ~prefix:">THREE" line then () else find_three ()
    | exception End_of_file -> ()
  in
  find_three ();

  let buf = Buffer.create 4096 in
  let rec read_data () =
    match input_line in_chan with
    | line ->
        Buffer.add_string buf line;
        read_data ()
    | exception End_of_file -> Buffer.contents buf
  in
  read_data ()

let () =
  if Array.length Sys.argv <> 3 then (
    eprintf "Usage: %s <input.txt> <output.txt>\n" Sys.argv.(0);
    exit 1);

  let input_path = Sys.argv.(1) in
  let output_path = Sys.argv.(2) in

  let in_chan = open_in input_path in
  let out_chan = open_out output_path in

  let data = read_sequence_three in_chan in

  print_frequencies out_chan data 1;
  print_frequencies out_chan data 2;
  print_sample_count out_chan data "GGT";
  print_sample_count out_chan data "GGTA";
  print_sample_count out_chan data "GGTATT";
  print_sample_count out_chan data "GGTATTTTAATT";
  print_sample_count out_chan data "GGTATTTTAATTTATAGT";

  close_in in_chan;
  close_out out_chan
