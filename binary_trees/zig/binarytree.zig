const std = @import("std");

const BinaryTree = struct {
    const Self = @This();

    left: ?*Self = null,
    right: ?*Self = null,

    pub fn init(allocator: std.mem.Allocator) !*Self {
        var bt = try allocator.create(Self);
        bt.* = .{};
        return bt;
    }

    pub fn createBottomUp(depth: u64, allocator: std.mem.Allocator) ?*Self {
        var bt = Self.init(allocator) catch return null;
        if (depth > 0) {
            const d = depth - 1;
            bt.left = Self.createBottomUp(d, allocator);
            bt.right = Self.createBottomUp(d, allocator);
        }
        return bt;
    }

    pub fn countNodes(self: *Self) u64 {
        var sum: u64 = 1;
        if (self.left != null) {
            sum += self.left.?.countNodes();
        }
        if (self.right != null) {
            sum += self.right.?.countNodes();
        }
        return sum;
    }
};

fn get_n() !usize {
    var arg_it = std.process.args();
    _ = arg_it.skip();
    const arg = arg_it.next() orelse return 10;
    return try std.fmt.parseInt(u32, arg, 10);
}

const MIN_DEPTH = 4;

pub fn main() !void {
    const globalAllocator = std.heap.c_allocator;

    // const cAllocator = std.heap.c_allocator;
    // var buffer = try cAllocator.alloc(u8, 1024 * 1024 * 1024);
    // var fba = std.heap.FixedBufferAllocator.init(buffer[0..]);
    // const globalAllocator = fba.allocator();

    // const globalAllocator = std.heap.page_allocator;

    // var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    // const globalAllocator = general_purpose_allocator.allocator();

    const n = try get_n();
    const maxDepth = @max(MIN_DEPTH + 2, n);

    var output = std.io.getStdOut().writer();

    {
        var stretchArena = std.heap.ArenaAllocator.init(globalAllocator);
        defer stretchArena.deinit();
        const stretchAllocator = stretchArena.allocator();
        const stretchDepth = n + 1;
        const stretchTree = BinaryTree.createBottomUp(stretchDepth, stretchAllocator).?;
        const stretchCheck = stretchTree.countNodes();
        try output.print("stretch tree of depth {d}\t check: {d}\n", .{ stretchDepth, stretchCheck });
    }

    var longLivedArea = std.heap.ArenaAllocator.init(globalAllocator);
    defer longLivedArea.deinit();
    const longLivedAllocator = longLivedArea.allocator();
    const longLivedTree = BinaryTree.createBottomUp(maxDepth, longLivedAllocator).?;

    var check: u64 = 0;
    var depth: u32 = MIN_DEPTH;
    while (depth <= maxDepth) : (depth += 2) {
        const iterations = @as(usize, 1) << @intCast(u6, maxDepth - depth + MIN_DEPTH);
        check = 0;
        var i: u64 = 1;
        while (i <= iterations) : (i += 1) {
            var arena = std.heap.ArenaAllocator.init(globalAllocator);
            defer arena.deinit();
            const allocator = arena.allocator();
            const tempTree = BinaryTree.createBottomUp(depth, allocator).?;
            check += tempTree.countNodes();
        }
        try output.print("{d}\t trees of depth {d}\t check: {d}\n", .{ iterations, depth, check });
    }

    try output.print("long lived tree of depth {d}\t check: {d}\n", .{ maxDepth, longLivedTree.countNodes() });
}
