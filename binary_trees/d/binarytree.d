import std.stdio;
import std.conv;

struct BinaryTree {
    BinaryTree* left;
    BinaryTree* right;

    long count() nothrow const {
        if (left is null) {
            return 1;
        } else {
            return 1 + left.count() + right.count();
        }
    }

    static BinaryTree* bottomUp(uint depth) {
        if (depth > 0) {
            return new BinaryTree(bottomUp(depth - 1), bottomUp(depth - 1));
        } else {
            return new BinaryTree(null, null);
        }
    }
}

extern (C) __gshared string[] rt_options = [
    "gcopt=initReserve:256 incPoolSize:16"
];

int main(string[] args) {
    if (args.length != 2) {
        stderr.writeln("Usage: binarytree <depth>");
        return 1;
    }

    uint N = args[1].to!uint;
    uint minDepth = 4;
    uint maxDepth = (minDepth + 2 > N) ? (minDepth + 2) : N;

    // Stretch tree
    {
        uint stretchDepth = maxDepth + 1;
        auto stretchTree = BinaryTree.bottomUp(stretchDepth);
        writeln("stretch tree of depth ", stretchDepth, "\t check: ",
            stretchTree.count());
    }

    // Long-lived tree
    auto longLivedTree = BinaryTree.bottomUp(maxDepth);

    // Benchmark loop
    for (auto depth = minDepth; depth <= maxDepth; depth += 2) {
        long iterations = 1L << (maxDepth - depth + minDepth);
        long check = 0;

        foreach (i; 1 .. iterations + 1) {
            auto tempTree = BinaryTree.bottomUp(depth);
            check += tempTree.count();
        }

        writeln(iterations, "\t trees of depth ", depth, "\t check: ", check);
    }

    writeln("long lived tree of depth ", maxDepth, "\t check: ",
        longLivedTree.count());

    return 0;
}
