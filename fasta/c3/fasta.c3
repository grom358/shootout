import std::io;

const IM = 139968;
const IA = 3877;
const IC = 29573;

int seed = 42;

fn double random_num()
{
	seed = (seed * IA + IC) % IM;
	return (double) seed / (double) IM;
}

const sz WIDTH = 60;

struct AminoAcid
{
	double p;
	char c;
}

fn void accumulate_probabilities(AminoAcid[] genelist)
{
	double cp = 0.0;

	for (usz i = 0; i < genelist.len; i++)
	{
		cp += genelist[i].p;
		genelist[i].p = cp;
	}
}

fn void? repeat_fasta(io::File* file, String header, String s, sz count)
{
	io::fprintf(file, header)!;

	sz s_len = s.len;
	char[] ss = mem::new_array(char, s_len * 2);
	defer mem::free(ss.ptr);
	mem::copy(&ss[0], s.ptr, s.len);
	mem::copy(&ss[s_len], s.ptr, s.len);

	sz pos = 0;
	while (count > 0)
	{
		sz length = min(WIDTH, count);
		file.write(ss[pos..pos + length - 1])!;
		file.write("\n")!;
		pos += length;
		if (pos >= s_len)
		{
			pos -= s_len;
		}
		count -= length;
	}
}

fn void? random_fasta(io::File* file, String header, AminoAcid[] genelist, sz count)
{
	io::fprintf(file, header)!;
	accumulate_probabilities(genelist);
	char[WIDTH] buf;
	while (count > 0)
	{
		sz length = min(WIDTH, count);
		for (sz i = 0; i < length; i++)
		{
			double r = random_num();
			for (sz j = 0; j < genelist.len; j++)
			{
				if (genelist[j].p >= r)
				{
					buf[i] = genelist[j].c;
					break;
				}
			}
		}
		buf[length] = '\n';
		file.write(buf[..length])!;
		count -= length;
	}
}

fn int main(String[] args)
{
	if (args.len != 3)
	{
		io::eprintfn("Usage: fasta <size> <output.txt>");
		return 1;
	}

	sz n = args[1].to_int() ?? 0;

	String filename = args[2];
	File? file = io::file::open(args[2], "wb");
	if (catch err = file)
	{
		io::eprintfn("Unable to open file '%s': %s", filename, err);
		return 1;
	}

	String alu =
		"GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG"
		"GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA"
		"GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA"
		"AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT"
		"CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC"
		"CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG"
		"CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

	if (catch err = repeat_fasta(&file, ">ONE Homo sapiens alu\n", alu, 2 * n))
	{
		io::eprintfn("Error writing repeat_fasta to '%s': %s", filename, err);
		return 1;
	}

	AminoAcid[] iub = {
		{0.27, 'a'},
		{0.12, 'c'},
		{0.12, 'g'},
		{0.27, 't'},
		{0.02, 'B'},
		{0.02, 'D'},
		{0.02, 'H'},
		{0.02, 'K'},
		{0.02, 'M'},
		{0.02, 'N'},
		{0.02, 'R'},
		{0.02, 'S'},
		{0.02, 'V'},
		{0.02, 'W'},
		{0.02, 'Y'}};

	if (catch err = random_fasta(&file, ">TWO IUB ambiguity codes\n", iub, 3 * n))
	{
		io::eprintfn("Error writing random_fasta to '%s': %s", filename, err);
		return 1;
	}

	AminoAcid[] homo = {{0.3029549426680, 'a'}, {0.1979883004921, 'c'}, {0.1975473066391, 'g'}, {0.3015094502008, 't'}};

	if (catch err = random_fasta(&file, ">THREE Homo sapiens frequency\n", homo, 5 * n))
	{
		io::eprintfn("Error writing random_fasta to '%s': %s", filename, err);
		return 1;
	}

	if (catch err = file.close())
	{
		io::eprintfn("Unable to close file '%s': %s", filename, err);
		return 1;
	}
	return 0;
}
