use std::collections::HashMap;
use std::io::{self, BufRead};

fn count_nucleotides(data: &str, k: usize) -> HashMap<&str, i32> {
    let mut counts = HashMap::new();
    let end_index = data.len() - k;
    for i in 0..=end_index {
        let fragment = &data[i..i + k];
        *counts.entry(fragment).or_insert(0) += 1;
    }
    counts
}

fn print_frequencies(data: &str, k: usize) {
    let counts = count_nucleotides(data, k);
    let total: i32 = counts.values().sum();

    let mut sorted_entries: Vec<_> = counts.iter().collect();
    sorted_entries.sort_by(|a, b| b.1.cmp(a.1));

    for (key, value) in sorted_entries {
        let frequency = (*value as f64) / (total as f64) * 100.0;
        println!("{} {:.3}", key.to_uppercase(), frequency);
    }
    println!();
}

fn print_sample_count(data: &str, sample: &str) {
    let k = sample.len();
    let counts = count_nucleotides(data, k);
    let sample_lower = sample.to_lowercase();
    let count = counts.get(&sample_lower[0..]).copied().unwrap_or(0);
    println!("{}\t{}", count, sample);
}

fn main() {
    let stdin = io::stdin();
    let mut lines_iter = stdin.lock().lines().map(|line| line.unwrap());

    while let Some(line) = lines_iter.next() {
        if line.starts_with(">THREE") {
            break;
        }
    }

    // Extract DNA sequence THREE.
    let data: String = lines_iter.collect();

    print_frequencies(&data, 1);
    print_frequencies(&data, 2);
    print_sample_count(&data, "GGT");
    print_sample_count(&data, "GGTA");
    print_sample_count(&data, "GGTATT");
    print_sample_count(&data, "GGTATTTTAATT");
    print_sample_count(&data, "GGTATTTTAATTTATAGT");
}
