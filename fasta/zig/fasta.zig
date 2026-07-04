const std = @import("std");

const IM: u32 = 139968;
const IA: u32 = 3877;
const IC: u32 = 29573;
var seed: u32 = 42;

fn randomNum() f64 {
    seed = (seed * IA + IC) % IM;
    return @as(f64, @floatFromInt(seed)) / @as(f64, @floatFromInt(IM));
}

const WIDTH: usize = 60;

fn repeatFasta(out: *std.Io.Writer, header: []const u8, comptime s: []const u8, repeat: usize) !void {
    try out.print("{s}", .{header});
    var pos: usize = 0;
    const sLen: usize = s.len;
    const ss = s ++ s;
    var count = repeat;
    while (count > 0) {
        const length = @min(WIDTH, count);
        const chunk = ss[pos .. pos + length];
        try out.print("{s}\n", .{chunk});
        pos += length;
        if (pos > sLen) {
            pos -= sLen;
        }
        count -= length;
    }
}

const AminoAcid = struct {
    p: f64,
    c: u8,
};

fn accumulateProbabilities(genelist: []AminoAcid) void {
    var cp: f64 = 0.0;
    for (genelist, 0..) |gene, i| {
        cp += gene.p;
        genelist[i].p = cp;
    }
}

fn randomFasta(out: *std.Io.Writer, header: []const u8, genelist: []AminoAcid, repeat: usize) !void {
    try out.print("{s}", .{header});
    accumulateProbabilities(genelist);
    var buf: [WIDTH]u8 = undefined;
    var count = repeat;
    while (count > 0) {
        const length = @min(WIDTH, count);
        var pos: usize = 0;
        while (pos < length) : (pos += 1) {
            const r = randomNum();
            for (genelist) |gene| {
                if (gene.p >= r) {
                    buf[pos] = gene.c;
                    break;
                }
            }
        }
        try out.print("{s}\n", .{buf[0..length]});
        count -= length;
    }
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.arena.allocator();

    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) {
        std.debug.print("Usage: {s} <size> <output.txt>", .{args[0]});
        std.process.exit(1);
    }

    const n = try std.fmt.parseInt(usize, args[1], 10);

    const output_path = args[2];
    const output_file = try std.Io.Dir.cwd().createFile(io, output_path, .{ .truncate = true });
    defer output_file.close(io);

    var write_buffer: [4096]u8 = undefined;
    var buffered_writer = output_file.writer(io, &write_buffer);
    const out = &buffered_writer.interface;

    const alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG" ++
        "GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA" ++
        "GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA" ++
        "AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT" ++
        "CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC" ++
        "CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG" ++
        "CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
    try repeatFasta(out, ">ONE Homo sapiens alu\n", alu, 2 * n);

    // zig fmt: off
    var iub: [15]AminoAcid = .{
        AminoAcid{ .p = 0.27, .c = 'a' },
        AminoAcid{ .p = 0.12, .c = 'c' },
        AminoAcid{ .p = 0.12, .c = 'g' },
        AminoAcid{ .p = 0.27, .c = 't' },
        AminoAcid{ .p = 0.02, .c = 'B' },
        AminoAcid{ .p = 0.02, .c = 'D' },
        AminoAcid{ .p = 0.02, .c = 'H' },
        AminoAcid{ .p = 0.02, .c = 'K' },
        AminoAcid{ .p = 0.02, .c = 'M' },
        AminoAcid{ .p = 0.02, .c = 'N' },
        AminoAcid{ .p = 0.02, .c = 'R' },
        AminoAcid{ .p = 0.02, .c = 'S' },
        AminoAcid{ .p = 0.02, .c = 'V' },
        AminoAcid{ .p = 0.02, .c = 'W' },
        AminoAcid{ .p = 0.02, .c = 'Y' }};
    try randomFasta(out, ">TWO IUB ambiguity codes\n", iub[0..], 3 * n);

    var homosapiens: [4]AminoAcid = .{
        AminoAcid{ .p = 0.3029549426680, .c = 'a' },
        AminoAcid{ .p = 0.1979883004921, .c = 'c' },
        AminoAcid{ .p = 0.1975473066391, .c = 'g' },
        AminoAcid{ .p = 0.3015094502008, .c = 't' }};
    try randomFasta(out, ">THREE Homo sapiens frequency\n", homosapiens[0..], 5 * n);

    try buffered_writer.flush();
}
