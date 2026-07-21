let is_palindrome number =
  let reversed_number = ref 0 in
  let n = ref number in
  while !n <> 0 do
    let digit = !n mod 10 in
    reversed_number := (!reversed_number * 10) + digit;
    n := !n / 10
  done;
  number = !reversed_number

let calculate_chunk_sum start_val end_val =
  let local_sum = ref 0 in
  for x = start_val to end_val do
    if is_palindrome x then local_sum := !local_sum + x
  done;
  !local_sum

let () =
  let start_val = 100_000_000 in
  let end_val = 999_999_999 in
  let range = end_val - start_val in

  let cores = 4 in
  let chunk = range / cores in

  let domain_handles =
    Array.init cores (fun i ->
        let domain_start = start_val + (chunk * i) in
        let domain_end =
          if i = cores - 1 then end_val else domain_start + chunk - 1
        in
        Domain.spawn (fun () -> calculate_chunk_sum domain_start domain_end))
  in

  let partial_sums = Array.map Domain.join domain_handles in

  let total_sum = Array.fold_left ( + ) 0 partial_sums in

  Printf.printf "%d\n" total_sum
