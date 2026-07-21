open Printf

let width = 60

module Random = struct
  let im = 139_968
  let ia = 3_877
  let ic = 29_573

  type t = { mutable seed : int }

  let create () = { seed = 42 }

  let next t =
    t.seed <- ((t.seed * ia) + ic) mod im;
    float_of_int t.seed /. float_of_int im
end

type amino_acid = { mutable p : float; c : char }

let repeat_fasta out_chan header s count =
  fprintf out_chan "%s\n" header;
  let s_len = String.length s in
  let ss = s ^ s in
  let pos = ref 0 in
  let count_remaining = ref count in
  while !count_remaining > 0 do
    let len = min width !count_remaining in
    let output = String.sub ss !pos len in
    fprintf out_chan "%s\n" output;
    pos := !pos + len;
    if !pos > s_len then pos := !pos - s_len;
    count_remaining := !count_remaining - len
  done

let accumulate_probabilities genelist =
  let cp = ref 0.0 in
  List.iter
    (fun amino ->
      cp := !cp +. amino.p;
      amino.p <- !cp)
    genelist

let random_fasta out_chan header genelist count rng =
  fprintf out_chan "%s\n" header;
  accumulate_probabilities genelist;

  let count_remaining = ref count in
  let buf = Bytes.create width in

  while !count_remaining > 0 do
    let len = min width !count_remaining in
    for i = 0 to len - 1 do
      let r = Random.next rng in
      let rec select = function
        | [] -> ' '
        | amino :: rest -> if amino.p >= r then amino.c else select rest
      in
      Bytes.set buf i (select genelist)
    done;
    fprintf out_chan "%s\n" (Bytes.sub_string buf 0 len);
    count_remaining := !count_remaining - len
  done

let alu =
  "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

let make_iub () =
  [
    { p = 0.27; c = 'a' };
    { p = 0.12; c = 'c' };
    { p = 0.12; c = 'g' };
    { p = 0.27; c = 't' };
    { p = 0.02; c = 'B' };
    { p = 0.02; c = 'D' };
    { p = 0.02; c = 'H' };
    { p = 0.02; c = 'K' };
    { p = 0.02; c = 'M' };
    { p = 0.02; c = 'N' };
    { p = 0.02; c = 'R' };
    { p = 0.02; c = 'S' };
    { p = 0.02; c = 'V' };
    { p = 0.02; c = 'W' };
    { p = 0.02; c = 'Y' };
  ]

let make_homosapiens () =
  [
    { p = 0.3029549426680; c = 'a' };
    { p = 0.1979883004921; c = 'c' };
    { p = 0.1975473066391; c = 'g' };
    { p = 0.3015094502008; c = 't' };
  ]

let () =
  if Array.length Sys.argv <> 3 then (
    eprintf "Usage: fasta <size> <output.txt>\n";
    exit 1);

  let n = int_of_string Sys.argv.(1) in
  let output_path = Sys.argv.(2) in
  let out_chan = open_out output_path in

  repeat_fasta out_chan ">ONE Homo sapiens alu" alu (2 * n);

  let rng = Random.create () in
  let iub = make_iub () in
  random_fasta out_chan ">TWO IUB ambiguity codes" iub (3 * n) rng;

  let homosapiens = make_homosapiens () in
  random_fasta out_chan ">THREE Homo sapiens frequency" homosapiens (5 * n) rng;

  close_out out_chan
