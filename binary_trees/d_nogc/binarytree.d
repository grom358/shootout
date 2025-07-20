import std.stdio;
import std.conv;
import core.stdc.stdlib : malloc, free;

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

    void destroy() @nogc {
        if (left !is null) {
            left.destroy();
            right.destroy();
        }
        free(&this);
    }

    static BinaryTree* create(BinaryTree* left, BinaryTree* right) @nogc {
        auto bt = cast(BinaryTree*) malloc(BinaryTree.sizeof);
        bt.left = left;
        bt.right = right;
        return bt;
    }

    static BinaryTree* bottomUp(uint depth) @nogc {
        if (depth > 0) {
            return create(bottomUp(depth - 1), bottomUp(depth - 1));
        } else {
            return create(null, null);
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

    // Stretch tree
    {
        uint stretchDepth = maxDepth + 1;
        auto stretchTree = BinaryTree.bottomUp(stretchDepth);
        writeln("stretch tree of depth ", stretchDepth, "\t check: ",
            stretchTree.count());
        stretchTree.destroy();
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
            tempTree.destroy();
        }

        writeln(iterations, "\t trees of depth ", depth, "\t check: ", check);
    }

    writeln("long lived tree of depth ", maxDepth, "\t check: ",
        longLivedTree.count());

    return 0;
}
