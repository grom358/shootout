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
* d - Uses built-in garbage collector
* d_nogc - Uses malloc/free. Requires walking the tree to deallocate
* d_region - Uses std.experimental Region
* go - Uses built-in garbage collector
* go_arena - Array backed object arena
* java - Uses built-in garbage collector
* odin - Uses the default context.allocator and context.temp_allocator
* odin_arena - Uses mem.Arena with explicit buffer
* rust - Uses Box to managed deallocation of the tree
* rust_typed_arena - Uses the typed arena create as arena allocator for trees
* rust_arena - Custom arena
* zig - Uses arena allocator backed by page allocator

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language         |  Time |     RSS |
| ---------------- | ----: | ------: |
| cpp_arena        |  0.60 |  199912 |
| c_arena          |  0.62 |  198332 |
| go_arena         |  1.40 |  200668 |
| d_region         |  1.57 |  199376 |
| c_apr            |  1.62 |  133872 |
| rust_arena       |  1.66 |  198576 |
| java             |  2.26 | 3112604 |
| rust_typed_arena |  2.27 |  133192 |
| zig              |  2.39 |  196448 |
| odin_arena       |  3.11 |  198292 |
| cpp_boost        |  4.64 |  265364 |
| odin             |  6.12 |  231112 |
| d_nogc           |  6.41 |  265136 |
| rust             |  6.61 |  264244 |
| csharp           |  6.95 |  828420 |
| c                |  8.35 |  263880 |
| go               |  9.09 |  196604 |
| cpp              | 10.06 |  462540 |
| d                | 10.40 |  409144 |
