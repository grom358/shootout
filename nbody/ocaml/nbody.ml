let pi = Float.pi
let solar_mass = 4.0 *. pi *. pi
let days_per_year = 365.24

type body = {
  mutable x : float;
  mutable y : float;
  mutable z : float;
  mutable vx : float;
  mutable vy : float;
  mutable vz : float;
  mass : float;
}

let sun () =
  { x = 0.0; y = 0.0; z = 0.0; vx = 0.0; vy = 0.0; vz = 0.0; mass = solar_mass }

let jupiter () =
  {
    x = 4.84143144246472090e+00;
    y = -1.16032004402742839e+00;
    z = -1.03622044471123109e-01;
    vx = 1.66007664274403694e-03 *. days_per_year;
    vy = 7.69901118419740425e-03 *. days_per_year;
    vz = -6.90460016972063023e-05 *. days_per_year;
    mass = 9.54791938424326609e-04 *. solar_mass;
  }

let saturn () =
  {
    x = 8.34336671824457987e+00;
    y = 4.12479856412430479e+00;
    z = -4.03523417114321381e-01;
    vx = -2.76742510726862411e-03 *. days_per_year;
    vy = 4.99852801234917238e-03 *. days_per_year;
    vz = 2.30417297573763929e-05 *. days_per_year;
    mass = 2.85885980666130812e-04 *. solar_mass;
  }

let uranus () =
  {
    x = 1.28943695621391310e+01;
    y = -1.51111514016986312e+01;
    z = -2.23307578892655734e-01;
    vx = 2.96460137564761618e-03 *. days_per_year;
    vy = 2.37847173959480950e-03 *. days_per_year;
    vz = -2.96589568540237556e-05 *. days_per_year;
    mass = 4.36624404335156298e-05 *. solar_mass;
  }

let neptune () =
  {
    x = 1.53796971148509165e+01;
    y = -2.59193146099879641e+01;
    z = 1.79258772950371181e-01;
    vx = 2.68067772490389322e-03 *. days_per_year;
    vy = 1.62824170038242295e-03 *. days_per_year;
    vz = -9.51592254519715870e-05 *. days_per_year;
    mass = 5.15138902046611451e-05 *. solar_mass;
  }

let offset_momentum bodies =
  let px = ref 0.0 in
  let py = ref 0.0 in
  let pz = ref 0.0 in
  for i = 0 to Array.length bodies - 1 do
    px := !px +. (bodies.(i).vx *. bodies.(i).mass);
    py := !py +. (bodies.(i).vy *. bodies.(i).mass);
    pz := !pz +. (bodies.(i).vz *. bodies.(i).mass)
  done;
  bodies.(0).vx <- -. !px /. solar_mass;
  bodies.(0).vy <- -. !py /. solar_mass;
  bodies.(0).vz <- -. !pz /. solar_mass

let create_system () =
  let bodies = [| sun (); jupiter (); saturn (); uranus (); neptune () |] in
  offset_momentum bodies;
  bodies

let energy bodies =
  let e = ref 0.0 in
  let len = Array.length bodies in
  for i = 0 to len - 1 do
    let bi = bodies.(i) in
    e :=
      !e
      +. 0.5 *. bi.mass
         *. ((bi.vx *. bi.vx) +. (bi.vy *. bi.vy) +. (bi.vz *. bi.vz));
    for j = i + 1 to len - 1 do
      let bj = bodies.(j) in
      let dx = bi.x -. bj.x in
      let dy = bi.y -. bj.y in
      let dz = bi.z -. bj.z in
      let distance = sqrt ((dx *. dx) +. (dy *. dy) +. (dz *. dz)) in
      e := !e -. (bi.mass *. bj.mass /. distance)
    done
  done;
  !e

let advance bodies dt =
  let len = Array.length bodies in
  for i = 0 to len - 1 do
    for j = i + 1 to len - 1 do
      let bi = bodies.(i) in
      let bj = bodies.(j) in
      let dx = bi.x -. bj.x in
      let dy = bi.y -. bj.y in
      let dz = bi.z -. bj.z in
      let distance = sqrt ((dx *. dx) +. (dy *. dy) +. (dz *. dz)) in
      let mag = dt /. (distance *. distance *. distance) in

      bi.vx <- bi.vx -. (dx *. bj.mass *. mag);
      bi.vy <- bi.vy -. (dy *. bj.mass *. mag);
      bi.vz <- bi.vz -. (dz *. bj.mass *. mag);

      bj.vx <- bj.vx +. (dx *. bi.mass *. mag);
      bj.vy <- bj.vy +. (dy *. bi.mass *. mag);
      bj.vz <- bj.vz +. (dz *. bi.mass *. mag)
    done
  done;

  for i = 0 to len - 1 do
    let bi = bodies.(i) in
    bi.x <- bi.x +. (dt *. bi.vx);
    bi.y <- bi.y +. (dt *. bi.vy);
    bi.z <- bi.z +. (dt *. bi.vz)
  done

let () =
  if Array.length Sys.argv <> 2 then (
    Printf.eprintf "Usage: nbody <num_steps>\n";
    exit 1);

  let n = int_of_string Sys.argv.(1) in
  let bodies = create_system () in

  Printf.printf "%.9f\n" (energy bodies);
  for _ = 1 to n do
    advance bodies 0.01
  done;
  Printf.printf "%.9f\n" (energy bodies)
