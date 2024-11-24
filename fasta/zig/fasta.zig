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

fn repeatFasta(out: anytype, header: []const u8, comptime s: []const u8, repeat: usize) !void {
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

fn randomFasta(out: anytype, header: []const u8, genelist: []AminoAcid, repeat: usize) !void {
    try out.print("{s}", .{header});
    accumulateProbabilities(genelist);
    var buf: [WIDTH]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const ss = fbs.writer();
    var count = repeat;
    while (count > 0) {
        const length = @min(WIDTH, count);
        var pos: usize = 0;
        while (pos < length) : (pos += 1) {
            const r = randomNum();
            for (genelist) |gene| {
                if (gene.p >= r) {
                    try ss.writeByte(gene.c);
                    break;
                }
            }
        }
        try out.print("{s}\n", .{fbs.getWritten()});
        fbs.reset();
        count -= length;
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
    const stdout = std.io.getStdOut().writer();
    var bufferedWriter = std.io.bufferedWriter(stdout);
    defer bufferedWriter.flush() catch unreachable;
    const out = bufferedWriter.writer();

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
}
