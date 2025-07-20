# Language shootout
Evaluation of programming languages:
* C
* C++
* D
* Rust
* Zig
* Odin
* Go
* Java
* C#

Mostly interested in non garbage collected languages in this shootout.

## Challenges
Implementations for the challenges are likely not idomatic due to my lack of
experience in the language. Most of my programming experience is in Java and PHP.

### Hello
Hello World to test startup and minimum memory costs.

### Lexer
Implements a lexer for a simple scripting language. The syntax requires only a
single character of lookahead.

### Palindrome
Use parallelism to calculate the sum of all numbers with 9 digits that are a 
palindrome.

### Vector
Vector (ie. dynamic resizable array) test.

### Binary Trees
Adaptation of binary-trees from the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/binarytrees.html#binarytrees).
Tests memory management. Implementations are single threaded and use ready
available libraries.

### Mandelbrot
Plot the Mandelbrot set [-1.5-i,0.5+i] on an 16000x16000 bitmap. Write output in portable bitmap format (pbm). From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/mandelbrot.html#mandelbrot).

### NBody
Model the orbits of Jovian planets, using the same simple symplectic-integrator. From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody).

### fasta
Generate and write random DNA sequences. From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/fasta.html#fasta).

### knucleotide
Hashtable of k-nucleotide strings. From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/knucleotide.html#knucleotide).

# Notes

## Java
Pros:
* Decent standard library
* Lots of 3rd party libraries
* Exceptions for error handling

Cons:
* Garbage collector
* UTF-16 strings
* No unsigned integer types
* Primitive types require boxing
* Everything must be in a class, no free-standing functions
* Requires runtime
* There is a tendency in the community to over abstract

## C#
Pros:
* Improvements to Java such as:
  * Structs
  * Unsigned integer types

Cons:
* Garbage collector
* UTF-16 strings
* Requires runtime

## Rust
Pros:
* Safety
* Nice compiler error messages
* Cargo

Cons:
* Slow compile times

## C
Pros:
* Portable assembly
* Foundational language
* Simple

Cons:
* Lots of footguns
* Manual memory management
* Weakly typed
* Barebones:
  * limited string operations. eg. doing string replacements
  * no dynamic array or hashtables
  * no built-in array slicing

## C++
Pros:
* Multi-paradigm
* Industry standard (used heavily for game development)

Cons:
* Bloated language. No mere mortal can know all the language.
* Hidden control flow. Eg. copy/move constructors are called and its not obvious.

## D
Pros:
* Improved C++

Cons:
* Small community
* Documentation lacks examples
* Garbage collection. GC is also not very advanced

## Go
Pros:
* Simple
* Fast compile times
* Generates standalone executables

Cons:
* Garbage collection. Generates less garbage then language like Java
* Manual error propagation

## Zig
Pros:
* No hidden control flow
* No hidden memory allocations
* No preprocessor, no macros
* Error values
* Custom allocators. Eg. arena allocator

Cons:
* Missing documentation
* No 1.0 release
* Not ready for production use

## Odin
Pros:
* Being used commerically by JangaFX
* Good standard library. Eg. built-in matrix type
* Support for SOA

Cons:
* Lacks popularity
* Language server in early development
* No 1.0 release

Misc:
* No Uniform Function Call Syntax (ie. `mytype.method()`) 
