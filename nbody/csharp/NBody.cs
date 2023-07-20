namespace NBody;

public class NBodySystem {
  private Body[] bodies;

  public NBodySystem() {
    bodies = new Body[] { Body.Sun(), Body.Jupiter(), Body.Saturn(),
                          Body.Uranus(), Body.Neptune() };

    double px = 0.0;
    double py = 0.0;
    double pz = 0.0;
    foreach (var body in bodies) {
      px += body.vx * body.mass;
      py += body.vy * body.mass;
      pz += body.vz * body.mass;
    }
    bodies[0].OffsetMomentum(px, py, pz);
  }

  public void Advance(double dt) {
    for (int i = 0; i < bodies.Length; ++i) {
      Body bi = bodies[i];
      for (int j = i + 1; j < bodies.Length; ++j) {
        Body bj = bodies[j];
        double dx = bi.x - bj.x;
        double dy = bi.y - bj.y;
        double dz = bi.z - bj.z;

        double dSquared = dx * dx + dy * dy + dz * dz;
        double distance = Math.Sqrt(dSquared);
        double mag = dt / (dSquared * distance);

        bi.vx -= dx * bj.mass * mag;
        bi.vy -= dy * bj.mass * mag;
        bi.vz -= dz * bj.mass * mag;

        bj.vx += dx * bi.mass * mag;
        bj.vy += dy * bi.mass * mag;
        bj.vz += dz * bi.mass * mag;
      }
    }

    foreach (var body in bodies) {
      body.x += dt * body.vx;
      body.y += dt * body.vy;
      body.z += dt * body.vz;
    }
  }

  public double Energy() {
    double e = 0.0;

    for (int i = 0; i < bodies.Length; ++i) {
      Body bi = bodies[i];
      e += 0.5 * bi.mass *
           (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);

      for (int j = i + 1; j < bodies.Length; ++j) {
        Body bj = bodies[j];
        double dx = bi.x - bj.x;
        double dy = bi.y - bj.y;
        double dz = bi.z - bj.z;

        double distance = Math.Sqrt(dx * dx + dy * dy + dz * dz);
        e -= (bi.mass * bj.mass) / distance;
      }
    }

    return e;
  }
}

public class Body {
  private static readonly double PI = 3.141592653589793;
  private static readonly double SOLAR_MASS = 4 * PI * PI;
  private static readonly double DAYS_PER_YEAR = 365.24;

  public double x, y, z, vx, vy, vz, mass;

  private Body() {}

  public static Body Jupiter() {
    Body p = new Body();
    p.x = 4.84143144246472090e+00;
    p.y = -1.16032004402742839e+00;
    p.z = -1.03622044471123109e-01;
    p.vx = 1.66007664274403694e-03 * DAYS_PER_YEAR;
    p.vy = 7.69901118419740425e-03 * DAYS_PER_YEAR;
    p.vz = -6.90460016972063023e-05 * DAYS_PER_YEAR;
    p.mass = 9.54791938424326609e-04 * SOLAR_MASS;
    return p;
  }

  public static Body Saturn() {
    Body p = new Body();
    p.x = 8.34336671824457987e+00;
    p.y = 4.12479856412430479e+00;
    p.z = -4.03523417114321381e-01;
    p.vx = -2.76742510726862411e-03 * DAYS_PER_YEAR;
    p.vy = 4.99852801234917238e-03 * DAYS_PER_YEAR;
    p.vz = 2.30417297573763929e-05 * DAYS_PER_YEAR;
    p.mass = 2.85885980666130812e-04 * SOLAR_MASS;
    return p;
  }

  public static Body Uranus() {
    Body p = new Body();
    p.x = 1.28943695621391310e+01;
    p.y = -1.51111514016986312e+01;
    p.z = -2.23307578892655734e-01;
    p.vx = 2.96460137564761618e-03 * DAYS_PER_YEAR;
    p.vy = 2.37847173959480950e-03 * DAYS_PER_YEAR;
    p.vz = -2.96589568540237556e-05 * DAYS_PER_YEAR;
    p.mass = 4.36624404335156298e-05 * SOLAR_MASS;
    return p;
  }

  public static Body Neptune() {
    Body p = new Body();
    p.x = 1.53796971148509165e+01;
    p.y = -2.59193146099879641e+01;
    p.z = 1.79258772950371181e-01;
    p.vx = 2.68067772490389322e-03 * DAYS_PER_YEAR;
    p.vy = 1.62824170038242295e-03 * DAYS_PER_YEAR;
    p.vz = -9.51592254519715870e-05 * DAYS_PER_YEAR;
    p.mass = 5.15138902046611451e-05 * SOLAR_MASS;
    return p;
  }

  public static Body Sun() {
    Body p = new Body();
    p.mass = SOLAR_MASS;
    return p;
  }

  public void OffsetMomentum(double px, double py, double pz) {
    vx = -px / SOLAR_MASS;
    vy = -py / SOLAR_MASS;
    vz = -pz / SOLAR_MASS;
  }
}
