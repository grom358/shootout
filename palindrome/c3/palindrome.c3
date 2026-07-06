import std::io;
import std::thread;

struct ThreadData
{
	int start;
	int end;
	long sum;
}

fn bool is_palindrome(int number)
{
	int reversed_number = 0;
	int original_number = number;

	int n = number;
	while (n != 0)
	{
		int digit = n % 10;
		reversed_number = reversed_number * 10 + digit;
		n /= 10;
	}

	return original_number == reversed_number;
}

fn int calculate_sum(void* arg)
{
	ThreadData* data = (ThreadData*) arg;
	data.sum = 0;

	for (int x = data.start; x <= data.end; x++)
	{
		if (is_palindrome(x))
		{
			data.sum += x;
		}
	}
	return 0;
}

fn int main()
{
	int start = 100000000;
	int end = 999999999;
	int range = end - start;

	const int CORES = 4;
	int chunk = range / CORES;

	thread::Thread[CORES] threads;
	ThreadData[CORES] thread_data;

	for (int i = 0; i < CORES; i++)
	{
		thread_data[i].start = start + (chunk * i);
		thread_data[i].end = (i == CORES - 1) ? end : thread_data[i].start + chunk - 1;
		if (catch err = threads[i].create(&calculate_sum, &thread_data[i]))
		{
			io::eprintfn("Failed to spawn thread %d: %s", i, err);
			return 1;
		}
	}

	long result = 0;

	for (int i = 0; i < CORES; i++)
	{
		threads[i].join();
		result += thread_data[i].sum;
	}

	io::printfn("%d", result);

	return 0;
}
