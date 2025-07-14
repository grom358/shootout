#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define PI 3.141592653589793
#define SOLAR_MASS (4 * PI * PI)
#define DAYS_PER_YEAR 365.24
#define BODIES_LENGTH 5

typedef struct {
  double x, y, z, vx, vy, vz, mass;
} Body;

typedef struct {
  Body bodies[BODIES_LENGTH];
} NBodySystem;

void init_sun(Body *body) {
  *body = (Body){
      .x = 0, .y = 0, .z = 0, .vx = 0, .vy = 0, .vz = 0, .mass = SOLAR_MASS};
}

void init_jupiter(Body *body) {
  *body = (Body){.x = 4.84143144246472090e+00,
                 .y = -1.16032004402742839e+00,
                 .z = -1.03622044471123109e-01,
                 .vx = 1.66007664274403694e-03 * DAYS_PER_YEAR,
                 .vy = 7.69901118419740425e-03 * DAYS_PER_YEAR,
                 .vz = -6.90460016972063023e-05 * DAYS_PER_YEAR,
                 .mass = 9.54791938424326609e-04 * SOLAR_MASS};
}

void init_saturn(Body *body) {
  *body = (Body){.x = 8.34336671824457987e+00,
                 .y = 4.12479856412430479e+00,
                 .z = -4.03523417114321381e-01,
                 .vx = -2.76742510726862411e-03 * DAYS_PER_YEAR,
                 .vy = 4.99852801234917238e-03 * DAYS_PER_YEAR,
                 .vz = 2.30417297573763929e-05 * DAYS_PER_YEAR,
                 .mass = 2.85885980666130812e-04 * SOLAR_MASS};
}

void init_uranus(Body *body) {
  *body = (Body){.x = 1.28943695621391310e+01,
                 .y = -1.51111514016986312e+01,
                 .z = -2.23307578892655734e-01,
                 .vx = 2.96460137564761618e-03 * DAYS_PER_YEAR,
                 .vy = 2.37847173959480950e-03 * DAYS_PER_YEAR,
                 .vz = -2.96589568540237556e-05 * DAYS_PER_YEAR,
                 .mass = 4.36624404335156298e-05 * SOLAR_MASS};
}

void init_neptune(Body *body) {
  *body = (Body){.x = 1.53796971148509165e+01,
                 .y = -2.59193146099879641e+01,
                 .z = 1.79258772950371181e-01,
                 .vx = 2.68067772490389322e-03 * DAYS_PER_YEAR,
                 .vy = 1.62824170038242295e-03 * DAYS_PER_YEAR,
                 .vz = -9.51592254519715870e-05 * DAYS_PER_YEAR,
                 .mass = 5.15138902046611451e-05 * SOLAR_MASS};
}

void offset_momentum(Body *bodies) {
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

void init_system(NBodySystem *system) {
  init_sun(&system->bodies[0]);
  init_jupiter(&system->bodies[1]);
  init_saturn(&system->bodies[2]);
  init_uranus(&system->bodies[3]);
  init_neptune(&system->bodies[4]);

  offset_momentum(system->bodies);
}

void advance(NBodySystem *system, double dt) {
  int i, j;
  double dx, dy, dz, distance, mag;

  for (i = 0; i < BODIES_LENGTH; ++i) {
    for (j = i + 1; j < BODIES_LENGTH; ++j) {
      dx = system->bodies[i].x - system->bodies[j].x;
      dy = system->bodies[i].y - system->bodies[j].y;
      dz = system->bodies[i].z - system->bodies[j].z;

      distance = sqrt(dx * dx + dy * dy + dz * dz);
      mag = dt / (distance * distance * distance);

      system->bodies[i].vx -= dx * system->bodies[j].mass * mag;
      system->bodies[i].vy -= dy * system->bodies[j].mass * mag;
      system->bodies[i].vz -= dz * system->bodies[j].mass * mag;

      system->bodies[j].vx += dx * system->bodies[i].mass * mag;
      system->bodies[j].vy += dy * system->bodies[i].mass * mag;
      system->bodies[j].vz += dz * system->bodies[i].mass * mag;
    }
  }

  for (i = 0; i < BODIES_LENGTH; ++i) {
    system->bodies[i].x += dt * system->bodies[i].vx;
    system->bodies[i].y += dt * system->bodies[i].vy;
    system->bodies[i].z += dt * system->bodies[i].vz;
  }
}

double energy(NBodySystem *system) {
  double dx, dy, dz, distance, e = 0.0;

  for (int i = 0; i < BODIES_LENGTH; ++i) {
    e += 0.5 * system->bodies[i].mass *
         (system->bodies[i].vx * system->bodies[i].vx +
          system->bodies[i].vy * system->bodies[i].vy +
          system->bodies[i].vz * system->bodies[i].vz);

    for (int j = i + 1; j < BODIES_LENGTH; ++j) {
      dx = system->bodies[i].x - system->bodies[j].x;
      dy = system->bodies[i].y - system->bodies[j].y;
      dz = system->bodies[i].z - system->bodies[j].z;

      distance = sqrt(dx * dx + dy * dy + dz * dz);
      e -= (system->bodies[i].mass * system->bodies[j].mass) / distance;
    }
  }

  return e;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: nbody <num_steps>\n");
    return 1;
  }

  double dt = 0.01;
  NBodySystem system;

  int n = atoi(argv[1]);

  init_system(&system);

  printf("%.9f\n", energy(&system));
  for (int i = 0; i < n; ++i) {
    advance(&system, dt);
  }
  printf("%.9f\n", energy(&system));

  return 0;
}
