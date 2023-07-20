#include <cmath>
#include <cstdlib>
#include <iostream>

#define PI 3.141592653589793
#define SOLAR_MASS (4 * PI * PI)
#define DAYS_PER_YEAR 365.24
#define BODIES_LENGTH 5

class Body {
public:
  double x, y, z, vx, vy, vz, mass;

  Body() : x(0), y(0), z(0), vx(0), vy(0), vz(0), mass(0) {}
};

void init_jupiter(Body &body) {
  body.x = 4.84143144246472090e+00;
  body.y = -1.16032004402742839e+00;
  body.z = -1.03622044471123109e-01;
  body.vx = 1.66007664274403694e-03 * DAYS_PER_YEAR;
  body.vy = 7.69901118419740425e-03 * DAYS_PER_YEAR;
  body.vz = -6.90460016972063023e-05 * DAYS_PER_YEAR;
  body.mass = 9.54791938424326609e-04 * SOLAR_MASS;
}

void init_saturn(Body &body) {
  body.x = 8.34336671824457987e+00;
  body.y = 4.12479856412430479e+00;
  body.z = -4.03523417114321381e-01;
  body.vx = -2.76742510726862411e-03 * DAYS_PER_YEAR;
  body.vy = 4.99852801234917238e-03 * DAYS_PER_YEAR;
  body.vz = 2.30417297573763929e-05 * DAYS_PER_YEAR;
  body.mass = 2.85885980666130812e-04 * SOLAR_MASS;
}

void init_uranus(Body &body) {
  body.x = 1.28943695621391310e+01;
  body.y = -1.51111514016986312e+01;
  body.z = -2.23307578892655734e-01;
  body.vx = 2.96460137564761618e-03 * DAYS_PER_YEAR;
  body.vy = 2.37847173959480950e-03 * DAYS_PER_YEAR;
  body.vz = -2.96589568540237556e-05 * DAYS_PER_YEAR;
  body.mass = 4.36624404335156298e-05 * SOLAR_MASS;
}

void init_neptune(Body &body) {
  body.x = 1.53796971148509165e+01;
  body.y = -2.59193146099879641e+01;
  body.z = 1.79258772950371181e-01;
  body.vx = 2.68067772490389322e-03 * DAYS_PER_YEAR;
  body.vy = 1.62824170038242295e-03 * DAYS_PER_YEAR;
  body.vz = -9.51592254519715870e-05 * DAYS_PER_YEAR;
  body.mass = 5.15138902046611451e-05 * SOLAR_MASS;
}

class NBodySystem {
private:
  Body bodies[BODIES_LENGTH];

public:
  NBodySystem() {
    init_bodies();
    offset_momentum();
  }

  void init_bodies() {
    bodies[0].mass = SOLAR_MASS; // Sun.
    init_jupiter(bodies[1]);
    init_saturn(bodies[2]);
    init_uranus(bodies[3]);
    init_neptune(bodies[4]);
  }

  void offset_momentum() {
    double px, py, pz;
    px = py = pz = 0.0;
    for (int i = 0; i < BODIES_LENGTH; ++i) {
      px += bodies[i].vx * bodies[i].mass;
      py += bodies[i].vy * bodies[i].mass;
      pz += bodies[i].vz * bodies[i].mass;
    }
    bodies[0].vx = -px / SOLAR_MASS;
    bodies[0].vy = -py / SOLAR_MASS;
    bodies[0].vz = -pz / SOLAR_MASS;
  }

  void advance(double dt) {
    int i, j;
    double dx, dy, dz, distance, mag;

    for (i = 0; i < BODIES_LENGTH; ++i) {
      for (j = i + 1; j < BODIES_LENGTH; ++j) {
        dx = bodies[i].x - bodies[j].x;
        dy = bodies[i].y - bodies[j].y;
        dz = bodies[i].z - bodies[j].z;

        distance = sqrt(dx * dx + dy * dy + dz * dz);
        mag = dt / (distance * distance * distance);

        bodies[i].vx -= dx * bodies[j].mass * mag;
        bodies[i].vy -= dy * bodies[j].mass * mag;
        bodies[i].vz -= dz * bodies[j].mass * mag;

        bodies[j].vx += dx * bodies[i].mass * mag;
        bodies[j].vy += dy * bodies[i].mass * mag;
        bodies[j].vz += dz * bodies[i].mass * mag;
      }
    }

    for (i = 0; i < BODIES_LENGTH; ++i) {
      bodies[i].x += dt * bodies[i].vx;
      bodies[i].y += dt * bodies[i].vy;
      bodies[i].z += dt * bodies[i].vz;
    }
  }

  double energy() {
    double dx, dy, dz, distance, e = 0.0;

    for (int i = 0; i < BODIES_LENGTH; ++i) {
      e += 0.5 * bodies[i].mass *
           (bodies[i].vx * bodies[i].vx + bodies[i].vy * bodies[i].vy +
            bodies[i].vz * bodies[i].vz);

      for (int j = i + 1; j < BODIES_LENGTH; ++j) {
        dx = bodies[i].x - bodies[j].x;
        dy = bodies[i].y - bodies[j].y;
        dz = bodies[i].z - bodies[j].z;

        distance = sqrt(dx * dx + dy * dy + dz * dz);
        e -= (bodies[i].mass * bodies[j].mass) / distance;
      }
    }

    return e;
  }
};

int main(int argc, char *argv[]) {
  if (argc < 2) {
    std::cerr << "Usage: " << argv[0] << " <num_steps>" << std::endl;
    return 1;
  }

  int n = atoi(argv[1]);
  double dt = 0.01;

  NBodySystem bodies;

  std::cout << std::fixed;
  std::cout.precision(9);
  std::cout << bodies.energy() << std::endl;

  for (int i = 0; i < n; ++i) {
    bodies.advance(dt);
  }

  std::cout << bodies.energy() << std::endl;

  return 0;
}
