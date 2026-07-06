import std::io;

fn int main(String[] args)
{
	if (args.len != 3)
	{
		io::eprintfn("Usage: %s <size> <output.pbm>", args[0]);
		return 1;
	}

	int iterations = 50;
	double limit_sq = 4.0;
	double zr, zi, cr, ci, tr, ti;

	int w = args[1].to_int() ?? 0;
	int h = w;

	String output_path = args[2];
	File? fout = file::open(output_path, "wb");
	if (catch err = fout)
	{
		io::eprintfn("Failed to open output file '%s': %s", output_path, err);
		return 1;
	};
	defer fout.close();
	OutStream out = &fout;

	io::fprintfn(out, "P4\n%d %d", w, h);

	int bit_num = 0;
	char byte_acc = 0;

	for (int y = 0; y < h; ++y)
	{
		ci = (2.0 * y / h - 1.0);
		for (int x = 0; x < w; ++x)
		{
			zr = zi = tr = ti = 0.0;
			cr = (2.0 * x / w - 1.5);

			for (int i = 0; i < iterations && (tr + ti <= limit_sq); ++i)
			{
				zi = 2.0 * zr * zi + ci;
				zr = tr - ti + cr;
				tr = zr * zr;
				ti = zi * zi;
			}

			byte_acc <<= 1;
			if (tr + ti <= limit_sq)
			{
				byte_acc |= 0x01;
			}

			++bit_num;

			if (bit_num == 8)
			{
				if (catch err = out.write_byte(byte_acc))
				{
					io::eprintfn("Error writing to '%s': %s", output_path, err);
					return 1;
				}
				byte_acc = 0;
				bit_num = 0;
			}
			else if (x == w - 1)
			{
				byte_acc <<= (8 - w % 8);
				if (catch err = out.write_byte(byte_acc))
				{
					io::eprintfn("Error writing to '%s': %s", output_path, err);
					return 1;
				}
				byte_acc = 0;
				bit_num = 0;
			}
		}
	}

	return 0;
}
