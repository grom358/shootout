import std.stdio;
import std.conv;
import std.experimental.allocator.mallocator : Mallocator;
import std.experimental.allocator.building_blocks.region : Region;
import std.experimental.allocator : make;

struct BinaryTree {
    BinaryTree* left;
    BinaryTree* right;

    long count() @nogc nothrow const {
        if (left is null) {
            return 1;
        } else {
            return 1 + left.count() + right.count();
        }
    }

    static BinaryTree* create(BinaryTree* left, BinaryTree* right, ref Region!Mallocator region) @nogc {
        auto bt = region.make!BinaryTree();
        bt.left = left;
        bt.right = right;
        return bt;
    }

    static BinaryTree* bottomUp(uint depth, ref Region!Mallocator region) @nogc {
        if (depth > 0) {
            return create(bottomUp(depth - 1, region), bottomUp(depth - 1, region), region);
        } else {
            return create(null, null, region);
        }
    }
}

int main(string[] args) {
    if (args.length != 2) {
        stderr.writeln("Usage: binarytree <depth>");
        return 1;
    }

    uint N = args[1].to!uint;
    uint minDepth = 4;
    uint maxDepth = (minDepth + 2 > N) ? (minDepth + 2) : N;

    size_t maxNodes = (1 << (maxDepth + 2)) - 1;
    size_t regionSize = maxNodes * BinaryTree.sizeof;
    auto region = Region!Mallocator(regionSize);

    // Stretch tree
    {
        uint stretchDepth = maxDepth + 1;
        auto stretchTree = BinaryTree.bottomUp(stretchDepth, region);
        writeln("stretch tree of depth ", stretchDepth, "\t check: ",
            stretchTree.count());
    }

    // Long-lived tree
    size_t longLivedNodes = (1 << (maxDepth + 1)) - 1;
    auto longLivedRegion = Region!Mallocator(longLivedNodes * BinaryTree.sizeof);
    auto longLivedTree = BinaryTree.bottomUp(maxDepth, longLivedRegion);

    // Benchmark loop
    for (auto depth = minDepth; depth <= maxDepth; depth += 2) {
        long iterations = 1L << (maxDepth - depth + minDepth);
        long check = 0;

        foreach (i; 1 .. iterations + 1) {
            region.deallocateAll();
            auto tempTree = BinaryTree.bottomUp(depth, region);
            check += tempTree.count();
        }

        writeln(iterations, "\t trees of depth ", depth, "\t check: ", check);
    }

    writeln("long lived tree of depth ", maxDepth, "\t check: ",
        longLivedTree.count());

    return 0;
}
