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
* zig - Uses arena allocator backed by the C allocator

With the zig implementation I tried various allocators as backends:

Legend:
* Backend = Backend allocator for arena allocator
* Time = Total seconds
* RSS = maximum resident set size in KB

| Backend                 | Time   | RSS     |
| ----------------------- | -----: | ------: |
| c_allocator             |   7.84 |  135256 |
| FixedBufferAllocator    |  12.82 | 1049700 |
| page_allocator          |  25.67 |  146376 |
| GeneralPurposeAllocator | 117.47 |  146588 |

In master branch of Zig ArenaAllocator supports retaining space. This would
greatly improve the performance (at least for page_allocator) as we won't have
to refetch pages from the OS in each iteration.

## Results
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Name             | Time  | RSS     |
| ---------------- | ----: | ------: |
| c_apr            |  2.28 |  133824 |
| java             |  2.85 | 1782580 |
| rust_typed_arena |  3.83 |  133040 |
| cpp_boost        |  4.38 |  265068 |
| zig              |  7.84 |  135256 |
| c                | 11.97 |  263628 |
| rust             | 12.94 |  460632 |
| cpp              | 14.21 |  462424 |
| csharp           | 14.51 |  555476 |
| odin_arena       | 15.15 |  428144 |
| go               | 19.77 |  204880 |
| odin             | 28.57 |  394904 |

Java GC uses a lot of RAM but it blows the other GC languages out of the water
here and even beats arena allocators from manual managed languages.
