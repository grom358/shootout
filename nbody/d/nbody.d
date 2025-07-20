import std.stdio;
import std.math;
import std.conv;

enum PI = 3.141592653589793;
enum SOLAR_MASS = 4 * PI * PI;
enum DAYS_PER_YEAR = 365.24;
enum BODIES_LENGTH = 5;

struct Body {
    double x, y, z;
    double vx, vy, vz;
    double mass;
}

immutable Body sun = {0, 0, 0, 0, 0, 0, SOLAR_MASS};

immutable Body jupiter = {
    4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
    1.66007664274403694e-03 * DAYS_PER_YEAR,
    7.69901118419740425e-03 * DAYS_PER_YEAR,
    -6.90460016972063023e-05 * DAYS_PER_YEAR,
    9.54791938424326609e-04 * SOLAR_MASS
};
immutable Body saturn = {
    8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
    -2.76742510726862411e-03 * DAYS_PER_YEAR,
    4.99852801234917238e-03 * DAYS_PER_YEAR,
    2.30417297573763929e-05 * DAYS_PER_YEAR,
    2.85885980666130812e-04 * SOLAR_MASS
};
immutable Body uranus = {
    1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
    2.96460137564761618e-03 * DAYS_PER_YEAR,
    2.37847173959480950e-03 * DAYS_PER_YEAR,
    -2.96589568540237556e-05 * DAYS_PER_YEAR,
    4.36624404335156298e-05 * SOLAR_MASS
};
immutable Body neptune = {
    1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
    2.68067772490389322e-03 * DAYS_PER_YEAR,
    1.62824170038242295e-03 * DAYS_PER_YEAR,
    -9.51592254519715870e-05 * DAYS_PER_YEAR,
    5.15138902046611451e-05 * SOLAR_MASS
};

struct NBodySystem {
    Body[BODIES_LENGTH] bodies;

    static NBodySystem create() {
        NBodySystem system;
        system.bodies = [sun, jupiter, saturn, uranus, neptune];
        system.offsetMomentum();
        return system;
    }

    void offsetMomentum() {
        double px = 0, py = 0, pz = 0;
        foreach (ref body; bodies) {
            px += body.vx * body.mass;
            py += body.vy * body.mass;
            pz += body.vz * body.mass;
        }
        bodies[0].vx = -px / SOLAR_MASS;
        bodies[0].vy = -py / SOLAR_MASS;
        bodies[0].vz = -pz / SOLAR_MASS;
    }

    void advance(double dt) {
        for (int i = 0; i < BODIES_LENGTH; ++i) {
            for (int j = i + 1; j < BODIES_LENGTH; ++j) {
                double dx = bodies[i].x - bodies[j].x;
                double dy = bodies[i].y - bodies[j].y;
                double dz = bodies[i].z - bodies[j].z;

                double distance = sqrt(dx * dx + dy * dy + dz * dz);
                double mag = dt / (distance * distance * distance);

                bodies[i].vx -= dx * bodies[j].mass * mag;
                bodies[i].vy -= dy * bodies[j].mass * mag;
                bodies[i].vz -= dz * bodies[j].mass * mag;

                bodies[j].vx += dx * bodies[i].mass * mag;
                bodies[j].vy += dy * bodies[i].mass * mag;
                bodies[j].vz += dz * bodies[i].mass * mag;
            }
        }

        foreach (ref body; bodies) {
            body.x += dt * body.vx;
            body.y += dt * body.vy;
            body.z += dt * body.vz;
        }
    }

    double energy() const {
        double e = 0.0;
        for (int i = 0; i < BODIES_LENGTH; ++i) {
            const Body bi = bodies[i];
            e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);

            for (int j = i + 1; j < BODIES_LENGTH; ++j) {
                const Body bj = bodies[j];
                double dx = bi.x - bj.x;
                double dy = bi.y - bj.y;
                double dz = bi.z - bj.z;
                double distance = sqrt(dx * dx + dy * dy + dz * dz);
                e -= (bi.mass * bj.mass) / distance;
            }
        }
        return e;
    }
}

int main(string[] args) {
    if (args.length != 2) {
        stderr.writeln("Usage: nbody <num_steps>");
        return 1;
    }

    int n = args[1].to!int;
    double dt = 0.01;
    auto system = NBodySystem.create();

    writefln("%.9f", system.energy());
    for (int i = 0; i < n; ++i) {
        system.advance(dt);
    }
    writefln("%.9f", system.energy());
    return 0;
}
