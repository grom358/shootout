using System.Text;

if (args.Length != 2) {
  Console.Error.WriteLine("Usage: mandelbrot <size> <output.pbm>");
  Environment.Exit(1);
}

int w, h, bitNum = 0;
byte byteAcc = 0;
int iterations = 50;
double limitSq = 4.0;
double Zr, Zi, Cr, Ci, Tr, Ti;

w = h = int.Parse(args[0]);

string outputPath = args[1];
using FileStream outStream = new FileStream(outputPath, FileMode.Create, FileAccess.Write, FileShare.None);
BufferedStream bufferedOut = new BufferedStream(outStream);

byte[] header = Encoding.UTF8.GetBytes($"P4\n{w} {h}\n");
bufferedOut.Write(header, 0, header.Length);

for (int y = 0; y < h; ++y) {
  Ci = (2.0 * y / h - 1.0);
  for (int x = 0; x < w; ++x) {
    Zr = Zi = Tr = Ti = 0.0;
    Cr = (2.0 * x / w - 1.5);

    for (int i = 0; i < iterations && (Tr + Ti <= limitSq); ++i) {
      Zi = 2.0 * Zr * Zi + Ci;
      Zr = Tr - Ti + Cr;
      Tr = Zr * Zr;
      Ti = Zi * Zi;
    }

    byteAcc <<= 1;
    if (Tr + Ti <= limitSq)
      byteAcc |= 0x01;

    ++bitNum;

    if (bitNum == 8) {
      bufferedOut.WriteByte(byteAcc);
      byteAcc = 0;
      bitNum = 0;
    } else if (x == w - 1) {
      byteAcc <<= (8 - w % 8);
      bufferedOut.WriteByte(byteAcc);
      byteAcc = 0;
      bitNum = 0;
    }
  }
}
bufferedOut.Flush();
