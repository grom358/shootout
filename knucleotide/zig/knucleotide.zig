const std = @import("std");
const HashMap = std.StringHashMap(usize);

fn print(comptime format: []const u8, args: anytype) !void {
    try std.io.getStdOut().writer().print(format, args);
}

fn countNucleotides(data: []const u8, k: usize, allocator: std.mem.Allocator) !HashMap {
    var counts = HashMap.init(allocator);
    const endIndex = data.len - k;
    var i: usize = 0;
    while (i <= endIndex) : (i += 1) {
        const fragment = data[i .. i + k];
        const entry = try counts.getOrPutValue(fragment, 0);
        entry.value_ptr.* += 1;
    }
    return counts;
}

fn comparePair(_: void, a: HashMap.Entry, b: HashMap.Entry) bool {
    return b.value_ptr.* < a.value_ptr.*;
}

pub fn printFrequencies(data: []const u8, k: usize, allocator: std.mem.Allocator) !void {
    var counts = try countNucleotides(data, k, allocator);
    defer counts.deinit();
    var total: usize = 0;
    {
        var it = counts.valueIterator();
        while (it.next()) |value| {
            total += value.*;
        }
    }

    var sortedPairs = try std.ArrayList(HashMap.Entry).initCapacity(allocator, counts.count());
    defer sortedPairs.deinit();

    var it = counts.iterator();
    while (it.next()) |kv| {
        try sortedPairs.append(kv);
    }

    const pairs = try sortedPairs.toOwnedSlice();
    std.sort.block(HashMap.Entry, pairs, {}, comparePair);

    var frequency: f64 = 0.0;
    var buffer: [64]u8 = undefined;
    for (pairs) |pair| {
        frequency = @as(f64, @floatFromInt(pair.value_ptr.*)) / @as(f64, @floatFromInt(total)) * 100.0;
        const key = std.ascii.upperString(&buffer, pair.key_ptr.*);
        try print("{s} {d:.3}\n", .{ key, frequency });
    }
    try print("\n", .{});
}

pub fn printSampleCount(data: []const u8, sample: []const u8, allocator: std.mem.Allocator) !void {
    const k = sample.len;
    var counts = try countNucleotides(data, k, allocator);
    defer counts.deinit();
    var buffer: [64]u8 = undefined;
    var sampleLower = std.ascii.lowerString(&buffer, sample);

    if (counts.get(sampleLower[0..])) |count| {
        try print("{d}\t{s}\n", .{ count, sample });
    } else {
        try print("0\t{s}\n", .{sample});
    }
}

fn readData(allocator: std.mem.Allocator) ![]u8 {
    const stdin = std.io.getStdIn().reader();
    var bufferedReader = std.io.bufferedReader(stdin);
    var in = bufferedReader.reader();
    const input = try in.readAllAlloc(allocator, 1024 * 1024 * 1024);
    defer allocator.free(input);
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, ">THREE")) {
            break;
        }
    }
    const data = try std.mem.replaceOwned(u8, allocator, lines.rest(), "\n", "");
    return data;
}

pub fn main() !void {
    const allocator = std.heap.c_allocator;

    const data = try readData(allocator);
    defer allocator.free(data);

    try printFrequencies(data, 1, allocator);
    try printFrequencies(data, 2, allocator);
    try printSampleCount(data, "GGT", allocator);
    try printSampleCount(data, "GGTA", allocator);
    try printSampleCount(data, "GGTATT", allocator);
    try printSampleCount(data, "GGTATTTTAATT", allocator);
    try printSampleCount(data, "GGTATTTTAATTTATAGT", allocator);
}
