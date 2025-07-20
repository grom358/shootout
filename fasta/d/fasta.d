import std.algorithm;
import std.stdio;
import std.conv;

enum WIDTH = 60;
enum IM = 139968;
enum IA = 3877;
enum IC = 29573;

int seed = 42;

double randomNum() {
    seed = (seed * IA + IC) % IM;
    return cast(double) seed / IM;
}

struct AminoAcid {
    double p;
    char c;
}

void repeatFasta(File file, string header, string s, int count) {
    file.write(header);
    auto ss = s ~ s; // duplicate the string
    size_t pos = 0;
    int sLen = cast(int) s.length;

    while (count > 0) {
        int length = min(WIDTH, count);
        file.write(ss[pos .. pos + length], '\n');
        pos += length;
        if (pos > sLen)
            pos -= sLen;
        count -= length;
    }
}

void accumulateProbabilities(ref AminoAcid[] genelist) {
    double cp = 0.0;
    foreach (ref amino; genelist) {
        cp += amino.p;
        amino.p = cp;
    }
}

void randomFasta(File file, string header, ref AminoAcid[] genelist, int count) {
    file.write(header);
    accumulateProbabilities(genelist);
    char[WIDTH + 1] buf;

    while (count > 0) {
        int length = min(WIDTH, count);
        foreach (i; 0 .. length) {
            double r = randomNum();
            foreach (amino; genelist) {
                if (amino.p >= r) {
                    buf[i] = amino.c;
                    break;
                }
            }
        }
        buf[length] = '\n';
        file.rawWrite(buf[0 .. length + 1]);
        count -= length;
    }
}

int main(string[] args) {
    if (args.length != 3) {
        stderr.writefln("Usage: %s <size> <output.txt>", args[0]);
        return 1;
    }

    int n = args[1].to!int;
    auto file = File(args[2], "wb");
    scope (exit)
        file.close();

    string alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG"
        ~ "GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA"
        ~ "GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA"
        ~ "AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT"
        ~ "CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC"
        ~ "CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG"
        ~ "CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

    repeatFasta(file, ">ONE Homo sapiens alu\n", alu, 2 * n);

    AminoAcid[] iub = [
        {0.27, 'a'}, {0.12, 'c'}, {0.12, 'g'}, {0.27, 't'},
        {0.02, 'B'}, {0.02, 'D'}, {0.02, 'H'}, {0.02, 'K'},
        {0.02, 'M'}, {0.02, 'N'}, {0.02, 'R'}, {0.02, 'S'},
        {0.02, 'V'}, {0.02, 'W'}, {0.02, 'Y'}
    ];
    randomFasta(file, ">TWO IUB ambiguity codes\n", iub, 3 * n);

    AminoAcid[] homosapiens = [
        {0.3029549426680, 'a'},
        {0.1979883004921, 'c'},
        {0.1975473066391, 'g'},
        {0.3015094502008, 't'}
    ];
    randomFasta(file, ">THREE Homo sapiens frequency\n", homosapiens, 5 * n);

    return 0;
}
