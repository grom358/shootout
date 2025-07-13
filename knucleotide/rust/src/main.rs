use std::collections::HashMap;
use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader, BufWriter, Write};

fn count_nucleotides(data: &str, k: usize) -> HashMap<&str, i32> {
    let mut counts = HashMap::new();
    let end_index = data.len() - k;
    for i in 0..=end_index {
        let fragment = &data[i..i + k];
        *counts.entry(fragment).or_insert(0) += 1;
    }
    counts
}

fn print_frequencies(writer: &mut impl Write, data: &str, k: usize) -> io::Result<()> {
    let counts = count_nucleotides(data, k);
    let total: i32 = counts.values().sum();

    let mut sorted_entries: Vec<_> = counts.iter().collect();
    sorted_entries.sort_by(|a, b| b.1.cmp(a.1));

    for (key, value) in sorted_entries {
        let frequency = (*value as f64) / (total as f64) * 100.0;
        writeln!(writer, "{} {:.3}", key.to_uppercase(), frequency)?;
    }
    writeln!(writer)?;
    Ok(())
}

fn print_sample_count(writer: &mut impl Write, data: &str, sample: &str) -> io::Result<()> {
    let k = sample.len();
    let counts = count_nucleotides(data, k);
    let sample_lower = sample.to_lowercase();
    let count = counts.get(&sample_lower[0..]).copied().unwrap_or(0);
    writeln!(writer, "{}\t{}", count, sample)?;
    Ok(())
}

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() != 3 {
        eprintln!("Usage: {} [input-file] [output-file]", args[0]);
        std::process::exit(1);
    }

    let input_file = File::open(&args[1])?;
    let output_file = File::create(&args[2])?;
    let reader = BufReader::new(input_file);
    let mut writer = BufWriter::new(output_file);

    let mut lines_iter = reader.lines().map(|line| line.unwrap());

    while let Some(line) = lines_iter.next() {
        if line.starts_with(">THREE") {
            break;
        }
    }

    // Extract DNA sequence THREE.
    let data: String = lines_iter.collect();

    print_frequencies(&mut writer, &data, 1)?;
    print_frequencies(&mut writer, &data, 2)?;
    print_sample_count(&mut writer, &data, "GGT")?;
    print_sample_count(&mut writer, &data, "GGTA")?;
    print_sample_count(&mut writer, &data, "GGTATT")?;
    print_sample_count(&mut writer, &data, "GGTATTTTAATT")?;
    print_sample_count(&mut writer, &data, "GGTATTTTAATTTATAGT")?;

    writer.flush()?;
    Ok(())
}
