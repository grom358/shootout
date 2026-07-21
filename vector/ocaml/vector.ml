type random = { im : int; imf : float; ia : int; ic : int; mutable seed : int }

let create_random () =
  { im = 139968; imf = 139968.0; ia = 3877; ic = 29573; seed = 42 }

let next rand max_val =
  rand.seed <- ((rand.seed * rand.ia) + rand.ic) mod rand.im;
  let max_f = float_of_int max_val in
  let seed_f = float_of_int rand.seed in
  int_of_float (max_f *. (seed_f /. rand.imf))

let () =
  let rand = create_random () in
  let max_val = 100 in
  let size = 200_000_000 in

  let numbers = Dynarray.create () in
  for _ = 1 to size do
    Dynarray.add_last numbers (next rand max_val)
  done;

  let sum = ref 0 in
  for _ = 1 to 1000 do
    let idx = next rand size in
    sum := !sum + Dynarray.get numbers idx
  done;

  Printf.printf "%d\n" !sum
