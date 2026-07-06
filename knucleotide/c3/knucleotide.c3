import std::io;
import std::io::file;
import std::collections;
import std::sort;

alias NucleotideMap = HashMap{String, int};

struct Pair
{
	String key;
	int value;
}

fn int compare_pair(Pair* a, Pair* b)
{
	return b.value - a.value;
}

fn void count_nucleotides(String data, usz k, NucleotideMap* counts)
{
	if (data.len < k) return;

	usz end_index = data.len - k;
	for (usz i = 0; i <= end_index; i++)
	{
		String fragment = data [i:k];
		int current_count = counts.get(fragment) ?? 0;
		counts.set(fragment, current_count + 1);
	}
}

fn void print_frequencies(OutStream out, String data, usz k)
{
	@pool()
	{
		NucleotideMap counts;
		counts.tinit();
		count_nucleotides(data, k, &counts);

		int total = 0;
		List{Pair} pairs;
		pairs.tinit(counts.count);
		counts.@each(; key, val)
		{
			total += val;
			Pair p = {key, val};
			pairs.push(p);
		};
		Pair[] sorted_pairs = pairs.to_tarray();
		sort::quicksort(sorted_pairs, &compare_pair);

		foreach (pair : sorted_pairs)
		{
			String key = pair.key.to_upper_tcopy();
			double frequency = (double) pair.value / (double) total * 100.0;
			io::fprintfn(out, "%s %.3f", key, frequency);
		}
		io::fprintfn(out, "");
	};
}

fn void print_sample_count(OutStream out, String data, String sample)
{
	@pool()
	{
		NucleotideMap counts;
		counts.tinit();
		count_nucleotides(data, sample.len, &counts);

		int count = counts.get(sample.to_lower_tcopy()) ?? 0;
		io::fprintfn(out, "%d\t%s", count, sample);
	};
}

fn int main(String[] args)
{
	if (args.len != 3)
	{
		io::eprintfn("Usage: %s <input.txt> <output.txt>", args[0]);
		return 1;
	}

	File? in = file::open(args[1], "rb");
	if (catch err = in)
	{
		io::eprintfn("Error opening file '%s': %s", args[1], err);
		return 1;
	}
	defer in.close();

	char[100] line_buffer;
	Scanner scanner;
	scanner.init(&in, &line_buffer);

	// Read until the header line containing ">THREE" is detected
	while (true)
	{
		String? line = (String) scanner.scan();
		if (catch line)
		{
			break;
		}

		if (line.contains(">THREE"))
		{
			break;
		}
	}

	@pool()
	{
		DString data_builder;
		data_builder.tinit();
		while (true)
		{
			String? line = (String) scanner.scan();
			if (catch line)
			{
				break;
			}
			data_builder.append_string(line);
		}
		if (catch err = scanner.close()) {
			io::eprintfn("Error closing scanner: %s", err);
			return 1;
		}
		String data = data_builder.tcopy_str();

		File? fout = file::open(args[2], "wb");
		if (catch err = fout)
		{
			io::eprintfn("Error opening file '%s': %s", args[2], err);
			return 1;
		}
		defer fout.close();
		OutStream out = (OutStream) &fout;

		print_frequencies(out, data, 1);
		print_frequencies(out, data, 2);
		print_sample_count(out, data, "GGT");
		print_sample_count(out, data, "GGTA");
		print_sample_count(out, data, "GGTATT");
		print_sample_count(out, data, "GGTATTTTAATT");
		print_sample_count(out, data, "GGTATTTTAATTTATAGT");
	};

	return 0;
}
