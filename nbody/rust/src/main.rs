use std::env;
use std::f64::consts::PI;

const SOLAR_MASS: f64 = 4.0 * PI * PI;
const DAYS_PER_YEAR: f64 = 365.24;

struct Body {
    x: f64,
    y: f64,
    z: f64,
    vx: f64,
    vy: f64,
    vz: f64,
    mass: f64,
}

struct NBodySystem {
    bodies: [Body; 5],
}

impl NBodySystem {
    fn new() -> NBodySystem {
        let bodies = [
            NBodySystem::init_sun(),
            NBodySystem::init_jupiter(),
            NBodySystem::init_saturn(),
            NBodySystem::init_uranus(),
            NBodySystem::init_neptune(),
        ];

        let mut system = NBodySystem { bodies };
        system.offset_momentum();

        system
    }

    fn init_sun() -> Body {
        Body {
            x: 0.0,
            y: 0.0,
            z: 0.0,
            vx: 0.0,
            vy: 0.0,
            vz: 0.0,
            mass: SOLAR_MASS,
        }
    }

    fn init_jupiter() -> Body {
        Body {
            x: 4.84143144246472090e+00,
            y: -1.16032004402742839e+00,
            z: -1.03622044471123109e-01,
            vx: 1.66007664274403694e-03 * DAYS_PER_YEAR,
            vy: 7.69901118419740425e-03 * DAYS_PER_YEAR,
            vz: -6.90460016972063023e-05 * DAYS_PER_YEAR,
            mass: 9.54791938424326609e-04 * SOLAR_MASS,
        }
    }

    fn init_saturn() -> Body {
        Body {
            x: 8.34336671824457987e+00,
            y: 4.12479856412430479e+00,
            z: -4.03523417114321381e-01,
            vx: -2.76742510726862411e-03 * DAYS_PER_YEAR,
            vy: 4.99852801234917238e-03 * DAYS_PER_YEAR,
            vz: 2.30417297573763929e-05 * DAYS_PER_YEAR,
            mass: 2.85885980666130812e-04 * SOLAR_MASS,
        }
    }

    fn init_uranus() -> Body {
        Body {
            x: 1.28943695621391310e+01,
            y: -1.51111514016986312e+01,
            z: -2.23307578892655734e-01,
            vx: 2.96460137564761618e-03 * DAYS_PER_YEAR,
            vy: 2.37847173959480950e-03 * DAYS_PER_YEAR,
            vz: -2.96589568540237556e-05 * DAYS_PER_YEAR,
            mass: 4.36624404335156298e-05 * SOLAR_MASS,
        }
    }

    fn init_neptune() -> Body {
        Body {
            x: 1.53796971148509165e+01,
            y: -2.59193146099879641e+01,
            z: 1.79258772950371181e-01,
            vx: 2.68067772490389322e-03 * DAYS_PER_YEAR,
            vy: 1.62824170038242295e-03 * DAYS_PER_YEAR,
            vz: -9.51592254519715870e-05 * DAYS_PER_YEAR,
            mass: 5.15138902046611451e-05 * SOLAR_MASS,
        }
    }

    fn offset_momentum(&mut self) {
        let mut px = 0.0;
        let mut py = 0.0;
        let mut pz = 0.0;
        for i in 0..self.bodies.len() {
            px += self.bodies[i].vx * self.bodies[i].mass;
            py += self.bodies[i].vy * self.bodies[i].mass;
            pz += self.bodies[i].vz * self.bodies[i].mass;
        }
        self.bodies[0].vx = -px / SOLAR_MASS;
        self.bodies[0].vy = -py / SOLAR_MASS;
        self.bodies[0].vz = -pz / SOLAR_MASS;
    }

    fn energy(&self) -> f64 {
        let mut e = 0.0;

        for i in 0..self.bodies.len() {
            let bi = &self.bodies[i];
            e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);

            for j in (i + 1)..self.bodies.len() {
                let bj = &self.bodies[j];
                let dx = bi.x - bj.x;
                let dy = bi.y - bj.y;
                let dz = bi.z - bj.z;
                let distance = (dx * dx + dy * dy + dz * dz).sqrt();
                e -= (bi.mass * bj.mass) / distance;
            }
        }

        e
    }

    fn advance(&mut self, dt: f64) {
        for i in 0..self.bodies.len() {
            for j in (i + 1)..self.bodies.len() {
                let dx = self.bodies[i].x - self.bodies[j].x;
                let dy = self.bodies[i].y - self.bodies[j].y;
                let dz = self.bodies[i].z - self.bodies[j].z;

                let distance = (dx * dx + dy * dy + dz * dz).sqrt();
                let mag = dt / (distance * distance * distance);

                self.bodies[i].vx -= dx * self.bodies[j].mass * mag;
                self.bodies[i].vy -= dy * self.bodies[j].mass * mag;
                self.bodies[i].vz -= dz * self.bodies[j].mass * mag;

                self.bodies[j].vx += dx * self.bodies[i].mass * mag;
                self.bodies[j].vy += dy * self.bodies[i].mass * mag;
                self.bodies[j].vz += dz * self.bodies[i].mass * mag;
            }
        }

        for i in 0..self.bodies.len() {
            self.bodies[i].x += dt * self.bodies[i].vx;
            self.bodies[i].y += dt * self.bodies[i].vy;
            self.bodies[i].z += dt * self.bodies[i].vz;
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: nbody <num_steps>");
        std::process::exit(1);
    }
    let n: i32 = args[1].parse().unwrap();

    let mut bodies = NBodySystem::new();

    println!("{:.9}", bodies.energy());
    for _ in 0..n {
        bodies.advance(0.01);
    }
    println!("{:.9}", bodies.energy());
}
