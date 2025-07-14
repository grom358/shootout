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

pub fn printFrequencies(out: anytype, data: []const u8, k: usize, allocator: std.mem.Allocator) !void {
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
        try out.print("{s} {d:.3}\n", .{ key, frequency });
    }
    try out.print("\n", .{});
}

pub fn printSampleCount(out: anytype, data: []const u8, sample: []const u8, allocator: std.mem.Allocator) !void {
    const k = sample.len;
    var counts = try countNucleotides(data, k, allocator);
    defer counts.deinit();
    var buffer: [64]u8 = undefined;
    var sampleLower = std.ascii.lowerString(&buffer, sample);

    if (counts.get(sampleLower[0..])) |count| {
        try out.print("{d}\t{s}\n", .{ count, sample });
    } else {
        try out.print("0\t{s}\n", .{sample});
    }
}

fn readData(file: std.fs.File, allocator: std.mem.Allocator) ![]u8 {
    var reader = file.reader();
    const input = try reader.readAllAlloc(allocator, 1024 * 1024 * 1024);
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
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3) {
        std.debug.print("Usage: {s} <input.txt> <output.txt>\n", .{args[0]});
        return error.InvalidUsage;
    }

    const input_path = args[1];
    const output_path = args[2];

    const input_file = try std.fs.cwd().openFile(input_path, .{});
    defer input_file.close();

    const output_file = try std.fs.cwd().createFile(output_path, .{ .truncate = true });
    defer output_file.close();

    const out_writer = output_file.writer();

    const data = try readData(input_file, allocator);
    defer allocator.free(data);

    try printFrequencies(out_writer, data, 1, allocator);
    try printFrequencies(out_writer, data, 2, allocator);
    try printSampleCount(out_writer, data, "GGT", allocator);
    try printSampleCount(out_writer, data, "GGTA", allocator);
    try printSampleCount(out_writer, data, "GGTATT", allocator);
    try printSampleCount(out_writer, data, "GGTATTTTAATT", allocator);
    try printSampleCount(out_writer, data, "GGTATTTTAATTTATAGT", allocator);
}
