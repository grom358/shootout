use std::env;
use std::io::{self, BufWriter, Write};

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    let size: usize = args[1].parse().expect("Failed to parse size argument");
    let mut bit_num = 0;
    let mut byte_acc = 0u8;
    let iter = 50;
    let limit = 2.0;

    let stdout = io::stdout().lock();
    let mut writer = BufWriter::new(stdout);
    write!(writer, "P4\n{} {}\n", size, size)?;

    for y in 0..size {
        let ci = 2.0 * y as f64 / size as f64 - 1.0;
        for x in 0..size {
            let mut zr = 0.0;
            let mut zi = 0.0;
            let mut tr = 0.0;
            let mut ti = 0.0;
            let cr = 2.0 * x as f64 / size as f64 - 1.5;

            for _ in 0..iter {
                if tr + ti > limit * limit {
                    break;
                }
                zi = 2.0 * zr * zi + ci;
                zr = tr - ti + cr;
                tr = zr * zr;
                ti = zi * zi;
            }

            byte_acc <<= 1;
            if tr + ti <= limit * limit {
                byte_acc |= 0x01;
            }

            bit_num += 1;

            if bit_num == 8 {
                writer.write(&[byte_acc])?;
                byte_acc = 0;
                bit_num = 0;
            } else if x == size - 1 {
                byte_acc <<= 8 - size % 8;
                writer.write(&[byte_acc])?;
                byte_acc = 0;
                bit_num = 0;
            }
        }
    }
    writer.flush()?;
    Ok(())
}
