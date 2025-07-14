const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3) {
        std.debug.print("Usage: {s} [size] [output-file]\n", .{args[0]});
        return error.InvalidUsage;
    }

    const n = try std.fmt.parseInt(u32, args[1], 10);
    const h = n;
    const w = n;

    const output_path = args[2];
    const output_file = try std.fs.cwd().createFile(output_path, .{ .truncate = true });
    defer output_file.close();
    var bufferedWriter = std.io.bufferedWriter(output_file.writer());
    var out = bufferedWriter.writer();

    try out.print("P4\n{d} {d}\n", .{ w, h });

    const iterations = 50;
    const limitSq = 4.0;

    var byteAcc: u8 = 0;
    var bitNum: u8 = 0;

    var y: usize = 0;
    while (y < h) : (y += 1) {
        const Ci: f64 = 2.0 * @as(f64, @floatFromInt(y)) / @as(f64, @floatFromInt(h)) - 1.0;
        var x: usize = 0;
        while (x < w) : (x += 1) {
            var Zr: f64 = 0.0;
            var Zi: f64 = 0.0;
            var Tr: f64 = 0.0;
            var Ti: f64 = 0.0;
            const Cr: f64 = 2.0 * @as(f64, @floatFromInt(x)) / @as(f64, @floatFromInt(w)) - 1.5;

            var i: usize = 0;
            while (i < iterations and (Tr + Ti < limitSq)) : (i += 1) {
                Zi = 2.0 * Zr * Zi + Ci;
                Zr = Tr - Ti + Cr;
                Tr = Zr * Zr;
                Ti = Zi * Zi;
            }

            byteAcc <<= 1;
            if (Tr + Ti <= limitSq)
                byteAcc |= 0x01;

            bitNum += 1;

            if (bitNum == 8) {
                try out.writeByte(byteAcc);
                byteAcc = 0;
                bitNum = 0;
            } else if (x == w - 1) {
                const offset: u4 = @intCast(w % 8);
                const shift: u3 = @intCast(8 - offset);
                byteAcc = byteAcc << shift;
                try out.writeByte(byteAcc);
                byteAcc = 0;
                bitNum = 0;
            }
        }
    }

    try bufferedWriter.flush();
}
