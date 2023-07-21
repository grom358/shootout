#!/bin/bash
# Creates a new challenge layout

name=$1 # name of challenge
mkdir $name
cat > $name/README.md << 'EOF'
# NAME
Description

## Notes
```
# Build
$ ./build.sh

# Clean
$ ./clean.sh

# Generate report
$ ./generate.sh
```

## Results
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time  | RSS   |
| -------- | ----- | ----: |
EOF
sed -i "s/NAME/$name/" $name/README.md
cat > $name/languages.txt << EOF
c
cpp
go
rust
zig
odin
csharp
java
EOF
cat > $name/build.sh << 'EOF'
#!/bin/sh
for lang in $(cat languages.txt)
do
  echo "==Building $lang=="
  (cd $lang; ./build.sh)
done
EOF
chmod a+x $name/build.sh
cat > $name/clean.sh << 'EOF'
#!/bin/sh
for lang in $(cat languages.txt)
do
  echo "==Cleaning $lang=="
  (cd $lang; ./clean.sh)
done
EOF
chmod a+x $name/clean.sh
cat > $name/test.txt << EOF
Hello World!
EOF
cat > $name/run.sh << 'EOF'
#!/bin/bash
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/NAME 2> time.txt > cmp.txt
  diff test.txt cmp.txt > /dev/null
  ret=$?
  rm cmp.txt
  if [[ $ret -eq 0 ]]
  then
    echo -en "\e[32m[OK]\e[0m "
  else
    echo -en "\e[31m[FAILED]\e[0m "
  fi
  cat time.txt
  rm time.txt
}

for lang in $(cat languages.txt)
do
  bench $lang
done
EOF
sed -i "s/NAME/$name/" $name/run.sh
chmod a+x $name/run.sh
cat > $name/generate.sh << EOF
#!/bin/sh
./run.sh | tee /dev/tty | sort -n -k3 > results.txt; echo "====="; cat results.txt
EOF
chmod a+x $name/generate.sh
cat > $name/.gitignore << 'EOF'
results.txt
EOF

# Setup C implementation
lang=c
mkdir $name/$lang
cat > $name/$lang/build.sh << EOF
#!/bin/sh
gcc -O3 -Werror -Wall -pedantic -std=c17 -o $name $name.c
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
rm $name
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
$name
EOF
cat > $name/$lang/$name.c << 'EOF'
#include <stdio.h>

int main() {
  printf("Hello World!\n");
  return 0;
}
EOF

# Setup C++ implementation
lang=cpp
mkdir $name/$lang
cat > $name/$lang/build.sh << EOF
#!/bin/sh
g++ -O3 -Wall -Werror -std=c++17 -o $name $name.cpp
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
rm $name
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
$name
EOF
cat > $name/$lang/$name.cpp << 'EOF'
#include <iostream>

int main() {
    std::cout << "Hello World!" << std::endl;
    return 0;
}
EOF

# Setup Go implementation
lang=go
mkdir $name/$lang
cat > $name/$lang/build.sh << EOF
#!/bin/sh
go build
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
go clean
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
$name
EOF
(cd $name/$lang; go mod init $name)
cat > $name/$lang/main.go << 'EOF'
package main

import "fmt"

func main() {
        fmt.Println("Hello World!")
}
EOF

# Setup Rust implementation
lang=rust
cargo new --name $name $name/$lang
cat > $name/$lang/build.sh << EOF
#!/bin/sh
cargo build --release
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
cargo clean
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
target
EOF
cat > $name/$lang/src/main.rs << 'EOF'
fn main() {
    println!("Hello World!");
}
EOF
(cd $name/$lang; ln -s target/release/$name $name)

# Setup Odin implementation
lang=odin
mkdir $name/$lang
cat > $name/$lang/build.sh << EOF
#!/bin/sh
odin build . -o:speed -out:$name
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
rm $name
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
$name
EOF
cat > $name/$lang/$name.odin << 'EOF'
package main

import "core:fmt"

main :: proc() {
	fmt.println("Hello World!")
}
EOF

# Setup Zig implementation
lang=zig
mkdir $name/$lang
cat > $name/$lang/build.sh << EOF
#!/bin/sh
zig build-exe -O ReleaseFast $name.zig
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
rm $name
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
$name
*.o
EOF
cat > $name/$lang/$name.zig << 'EOF'
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello World!\n", .{});
}
EOF

# Setup C# implementation
lang=csharp
mkdir $name/$lang
dotnet new console -o $name/$lang -n $name
(cd $name/$lang; ln -s bin/Release/net7.0/$name $name)
cat > $name/$lang/build.sh << EOF
#!/bin/sh
dotnet build -c Release
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
dotnet clean
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
obj/Release
obj/Debug
bin
EOF
cat > $name/$lang/Program.cs << 'EOF'
Console.WriteLine("Hello World!");
EOF

# Setup Java implementation
lang=java
mkdir $name/$lang
cat > $name/$lang/build.sh << EOF
#!/bin/sh
mvn package
EOF
chmod a+x $name/$lang/build.sh
cat > $name/$lang/clean.sh << EOF
#!/bin/sh
mvn clean
EOF
chmod a+x $name/$lang/clean.sh
cat > $name/$lang/.gitignore << EOF
target/
.settings/
EOF
cat > $name/$lang/pom.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.cameronzemek</groupId>
    <artifactId>$name</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.3.0</version>
                <configuration>
                    <archive>
                        <manifest>
                            <addClasspath>true</addClasspath>
                            <mainClass>com.cameronzemek.$name.Main</mainClass>
                        </manifest>
                    </archive>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
EOF
mkdir -p $name/$lang/src/main/java/com/cameronzemek/$name
cat > $name/$lang/src/main/java/com/cameronzemek/$name/Main.java << EOF
package com.cameronzemek.$name;

public class Main {
  public static void main(String[] args) {
    System.out.println("Hello World!");
  }
}
EOF
cat > $name/$lang/$name << 'EOF'
#!/bin/bash
dir=$(dirname "$0")
exec java -jar $dir/target/NAME-1.0-SNAPSHOT.jar $@
EOF
sed -i "s/NAME/$name/" $name/$lang/$name
chmod a+x $name/$lang/$name
