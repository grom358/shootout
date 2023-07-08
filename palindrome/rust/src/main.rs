use std::sync::{Arc, Mutex};
use std::thread;

fn is_palindrome(number: usize) -> bool {
    let mut reversed_number = 0;
    let original_number = number;

    let mut n = number;
    while n != 0 {
        let digit = n % 10;
        reversed_number = reversed_number * 10 + digit;
        n /= 10;
    }

    original_number == reversed_number
}

fn calculate_sum(start: usize, end: usize, sum: Arc<Mutex<usize>>) {
    let mut local_sum = 0;
    for x in start..=end {
        if is_palindrome(x) {
            local_sum += x;
        }
    }

    let mut sum = sum.lock().unwrap();
    *sum += local_sum;
}

fn main() {
    let start = 100_000_000;
    let end = 999_999_999;
    let range = end - start;

    let cores = 4;
    let chunk = range / cores;

    let sum = Arc::new(Mutex::new(0));

    let mut handles = Vec::with_capacity(cores);

    for i in 0..cores {
        let start = start + (chunk * i);
        let end = if i == cores - 1 {
            end
        } else {
            start + chunk - 1
        };

        let sum = Arc::clone(&sum);
        let handle = thread::spawn(move || {
            calculate_sum(start, end, sum);
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    let sum = sum.lock().unwrap();
    println!("{}", *sum);
}
