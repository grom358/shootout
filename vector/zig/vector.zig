const std = @import("std");

const Random = struct {
    const IM: usize = 139968;
    const IMF: f64 = 139968.0;
    const IA: usize = 3877;
    const IC: usize = 29573;
    seed: usize,

    pub fn init() Random {
        return .{ .seed = 42 };
    }

    pub fn next(self: *Random, max: usize) usize {
        self.seed = (self.seed * IA + IC) % IM;
        return @intFromFloat(@as(f64, @floatFromInt(max)) * (@as(f64, @floatFromInt(self.seed)) / IMF));
    }
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    var numbers = try std.ArrayList(usize).initCapacity(allocator, 16);
    defer numbers.deinit(allocator);

    var rand = Random.init();
    const max: usize = 100;
    const size: usize = 200000000;

    var i: usize = 0;
    while (i < size) : (i += 1) {
        try numbers.append(allocator, rand.next(max));
    }

    var sum: usize = 0;
    i = 0;
    while (i < 1000) : (i += 1) {
        sum += numbers.items[rand.next(size)];
    }

    var stdout_writer = std.Io.File.stdout().writer(init.io, &.{});
    const stdout = &stdout_writer.interface;
    try stdout.print("{}\n", .{sum});
}
