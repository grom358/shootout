import std.stdio;
import std.string;
import std.conv;
import std.math;

int main(string[] args) {
    if (args.length != 3) {
        stderr.writefln("Usage: %s <size> <output.pbm>", args[0]);
        return 1;
    }

    int w = args[1].to!int;
    int h = w;

    string outputPath = args[2];
    auto file = File(outputPath, "wb");
    scope (exit) file.close();

    file.writef("P4\n%d %d\n", w, h);

    ubyte byteAcc = 0;
    int bitNum = 0;
    const int iterations = 50;
    const double limitSq = 4.0;

    foreach (int y; 0 .. h) {
        double Ci = 2.0 * y / h - 1.0;

        foreach (int x; 0 .. w) {
            double Zr = 0.0, Zi = 0.0;
            double Tr = 0.0, Ti = 0.0;
            double Cr = 2.0 * x / w - 1.5;

            int i = 0;
            while (i < iterations && (Tr + Ti <= limitSq)) {
                Zi = 2.0 * Zr * Zi + Ci;
                Zr = Tr - Ti + Cr;
                Tr = Zr * Zr;
                Ti = Zi * Zi;
                ++i;
            }

            byteAcc <<= 1;
            if (Tr + Ti <= limitSq) {
                byteAcc |= 0x01;
            }

            ++bitNum;

            bool endOfRow = (x == w - 1);
            if (bitNum == 8 || endOfRow) {
                if (endOfRow && (bitNum < 8)) {
                    byteAcc <<= (8 - bitNum); // pad remaining bits
                }
                file.rawWrite([byteAcc]);
                byteAcc = 0;
                bitNum = 0;
            }
        }
    }
    return 0;
}
