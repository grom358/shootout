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
* c_arena - Custom Arena
* cpp (C++) - Uses std::unique_ptr smart point to handle deallocation (this Requires
walking the tree)
* cpp_boost (C++) - Uses boost library memory pool
* cpp_arena - Custom arena
* csharp (C#) - Uses built-in garbage collector
* c3 - Custom Arena
* d - Uses built-in garbage collector
* d_nogc - Uses malloc/free. Requires walking the tree to deallocate
* d_region - Uses std.experimental Region
* go - Uses built-in garbage collector
* go_arena - Array backed object arena
* java - Uses built-in garbage collector
* nim - Uses built-in memory management
* odin - Uses the default context.allocator and context.temp_allocator
* odin_arena - Uses mem.Arena with explicit buffer
* rust - Uses Box to managed deallocation of the tree
* rust_typed_arena - Uses the typed arena crate as arena allocator for trees
* rust_arena - Custom arena
* zig - Uses arena allocator backed by page allocator

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language         |  Time |     RSS |
| ---------------- | ----: | ------: |
| cpp_arena        |  0.54 |  200188 |
| c_arena          |  0.55 |  198412 |
| c3               |  1.29 |  198176 |
| d_region         |  1.38 |  199480 |
| go_arena         |  1.43 |  200740 |
| c_apr            |  1.61 |  134036 |
| java             |  1.61 | 3361332 |
| rust_arena       |  1.67 |  198752 |
| rust_typed_arena |  2.18 |  133108 |
| cpp_boost        |  2.39 |  265760 |
| zig              |  3.53 |  200000 |
| odin_arena       |  5.57 |  198204 |
| csharp           |  6.60 |  581504 |
| odin             |  6.77 |  230848 |
| ocaml            |  7.04 |  285960 |
| c                |  7.26 |  263900 |
| d_nogc           |  8.41 |  264940 |
| nim              |  8.49 |  443964 |
| go               |  8.67 |  210972 |
| cpp              |  9.25 |  462184 |
| d                | 10.58 |  409004 |
| rust             | 12.00 |  264216 |
