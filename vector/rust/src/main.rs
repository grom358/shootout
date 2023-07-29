struct Random {
    im: u32,
    imf: f64,
    ia: u32,
    ic: u32,
    seed: u32,
}

impl Random {
    fn new() -> Random {
        Random {
            im: 139968,
            imf: 139968.0,
            ia: 3877,
            ic: 29573,
            seed: 42,
        }
    }

    fn next(&mut self, max: i32) -> usize {
        self.seed = (self.seed * self.ia + self.ic) % self.im;
        (max as f64 * (self.seed as f64 / self.imf)) as usize
    }
}

fn main() {
    let mut rand = Random::new();
    let mut numbers = Vec::new();
    let max = 100;
    let size = 200000000;

    for _ in 0..size {
        numbers.push(rand.next(max));
    }

    let mut sum: usize = 0;
    for _ in 0..1000 {
        sum += numbers[rand.next(size)];
    }

    println!("{}", sum);
}
