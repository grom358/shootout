# Binary Trees
 Adaptation of binary-trees from the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/binarytrees.html#binarytrees).
Tests memory management. Implementations are single threaded and use ready
available libraries.

An implementation performs the following:
* define a binary tree. Eg. with class or struct
* allocate a binary tree to 'stretch' memory, count its nodes, and dellocate it
* allocate a long-lived binary tree which will live-on while other trees are
allocated and deallocated
* allocate, walk (count nodes), and deallocate many bottom-up binary trees
* count the nodes in the long-lived tree

## Implementations

* c - Uses malloc/free . Requires walking the tree to deallocate
* c_apr - Uses Apache Portable Runtime memory pool
* cpp (C++) - Uses std::unique_ptr smart point to handle deallocation (this Requires
walking the tree)
* cpp_boost (C++) - Uses boost library memory pool
* csharp (C#) - Uses built-in garbage collector
* go - Uses built-in garbage collector
* java - Uses built-in garbage collector
* odin - Uses the default context.allocator and context.temp_allocator
* odin_arena - Uses a 1Gb backed arena allocator
* rust - Uses Box to managed deallocation of the tree
* rust_typed_arena - Uses the typed arena create as arena allocator for trees
* zig - Uses arena allocator backed by page allocator

## Results
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Name             | Time  | RSS     |
| ---------------- | ----: | ------: |
| c_apr            |  2.93 |  133824 |
| java             |  3.24 | 2237080 |
| rust_typed_arena |  3.63 |  135060 |
| zig              |  4.29 |  198600 |
| cpp_boost        |  4.60 |  265760 |
| odin_arena       |  6.37 |  331276 |
| odin             |  7.70 |  394604 |
| c                | 14.41 |  263656 |
| csharp           | 15.22 |  562860 |
| rust             | 15.89 |  263924 |
| cpp              | 17.53 |  462436 |
| go               | 22.51 |  247128 |

Java GC uses a lot of RAM but it blows the other GC languages out of the water
here and even beats arena allocators from manual managed languages.
