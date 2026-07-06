import std::io;

struct BinaryTree
{
	BinaryTree* left;
	BinaryTree* right;
}

struct BinaryTreeArena
{
	BinaryTree[] nodes;
	sz capacity;
	sz size;
}

fn void BinaryTreeArena.init(BinaryTreeArena* this, sz capacity)
{
	this.nodes = mem::new_array(BinaryTree, capacity);
	this.capacity = capacity;
	this.size = 0;
}

fn void BinaryTreeArena.free(BinaryTreeArena* this)
{
	free(this.nodes);
}

fn BinaryTree* BinaryTreeArena.allocate(BinaryTreeArena* this)
{
	assert(this.size < this.capacity);
	return &this.nodes[this.size++];
}

fn void BinaryTreeArena.reset(BinaryTreeArena* this)
{
	this.size = 0;
}

fn ulong binary_tree_count(BinaryTree* bt)
{
	if (bt.left == null)
	{
		return 1;
	}
	return 1 + binary_tree_count(bt.left) + binary_tree_count(bt.right);
}

fn BinaryTree* binary_tree_bottom_up(BinaryTreeArena* arena, uint depth)
{
	if (depth == 0)
	{
		BinaryTree* node = arena.allocate();
		*node = {.left = null, .right = null};
		return node;
	}

	BinaryTree* left = binary_tree_bottom_up(arena, depth - 1);
	BinaryTree* right = binary_tree_bottom_up(arena, depth - 1);

	BinaryTree* node = arena.allocate();
	*node = {.left = left, .right = right};

	return node;
}

fn int main(String[] args)
{
	if (args.len != 2)
	{
		io::printfn("Usage: binarytree <depth>");
		return 1;
	}

	uint n = args[1].to_uint() ?? 0;

	const uint MIN_DEPTH = 4;
	uint max_depth = (MIN_DEPTH + 2 > n) ? (MIN_DEPTH + 2) : n;

	uint max_nodes = (1 << (max_depth + 2));
	BinaryTreeArena arena;
	arena.init(max_nodes);
	defer arena.free();

	uint stretch_depth = max_depth + 1;
	BinaryTree* stretch_tree = binary_tree_bottom_up(&arena, stretch_depth);
	io::printfn("stretch tree of depth %d\t check: %d", stretch_depth, binary_tree_count(stretch_tree));
	arena.reset();

	BinaryTreeArena long_lived_arena;
	uint long_lived_node_count = 1 << (max_depth + 1);
	long_lived_arena.init(long_lived_node_count);
	defer long_lived_arena.free();
	BinaryTree* long_lived_tree = binary_tree_bottom_up(&long_lived_arena, max_depth);

	for (uint depth = MIN_DEPTH; depth <= max_depth; depth += 2)
	{
		ulong iterations = 1ul << (max_depth - depth + MIN_DEPTH);
		ulong check = 0;
		for (ulong i = 0; i < iterations; i++)
		{
			BinaryTree* t = binary_tree_bottom_up(&arena, depth);
			check += binary_tree_count(t);
			arena.reset();
		}
		io::printfn("%d\t trees of depth %d\t check: %d", iterations, depth, check);
	}

	io::printfn("long lived tree of depth %d\t check: %d", max_depth, binary_tree_count(long_lived_tree));

	return 0;
}
