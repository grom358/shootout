package com.cameronzemek.nbody;

final class NBodySystem {
  private Body[] bodies;

  public NBodySystem() {
    bodies = new Body[] {Body.sun(), Body.jupiter(), Body.saturn(),
                         Body.uranus(), Body.neptune()};

    double px = 0.0;
    double py = 0.0;
    double pz = 0.0;
    for (Body body : bodies) {
      px += body.vx * body.mass;
      py += body.vy * body.mass;
      pz += body.vz * body.mass;
    }
    bodies[0].offsetMomentum(px, py, pz);
  }

  public void advance(double dt) {
    double dx, dy, dz, distance, mag;

    for (int i = 0; i < bodies.length; ++i) {
      Body bi = bodies[i];
      for (int j = i + 1; j < bodies.length; ++j) {
        Body bj = bodies[j];
        dx = bi.x - bj.x;
        dy = bi.y - bj.y;
        dz = bi.z - bj.z;

        distance = Math.sqrt(dx * dx + dy * dy + dz * dz);
        mag = dt / (distance * distance * distance);

        bi.vx -= dx * bj.mass * mag;
        bi.vy -= dy * bj.mass * mag;
        bi.vz -= dz * bj.mass * mag;

        bj.vx += dx * bi.mass * mag;
        bj.vy += dy * bi.mass * mag;
        bj.vz += dz * bi.mass * mag;
      }
    }

    for (Body body : bodies) {
      body.x += dt * body.vx;
      body.y += dt * body.vy;
      body.z += dt * body.vz;
    }
  }

  public double energy() {
    double dx, dy, dz, distance;
    double e = 0.0;

    for (int i = 0; i < bodies.length; ++i) {
      Body bi = bodies[i];
      e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);

      for (int j = i + 1; j < bodies.length; ++j) {
        Body bj = bodies[j];
        dx = bi.x - bj.x;
        dy = bi.y - bj.y;
        dz = bi.z - bj.z;

        distance = Math.sqrt(dx * dx + dy * dy + dz * dz);
        e -= (bi.mass * bj.mass) / distance;
      }
    }
    return e;
  }
}
