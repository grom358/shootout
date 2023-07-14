# Language shootout
Evaluation of programming languages:
* C
* C++
* Rust
* Zig
* Odin
* Go
* Java
* C#

Mostly interested in non garbage collected languages in this shootout.

## Installation
NOTE: I am using Manjaro Linux 23
* time (provides CPU/maximum memory usage for benchmarking)
* gcc, make (C/C++)
* llvm-14 (for building Odin)
* dotnet-sdk
* jdk17-openjdk
* go
* zig
* apr
* boost

```
# install rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install Odin
git clone --depth 1 https://github.com/odin-lang/Odin
cd Odin
export LLVM_CONFIG=llvm-config-14
./build_odin.sh
# add ~/Odin to PATH
```

Using neovim with NVChad for code editing. Encountered the following issues:

C/C++ editing would complain with `multiple different client offset_encodings detected for buffer, this is not supported yet`. Fixed with:
```
# ~/.config/nvim/lua/custom/configs/lspconfig.lua
local clang_cap = require("plugins.configs.lspconfig").capabilities
clang_cap.offsetEncoding = "utf-16"
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = clang_cap,
}
```
C# LSP required setting path to OmniSharp.dll even though installed via Mason:
```
# ~/.config/nvim/lua/custom/configs/lspconfig.lua
lspconfig.omnisharp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "dotnet", "/home/grom/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
}
```

## Challenges
Implementations for the challenges are likely not idomatic due to my lack of
experience in the language. Most of my programming experience is in Java and PHP.

### Lexer
Implements a lexer for a simple scripting language. The syntax requires only a
single character of lookahead.

### Palindrome
Use parallelism to calculate the sum of all numbers with 9 digits that are a 
palindrome.

### Binary Trees
Adaptation of binary-trees from the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/binarytrees.html#binarytrees).
Tests memory management. Implementations are single threaded and use ready
available libraries.

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
* Error avlues
* Custom allocators. Eg. arena allocator

Cons:
* Missing documentation
* No 1.0 release

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
