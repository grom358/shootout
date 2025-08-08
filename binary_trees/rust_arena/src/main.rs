use std::cell::UnsafeCell;
use std::env;
use std::mem::MaybeUninit;
use std::ptr;

pub struct Arena<T> {
    buf: Box<[MaybeUninit<T>]>,
    bump: UnsafeCell<usize>,
}

impl<T> Arena<T> {
    pub fn with_capacity(capacity: usize) -> Self {
        let mut vec = Vec::with_capacity(capacity);
        vec.resize_with(capacity, MaybeUninit::uninit);
        let buf = vec.into_boxed_slice();

        Self {
            buf,
            bump: UnsafeCell::new(0),
        }
    }

    pub fn alloc(&self, value: T) -> &mut T {
        let bump = unsafe { &mut *self.bump.get() };

        if *bump >= self.buf.len() {
            panic!("Arena out of capacity");
        }

        let slot = &self.buf[*bump];
        *bump += 1;

        unsafe {
            let ptr = slot.as_ptr() as *mut T;
            ptr::write(ptr, value);
            &mut *ptr
        }
    }

    // Reset without dropping the objects, just resets the bump pointer.
    pub fn reset(&self) {
        let bump = unsafe { &mut *self.bump.get() };
        *bump = 0;
    }
}

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

    fn create_bottom_up(
        depth: i32,
        arena: &'a Arena<BinaryTree<'a>>,
    ) -> Option<&'a BinaryTree<'a>> {
        if depth < 0 {
            return None;
        }
        let left = Self::create_bottom_up(depth - 1, arena);
        let right = Self::create_bottom_up(depth - 1, arena);
        let t = arena.alloc(BinaryTree { left, right });
        Some(t)
    }
}

fn nodes_for_depth(d: i32) -> usize {
    (1 << (d + 1)) - 1
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: binarytree <depth>");
        std::process::exit(1);
    }
    let n: i32 = args[1].parse().unwrap();

    let min_depth = 4;
    let max_depth = if min_depth + 2 > n { min_depth + 2 } else { n };

    let arena = Arena::with_capacity(nodes_for_depth(max_depth + 1));
    {
        let stretch_depth = max_depth + 1;
        let stretch_tree = BinaryTree::create_bottom_up(stretch_depth, &arena).unwrap();
        println!(
            "stretch tree of depth {}\t check: {}",
            stretch_depth,
            stretch_tree.count_nodes()
        );
        arena.reset();
    }

    let long_lived_arena = Arena::with_capacity(nodes_for_depth(max_depth));
    let long_lived_tree = BinaryTree::create_bottom_up(max_depth, &long_lived_arena).unwrap();

    for depth in (min_depth..=max_depth).step_by(2) {
        let iterations = 1 << (max_depth - depth + min_depth);
        let mut check = 0;
        for _ in 1..=iterations {
            let temp_tree = BinaryTree::create_bottom_up(depth, &arena).unwrap();
            check += temp_tree.count_nodes();
            arena.reset();
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
