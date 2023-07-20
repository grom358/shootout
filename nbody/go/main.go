package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
)

const PI float64 = 3.141592653589793
const SOLAR_MASS float64 = 4 * PI * PI
const DAYS_PER_YEAR float64 = 365.24

type Body struct {
	x, y, z, vx, vy, vz, mass float64
}

func (b *Body) OffsetMomentum(px, py, pz float64) {
	b.vx = -px / SOLAR_MASS
	b.vy = -py / SOLAR_MASS
	b.vz = -pz / SOLAR_MASS
}

func NewBody(x, y, z, vx, vy, vz, mass float64) *Body {
	return &Body{x, y, z, vx, vy, vz, mass}
}

func Jupiter() *Body {
	return NewBody(4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
		(1.66007664274403694e-03 * DAYS_PER_YEAR), (7.69901118419740425e-03 * DAYS_PER_YEAR),
		(-6.90460016972063023e-05 * DAYS_PER_YEAR), (9.54791938424326609e-04 * SOLAR_MASS))
}

func Saturn() *Body {
	return NewBody(8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
		(-2.76742510726862411e-03 * DAYS_PER_YEAR), (4.99852801234917238e-03 * DAYS_PER_YEAR),
		(2.30417297573763929e-05 * DAYS_PER_YEAR), (2.85885980666130812e-04 * SOLAR_MASS))
}

func Uranus() *Body {
	return NewBody(1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
		(2.96460137564761618e-03 * DAYS_PER_YEAR), (2.37847173959480950e-03 * DAYS_PER_YEAR),
		(-2.96589568540237556e-05 * DAYS_PER_YEAR), (4.36624404335156298e-05 * SOLAR_MASS))
}

func Neptune() *Body {
	return NewBody(1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
		(2.68067772490389322e-03 * DAYS_PER_YEAR), (1.62824170038242295e-03 * DAYS_PER_YEAR),
		(-9.51592254519715870e-05 * DAYS_PER_YEAR), (5.15138902046611451e-05 * SOLAR_MASS))
}

func Sun() *Body {
	return NewBody(0, 0, 0, 0, 0, 0, SOLAR_MASS)
}

type NBodySystem struct {
	bodies []*Body
}

func NewNBodySystem() *NBodySystem {
	bodies := []*Body{
		Sun(),
		Jupiter(),
		Saturn(),
		Uranus(),
		Neptune(),
	}

	px, py, pz := 0.0, 0.0, 0.0
	for _, body := range bodies {
		px += body.vx * body.mass
		py += body.vy * body.mass
		pz += body.vz * body.mass
	}

	bodies[0].OffsetMomentum(px, py, pz)

	return &NBodySystem{bodies: bodies}
}

func (system *NBodySystem) Advance(dt float64) {
	for i := 0; i < len(system.bodies); i++ {
		bi := system.bodies[i]
		for j := i + 1; j < len(system.bodies); j++ {
			bj := system.bodies[j]
			dx := bi.x - bj.x
			dy := bi.y - bj.y
			dz := bi.z - bj.z

			dSquared := (dx * dx) + (dy * dy) + (dz * dz)
			distance := math.Sqrt(dSquared)
			mag := dt / (dSquared * distance)

			bi.vx -= dx * bj.mass * mag
			bi.vy -= dy * bj.mass * mag
			bi.vz -= dz * bj.mass * mag

			bj.vx += dx * bi.mass * mag
			bj.vy += dy * bi.mass * mag
			bj.vz += dz * bi.mass * mag
		}
	}

	for _, body := range system.bodies {
		body.x += dt * body.vx
		body.y += dt * body.vy
		body.z += dt * body.vz
	}
}

func (system *NBodySystem) Energy() float64 {
	e := 0.0

	for i := 0; i < len(system.bodies); i++ {
		bi := system.bodies[i]
		e += 0.5 * bi.mass * ((bi.vx * bi.vx) + (bi.vy * bi.vy) + (bi.vz * bi.vz))

		for j := i + 1; j < len(system.bodies); j++ {
			bj := system.bodies[j]
			dx := bi.x - bj.x
			dy := bi.y - bj.y
			dz := bi.z - bj.z

			distanceSquared := (dx * dx) + (dy * dy) + (dz * dz)
			distance := math.Sqrt(distanceSquared)
			e -= (bi.mass * bj.mass) / distance
		}
	}

	return e
}

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "Usage: nbody [steps]")
		os.Exit(1)
	}

	n, err := strconv.ParseInt(os.Args[1], 10, 32)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Invalid steps argument")
		os.Exit(1)
	}
	steps := int(n)

	bodies := NewNBodySystem()
	fmt.Printf("%.9f\n", bodies.Energy())
	for i := 0; i < steps; i++ {
		bodies.Advance(0.01)
	}
	fmt.Printf("%.9f\n", bodies.Energy())
}
