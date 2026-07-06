import std::io;
import std::collections;

const IM = 139968;
const IMF = 139968.0;
const IA = 3877;
const IC = 29573;
int seed = 42;

fn int rand_next(int max)
{
	seed = (seed * IA + IC) % IM;
	return (int) (max * (seed / IMF));
}

const MAX = 100;
const SIZE = 200000000;

fn int main()
{
	@pool()
	{
		List{int} numbers;
		numbers.tinit();
		for (int i = 0; i < SIZE; i++)
		{
			numbers.push(rand_next(MAX));
		}

		int sum = 0;
		for (int i = 0; i < 1000; i++)
		{
			sum += numbers.get(rand_next(SIZE) % SIZE);
		}

		io::printfn("%d", sum);
	};

	return 0;
}
