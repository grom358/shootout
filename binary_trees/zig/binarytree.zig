const std = @import("std");

const BinaryTree = struct {
    const Self = @This();

    left: ?*Self = null,
    right: ?*Self = null,

    pub fn init(allocator: std.mem.Allocator) !*Self {
        const bt = try allocator.create(Self);
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

const MIN_DEPTH = 4;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena;
    const allocator = arena.allocator();

    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 2) {
        std.debug.print("Usage: {s} <depth>", .{args[0]});
        std.process.exit(1);
    }

    const n = try std.fmt.parseInt(u32, args[1], 10);
    const maxDepth = @max(MIN_DEPTH + 2, n);

    var stdout_writer = std.Io.File.stdout().writer(init.io, &.{});
    const output = &stdout_writer.interface;

    {
        const stretchDepth = n + 1;
        const stretchTree = BinaryTree.createBottomUp(stretchDepth, allocator).?;
        const stretchCheck = stretchTree.countNodes();
        try output.print("stretch tree of depth {d}\t check: {d}\n", .{ stretchDepth, stretchCheck });
    }

    var longLivedArea = std.heap.ArenaAllocator.init(init.gpa);
    defer longLivedArea.deinit();
    const longLivedAllocator = longLivedArea.allocator();
    const longLivedTree = BinaryTree.createBottomUp(maxDepth, longLivedAllocator).?;

    var check: u64 = 0;
    var depth: u32 = MIN_DEPTH;
    while (depth <= maxDepth) : (depth += 2) {
        const iterations = @as(usize, 1) << @intCast(maxDepth - depth + MIN_DEPTH);
        check = 0;
        var i: u64 = 1;
        while (i <= iterations) : (i += 1) {
            _ = arena.reset(.retain_capacity);
            const tempTree = BinaryTree.createBottomUp(depth, allocator).?;
            check += tempTree.countNodes();
        }
        try output.print("{d}\t trees of depth {d}\t check: {d}\n", .{ iterations, depth, check });
    }

    try output.print("long lived tree of depth {d}\t check: {d}\n", .{ maxDepth, longLivedTree.countNodes() });
}
