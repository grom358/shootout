type binary_tree = Empty | Node of binary_tree * binary_tree

let rec count_nodes = function
  | Node (left, right) -> 1 + count_nodes left + count_nodes right
  | Empty -> 0

let rec create_bottom_up depth =
  if depth >= 0 then
    Node (create_bottom_up (depth - 1), create_bottom_up (depth - 1))
  else Empty

let () =
  if Array.length Sys.argv <> 2 then (
    Printf.eprintf "Usage: binarytree <depth>\n";
    exit 1);

  let n = int_of_string Sys.argv.(1) in
  let min_depth = 4 in
  let max_depth = max (min_depth + 2) n in

  let stretch_depth = max_depth + 1 in
  let stretch_tree = create_bottom_up stretch_depth in
  Printf.printf "stretch tree of depth %d\t check: %d\n" stretch_depth
    (count_nodes stretch_tree);

  let long_lived_tree = create_bottom_up max_depth in

  let rec loop_depth depth =
    if depth <= max_depth then (
      let iterations = 1 lsl (max_depth - depth + min_depth) in
      let check = ref 0 in
      for _ = 1 to iterations do
        let temp_tree = create_bottom_up depth in
        check := !check + count_nodes temp_tree
      done;
      Printf.printf "%d\t trees of depth %d\t check: %d\n" iterations depth
        !check;
      loop_depth (depth + 2))
  in
  loop_depth min_depth;

  Printf.printf "long lived tree of depth %d\t check: %d\n" max_depth
    (count_nodes long_lived_tree)
