use std::io::{self, BufWriter, Write};

fn min(a: usize, b: usize) -> usize {
    if a < b {
        a
    } else {
        b
    }
}

const IM: i32 = 139_968;
const IA: i32 = 3_877;
const IC: i32 = 29_573;

struct Random {
    seed: i32,
}

impl Random {
    pub fn new() -> Random {
        Random { seed: 42 }
    }

    pub fn next(&mut self) -> f64 {
        self.seed = (self.seed * IA + IC) % IM;
        f64::from(self.seed) / f64::from(IM)
    }
}

const WIDTH: usize = 60; // Fold lines after WIDTH bytes

struct AminoAcid {
    p: f64,
    c: char,
}

fn repeat_fasta<W: Write>(writer: &mut W, header: &str, s: &str, count: usize) -> io::Result<()> {
    writeln!(writer, "{}", header)?;
    let mut pos = 0;
    let s_len = s.len();
    let ss = s.to_string() + s;

    let mut count_remaining = count;
    while count_remaining > 0 {
        let length = min(WIDTH, count_remaining);
        let output = &ss[pos..(pos + length)];
        writeln!(writer, "{}", output)?;
        pos += length;
        if pos > s_len {
            pos -= s_len;
        }
        count_remaining -= length;
    }
    Ok(())
}

fn accumulate_probabilities(genelist: &mut Vec<AminoAcid>) {
    let mut cp = 0.0;
    for amino in genelist.iter_mut() {
        cp += amino.p;
        amino.p = cp;
    }
}

fn random_fasta<W: Write>(
    writer: &mut W,
    header: &str,
    genelist: &mut Vec<AminoAcid>,
    count: usize,
    random: &mut Random,
) -> io::Result<()> {
    writeln!(writer, "{}", header)?;
    accumulate_probabilities(genelist);
    let mut buf = String::new();

    let mut count_remaining = count;
    while count_remaining > 0 {
        let length = min(WIDTH, count_remaining);
        for _ in 0..length {
            let r = random.next();
            for amino in genelist.into_iter() {
                if amino.p >= r {
                    buf.push(amino.c);
                    break;
                }
            }
        }
        writeln!(writer, "{}", buf)?;
        buf.clear();
        count_remaining -= length;
    }
    Ok(())
}

fn main() -> io::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: fasta [size]");
        std::process::exit(1);
    }

    let n: usize = args[1].parse().unwrap();
    let stdout = io::stdout().lock();
    let mut writer = BufWriter::new(stdout);

    const ALU: &str = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG\
                       GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA\
                       GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA\
                       AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT\
                       CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC\
                       CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG\
                       CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
    repeat_fasta(&mut writer, ">ONE Homo sapiens alu", ALU, 2 * n)?;

    let mut random = Random::new();

    let mut iub: Vec<AminoAcid> = vec![
        AminoAcid { p: 0.27, c: 'a' },
        AminoAcid { p: 0.12, c: 'c' },
        AminoAcid { p: 0.12, c: 'g' },
        AminoAcid { p: 0.27, c: 't' },
        AminoAcid { p: 0.02, c: 'B' },
        AminoAcid { p: 0.02, c: 'D' },
        AminoAcid { p: 0.02, c: 'H' },
        AminoAcid { p: 0.02, c: 'K' },
        AminoAcid { p: 0.02, c: 'M' },
        AminoAcid { p: 0.02, c: 'N' },
        AminoAcid { p: 0.02, c: 'R' },
        AminoAcid { p: 0.02, c: 'S' },
        AminoAcid { p: 0.02, c: 'V' },
        AminoAcid { p: 0.02, c: 'W' },
        AminoAcid { p: 0.02, c: 'Y' },
    ];
    random_fasta(
        &mut writer,
        ">TWO IUB ambiguity codes",
        &mut iub,
        3 * n,
        &mut random,
    )?;

    let mut homosapiens: Vec<AminoAcid> = vec![
        AminoAcid {
            p: 0.3029549426680,
            c: 'a',
        },
        AminoAcid {
            p: 0.1979883004921,
            c: 'c',
        },
        AminoAcid {
            p: 0.1975473066391,
            c: 'g',
        },
        AminoAcid {
            p: 0.3015094502008,
            c: 't',
        },
    ];
    random_fasta(
        &mut writer,
        ">THREE Homo sapiens frequency",
        &mut homosapiens,
        5 * n,
        &mut random,
    )?;
    writer.flush()?;
    Ok(())
}
