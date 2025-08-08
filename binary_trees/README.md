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
* odin_arena - Uses mem.Arena with explicit buffer
* rust - Uses Box to managed deallocation of the tree
* rust_typed_arena - Uses the typed arena create as arena allocator for trees
* zig - Uses arena allocator backed by page allocator

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language         |  Time |     RSS |
| ---------------- | ----: | ------: |
| c_apr            |  1.76 |  133768 |
| java             |  2.42 | 3097956 |
| cpp_boost        |  2.43 |  265204 |
| rust_typed_arena |  2.44 |  133136 |
| zig              |  2.47 |  198232 |
| odin_arena       |  3.29 |  331052 |
| odin             |  4.15 |  394760 |
| rust             |  7.36 |  264348 |
| csharp           |  7.49 |  568372 |
| c                |  9.17 |  263860 |
| go               | 10.21 |  197528 |
| cpp              | 10.91 |  462456 |
