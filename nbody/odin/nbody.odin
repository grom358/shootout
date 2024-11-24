package main

import "core:fmt"
import "core:strconv"
import "core:os"
import "core:math"

PI :: 3.141592653589793
SOLAR_MASS :: 4 * PI * PI
DAYS_PER_YEAR :: 365.24
BODIES_LENGTH :: 5

Body :: struct {
	x:    f64,
	y:    f64,
	z:    f64,
	vx:   f64,
	vy:   f64,
	vz:   f64,
	mass: f64,
}

Sun :: Body{
	x = 0, y = 0, z = 0, vx = 0, vy = 0, vz = 0, mass = SOLAR_MASS,
}

Jupiter :: Body{
	x = 4.84143144246472090e+00,
	y = -1.16032004402742839e+00,
	z = -1.03622044471123109e-01,
	vx = 1.66007664274403694e-03 * DAYS_PER_YEAR,
	vy = 7.69901118419740425e-03 * DAYS_PER_YEAR,
	vz = -6.90460016972063023e-05 * DAYS_PER_YEAR,
	mass = 9.54791938424326609e-04 * SOLAR_MASS,
}

Saturn :: Body{
	x = 8.34336671824457987e+00,
	y = 4.12479856412430479e+00,
	z = -4.03523417114321381e-01,
	vx = -2.76742510726862411e-03 * DAYS_PER_YEAR,
	vy = 4.99852801234917238e-03 * DAYS_PER_YEAR,
	vz = 2.30417297573763929e-05 * DAYS_PER_YEAR,
	mass = 2.85885980666130812e-04 * SOLAR_MASS,
}

Uranus :: Body{
	x = 1.28943695621391310e+01,
	y = -1.51111514016986312e+01,
	z = -2.23307578892655734e-01,
	vx = 2.96460137564761618e-03 * DAYS_PER_YEAR,
	vy = 2.37847173959480950e-03 * DAYS_PER_YEAR,
	vz = -2.96589568540237556e-05 * DAYS_PER_YEAR,
	mass = 4.36624404335156298e-05 * SOLAR_MASS,
}

Neptune :: Body{
	x = 1.53796971148509165e+01,
	y = -2.59193146099879641e+01,
	z = 1.79258772950371181e-01,
	vx = 2.68067772490389322e-03 * DAYS_PER_YEAR,
	vy = 1.62824170038242295e-03 * DAYS_PER_YEAR,
	vz = -9.51592254519715870e-05 * DAYS_PER_YEAR,
	mass = 5.15138902046611451e-05 * SOLAR_MASS,
}

NBodySystem :: struct {
	bodies: [BODIES_LENGTH]Body,
}

init_system :: proc(system: ^NBodySystem) {
	system.bodies[0] = Sun;
	system.bodies[1] = Jupiter;
	system.bodies[2] = Saturn;
	system.bodies[3] = Uranus;
	system.bodies[4] = Neptune;
	offset_momentum(system)
}

offset_momentum :: proc(system: ^NBodySystem) {
	n := len(system.bodies)
	px: f64 = 0.0
	py: f64 = 0.0
	pz: f64 = 0.0
	for i := 0; i < n; i += 1 {
		px += system.bodies[i].vx * system.bodies[i].mass
		py += system.bodies[i].vy * system.bodies[i].mass
		pz += system.bodies[i].vz * system.bodies[i].mass
	}
	system.bodies[0].vx = -px / SOLAR_MASS
	system.bodies[0].vy = -py / SOLAR_MASS
	system.bodies[0].vz = -pz / SOLAR_MASS
}

energy :: proc(system: ^NBodySystem) -> f64 {
	n := len(system.bodies)
	e: f64 = 0.0

	for i := 0; i < n; i += 1 {
		e +=
			0.5 *
			system.bodies[i].mass *
			(system.bodies[i].vx * system.bodies[i].vx +
					system.bodies[i].vy * system.bodies[i].vy +
					system.bodies[i].vz * system.bodies[i].vz)

		for j := i + 1; j < n; j += 1 {
			dx := system.bodies[i].x - system.bodies[j].x
			dy := system.bodies[i].y - system.bodies[j].y
			dz := system.bodies[i].z - system.bodies[j].z

			distance := math.sqrt(dx * dx + dy * dy + dz * dz)
			e -= (system.bodies[i].mass * system.bodies[j].mass) / distance
		}
	}

	return e
}

advance :: proc(system: ^NBodySystem, dt: f64) {
	n := len(system.bodies)
	for i := 0; i < n; i += 1 {
		for j := i + 1; j < n; j += 1 {
			dx := system.bodies[i].x - system.bodies[j].x
			dy := system.bodies[i].y - system.bodies[j].y
			dz := system.bodies[i].z - system.bodies[j].z

			distance := math.sqrt(dx * dx + dy * dy + dz * dz)
			mag := dt / (distance * distance * distance)

			system.bodies[i].vx -= dx * system.bodies[j].mass * mag
			system.bodies[i].vy -= dy * system.bodies[j].mass * mag
			system.bodies[i].vz -= dz * system.bodies[j].mass * mag

			system.bodies[j].vx += dx * system.bodies[i].mass * mag
			system.bodies[j].vy += dy * system.bodies[i].mass * mag
			system.bodies[j].vz += dz * system.bodies[i].mass * mag
		}
	}

	for i := 0; i < n; i += 1 {
		system.bodies[i].x += dt * system.bodies[i].vx
		system.bodies[i].y += dt * system.bodies[i].vy
		system.bodies[i].z += dt * system.bodies[i].vz
	}
}

main :: proc() {
	if len(os.args) != 2 {
		fmt.fprintf(os.stderr, "Usage: nbody [steps]\n")
		os.exit(1)
	}
	n, ok := strconv.parse_int(os.args[1])
	if !ok || n < 0 {
		fmt.fprintf(os.stderr, "Invalid steps!\n")
		os.exit(1)
	}
	dt :: 0.01

	system: NBodySystem
	init_system(&system)

	fmt.printf("%.9f\n", energy(&system))
	for i := 0; i < n; i += 1 {
		advance(&system, dt)
	}
	fmt.printf("%.9f\n", energy(&system))
}
