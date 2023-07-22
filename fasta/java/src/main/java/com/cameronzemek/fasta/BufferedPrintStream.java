package com.cameronzemek.fasta;

import java.io.PrintStream;

/**
 * PrintStream uses synchronized locking internally. This class adds buffering 
 * to the underlying PrintStream to reduce overall cost of this locking.
 */
public class BufferedPrintStream {
  PrintStream out;
  StringBuilder buffer = new StringBuilder(4096);

  public BufferedPrintStream(PrintStream out) { this.out = out; }

  public void println(String text) {
    if (text.length() + buffer.length() > buffer.capacity()) {
      out.print(buffer.toString());
      buffer.setLength(0);
    }
    buffer.append(text);
    buffer.append('\n');
  }

  public void flush() {
    out.print(buffer.toString());
    buffer.setLength(0);
    out.flush();
  }
}
