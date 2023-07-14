use std::env;

struct BinaryTree {
    left: Option<Box<BinaryTree>>,
    right: Option<Box<BinaryTree>>,
}

impl BinaryTree {
    fn new(left: Option<Box<BinaryTree>>, right: Option<Box<BinaryTree>>) -> Self {
        BinaryTree { left, right }
    }

    fn count_nodes(&self) -> i32 {
        match (&self.left, &self.right) {
            (Some(left), Some(right)) => 1 + left.count_nodes() + right.count_nodes(),
            _ => 1,
        }
    }

    fn create_bottom_up(depth: i32) -> Option<Box<BinaryTree>> {
        if depth >= 0 {
            Some(Box::new(BinaryTree::new(
                BinaryTree::create_bottom_up(depth - 1),
                BinaryTree::create_bottom_up(depth - 1),
            )))
        } else {
            None
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: binarytree [depth]");
        std::process::exit(1);
    }
    let n: i32 = args[1].parse().unwrap();

    let min_depth = 4;
    let max_depth = if min_depth + 2 > n { min_depth + 2 } else { n };

    {
        let stretch_depth = max_depth + 1;
        let stretch_tree = BinaryTree::create_bottom_up(stretch_depth).unwrap();
        println!(
            "stretch tree of depth {}\t check: {}",
            stretch_depth,
            stretch_tree.count_nodes()
        );
    }

    let long_lived_tree = BinaryTree::create_bottom_up(max_depth).unwrap();

    for depth in (min_depth..=max_depth).step_by(2) {
        let iterations = 1 << (max_depth - depth + min_depth);
        let mut check = 0;
        for _ in 1..=iterations {
            let temp_tree = BinaryTree::create_bottom_up(depth).unwrap();
            check += temp_tree.count_nodes();
        }
        println!(
            "{}\t trees of depth {}\t check: {}",
            iterations, depth, check
        );
    }

    println!(
        "long lived tree of depth {}\t check: {}",
        max_depth,
        long_lived_tree.count_nodes()
    );
}
