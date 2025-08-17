import math, os, strutils, strformat

const
  PI = 3.141592653589793
  SOLAR_MASS = 4 * PI * PI
  DAYS_PER_YEAR = 365.24

type
  Body = object
    x, y, z: float64
    vx, vy, vz: float64
    mass: float64

proc offsetMomentum(b: var Body, px, py, pz: float64) =
  b.vx = -px / SOLAR_MASS
  b.vy = -py / SOLAR_MASS
  b.vz = -pz / SOLAR_MASS

proc newBody(x, y, z, vx, vy, vz, mass: float64): Body =
  Body(x: x, y: y, z: z, vx: vx, vy: vy, vz: vz, mass: mass)

proc Jupiter(): Body =
  newBody(
    4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
    1.66007664274403694e-03 * DAYS_PER_YEAR,
    7.69901118419740425e-03 * DAYS_PER_YEAR,
    -6.90460016972063023e-05 * DAYS_PER_YEAR,
    9.54791938424326609e-04 * SOLAR_MASS
  )

proc Saturn(): Body =
  newBody(
    8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
    -2.76742510726862411e-03 * DAYS_PER_YEAR,
    4.99852801234917238e-03 * DAYS_PER_YEAR,
    2.30417297573763929e-05 * DAYS_PER_YEAR,
    2.85885980666130812e-04 * SOLAR_MASS
  )

proc Uranus(): Body =
  newBody(
    1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
    2.96460137564761618e-03 * DAYS_PER_YEAR,
    2.37847173959480950e-03 * DAYS_PER_YEAR,
    -2.96589568540237556e-05 * DAYS_PER_YEAR,
    4.36624404335156298e-05 * SOLAR_MASS
  )

proc Neptune(): Body =
  newBody(
    1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
    2.68067772490389322e-03 * DAYS_PER_YEAR,
    1.62824170038242295e-03 * DAYS_PER_YEAR,
    -9.51592254519715870e-05 * DAYS_PER_YEAR,
    5.15138902046611451e-05 * SOLAR_MASS
  )

proc Sun(): Body =
  newBody(0, 0, 0, 0, 0, 0, SOLAR_MASS)

type
  NBodySystem = object
    bodies: seq[Body]

proc newNBodySystem(): NBodySystem =
  var bs = @[Sun(), Jupiter(), Saturn(), Uranus(), Neptune()]
  var px, py, pz: float64
  for b in bs:
    px += b.vx * b.mass
    py += b.vy * b.mass
    pz += b.vz * b.mass
  offsetMomentum(bs[0], px, py, pz)
  result = NBodySystem(bodies: bs)

proc advance(system: var NBodySystem, dt: float64) =
  for i in 0..<system.bodies.len:
    let bi = system.bodies[i]
    for j in i+1..<system.bodies.len:
      let bj = system.bodies[j]
      let dx = bi.x - bj.x
      let dy = bi.y - bj.y
      let dz = bi.z - bj.z
      let dSquared = dx*dx + dy*dy + dz*dz
      let distance = sqrt(dSquared)
      let mag = dt / (dSquared * distance)
      system.bodies[i].vx -= dx * bj.mass * mag
      system.bodies[i].vy -= dy * bj.mass * mag
      system.bodies[i].vz -= dz * bj.mass * mag
      system.bodies[j].vx += dx * bi.mass * mag
      system.bodies[j].vy += dy * bi.mass * mag
      system.bodies[j].vz += dz * bi.mass * mag

  for i in 0..<system.bodies.len:
    system.bodies[i].x += dt * system.bodies[i].vx
    system.bodies[i].y += dt * system.bodies[i].vy
    system.bodies[i].z += dt * system.bodies[i].vz

proc energy(system: NBodySystem): float64 =
  var e = 0.0
  for i in 0..<system.bodies.len:
    let bi = system.bodies[i]
    e += 0.5 * bi.mass * (bi.vx*bi.vx + bi.vy*bi.vy + bi.vz*bi.vz)
    for j in i+1..<system.bodies.len:
      let bj = system.bodies[j]
      let dx = bi.x - bj.x
      let dy = bi.y - bj.y
      let dz = bi.z - bj.z
      let dist = sqrt(dx*dx + dy*dy + dz*dz)
      e -= (bi.mass * bj.mass) / dist
  return e

when isMainModule:
  if paramCount() != 1:
    echo "Usage: nbody <num_steps>"
    quit(1)

  let steps = parseInt(paramStr(1))
  var system = newNBodySystem()
  echo fmt"{energy(system):.9f}"
  for _ in 0..<steps:
    advance(system, 0.01)
  echo fmt"{energy(system):.9f}"

