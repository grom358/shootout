use std::env;
use typed_arena::Arena;

struct BinaryTree<'a> {
    left: Option<&'a BinaryTree<'a>>,
    right: Option<&'a BinaryTree<'a>>,
}

impl<'a> BinaryTree<'a> {
    fn count_nodes(&self) -> i32 {
        match (self.left, self.right) {
            (Some(left), Some(right)) => 1 + left.count_nodes() + right.count_nodes(),
            _ => 1,
        }
    }

    fn create_bottom_up<'r>(
        depth: i32,
        arena: &'r Arena<BinaryTree<'r>>,
    ) -> Option<&'r BinaryTree<'r>> {
        if depth >= 0 {
            let t: &BinaryTree<'r> = arena.alloc(BinaryTree {
                left: Self::create_bottom_up(depth - 1, arena),
                right: Self::create_bottom_up(depth - 1, arena),
            });
            Some(t)
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
        let arena = Arena::new();
        let stretch_depth = max_depth + 1;
        let stretch_tree = BinaryTree::create_bottom_up(stretch_depth, &arena).unwrap();
        println!(
            "stretch tree of depth {}\t check: {}",
            stretch_depth,
            stretch_tree.count_nodes()
        );
    }

    let long_lived_arena = Arena::new();
    let long_lived_tree = BinaryTree::create_bottom_up(max_depth, &long_lived_arena).unwrap();

    for depth in (min_depth..=max_depth).step_by(2) {
        let iterations = 1 << (max_depth - depth + min_depth);
        let mut check = 0;
        for _ in 1..=iterations {
            let arena = Arena::new();
            let temp_tree = BinaryTree::create_bottom_up(depth, &arena).unwrap();
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
