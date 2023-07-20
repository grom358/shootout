const std = @import("std");
const sqrt = std.math.sqrt;

const PI = 3.141592653589793;
const DAYS_PER_YEAR = 365.24;
const SOLAR_MASS = 4 * PI * PI;

const Body = struct {
    x: f64,
    y: f64,
    z: f64,
    vx: f64,
    vy: f64,
    vz: f64,
    mass: f64,
};

const Sun = Body{
    .x = 0.0,
    .y = 0.0,
    .z = 0.0,
    .vx = 0.0,
    .vy = 0.0,
    .vz = 0.0,
    .mass = SOLAR_MASS,
};

const Jupiter = Body{
    .x = 4.84143144246472090e+00,
    .y = -1.16032004402742839e+00,
    .z = -1.03622044471123109e-01,
    .vx = 1.66007664274403694e-03 * DAYS_PER_YEAR,
    .vy = 7.69901118419740425e-03 * DAYS_PER_YEAR,
    .vz = -6.90460016972063023e-05 * DAYS_PER_YEAR,
    .mass = 9.54791938424326609e-04 * SOLAR_MASS,
};

const Saturn = Body{
    .x = 8.34336671824457987e+00,
    .y = 4.12479856412430479e+00,
    .z = -4.03523417114321381e-01,
    .vx = -2.76742510726862411e-03 * DAYS_PER_YEAR,
    .vy = 4.99852801234917238e-03 * DAYS_PER_YEAR,
    .vz = 2.30417297573763929e-05 * DAYS_PER_YEAR,
    .mass = 2.85885980666130812e-04 * SOLAR_MASS,
};

const Uranus = Body{
    .x = 1.28943695621391310e+01,
    .y = -1.51111514016986312e+01,
    .z = -2.23307578892655734e-01,
    .vx = 2.96460137564761618e-03 * DAYS_PER_YEAR,
    .vy = 2.37847173959480950e-03 * DAYS_PER_YEAR,
    .vz = -2.96589568540237556e-05 * DAYS_PER_YEAR,
    .mass = 4.36624404335156298e-05 * SOLAR_MASS,
};

const Neptune = Body{
    .x = 1.53796971148509165e+01,
    .y = -2.59193146099879641e+01,
    .z = 1.79258772950371181e-01,
    .vx = 2.68067772490389322e-03 * DAYS_PER_YEAR,
    .vy = 1.62824170038242295e-03 * DAYS_PER_YEAR,
    .vz = -9.51592254519715870e-05 * DAYS_PER_YEAR,
    .mass = 5.15138902046611451e-05 * SOLAR_MASS,
};

var System = [_]Body{ Sun, Jupiter, Saturn, Uranus, Neptune };

fn offset_momemtum(system: []Body) void {
    var px: f64 = 0.0;
    var py: f64 = 0.0;
    var pz: f64 = 0.0;
    for (system[1..]) |body| {
        px += body.vx * body.mass;
        py += body.vy * body.mass;
        pz += body.vz * body.mass;
    }
    system[0].vx = -px / SOLAR_MASS;
    system[0].vy = -py / SOLAR_MASS;
    system[0].vz = -pz / SOLAR_MASS;
}

fn energy(system: []Body) f64 {
    var e: f64 = 0.0;
    for (system) |body, i| {
        e += 0.5 * body.mass * (body.vx * body.vx + body.vy * body.vy + body.vz * body.vz);
        for (system[i + 1 ..]) |bj| {
            const dx = body.x - bj.x;
            const dy = body.y - bj.y;
            const dz = body.z - bj.z;
            const distance = sqrt(dx * dx + dy * dy + dz * dz);
            e -= (body.mass * bj.mass) / distance;
        }
    }
    return e;
}

fn advance(system: []Body, dt: f64) void {
    for (system) |*bi, i| {
        for (system[i + 1 ..]) |*bj| {
            const dx = bi.x - bj.x;
            const dy = bi.y - bj.y;
            const dz = bi.z - bj.z;
            const distance = sqrt(dx * dx + dy * dy + dz * dz);
            const mag = dt / (distance * distance * distance);

            bi.vx -= dx * bj.mass * mag;
            bi.vy -= dy * bj.mass * mag;
            bi.vz -= dz * bj.mass * mag;

            bj.vx += dx * bi.mass * mag;
            bj.vy += dy * bi.mass * mag;
            bj.vz += dz * bi.mass * mag;
        }
    }

    for (system) |*body| {
        body.x += dt * body.vx;
        body.y += dt * body.vy;
        body.z += dt * body.vz;
    }
}

fn get_n() !usize {
    var arg_it = std.process.args();
    _ = arg_it.skip();
    const arg = arg_it.next() orelse return 10;
    return try std.fmt.parseInt(u32, arg, 10);
}

pub fn main() !void {
    const n = try get_n();
    const dt = 0.01;
    const stdout = std.io.getStdOut().writer();

    var sys: []Body = System[0..];
    offset_momemtum(sys);

    try stdout.print("{d:.9}\n", .{energy(sys)});
    var i: usize = 0;
    while (i < n) : (i += 1) {
        advance(sys, dt);
    }
    try stdout.print("{d:.9}\n", .{energy(sys)});
}
