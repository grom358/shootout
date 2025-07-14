using System.Text;

class Program {
  static Dictionary<string, int> CountNucleotides(string data, int k) {
    var counts = new Dictionary<string, int>();
    int endIndex = data.Length - k;
    for (int i = 0; i <= endIndex; i++) {
      string fragment = data.Substring(i, k);
      if (!counts.TryAdd(fragment, 1)) {
        counts[fragment]++;
      }
    }
    return counts;
  }

  static void PrintFrequencies(TextWriter writer, string data, int k) {
    var counts = CountNucleotides(data, k);
    double total = counts.Values.Sum();

    foreach (var entry in counts.OrderByDescending(e => e.Value)) {
      double frequency = (double)entry.Value / total * 100;
      writer.WriteLine($"{entry.Key.ToUpper()} {frequency:F3}");
    }
    writer.WriteLine();
  }

  static void PrintSampleCount(TextWriter writer, string data, string sample) {
    int k = sample.Length;
    var counts = CountNucleotides(data, k);
    string sampleLower = sample.ToLower();
    int count = counts.ContainsKey(sampleLower) ? counts[sampleLower] : 0;
    writer.WriteLine($"{count}\t{sample}");
  }

  static void Main(string[] args) {
    if (args.Length != 2) {
      Console.Error.WriteLine("Usage: knucleotide <input.txt> <output.txt>");
      Environment.Exit(1);
    }

    string inputFile = args[0];
    string outputFile = args[1];

    string data;
    using (var reader = new StreamReader(inputFile)) {
      string ? line;
      while ((line = reader.ReadLine()) != null) {
        if (line.StartsWith(">THREE")) {
          break;
        }
      }
      StringBuilder sb = new StringBuilder();
      while ((line = reader.ReadLine()) != null) {
        sb.Append(line);
      }
      data = sb.ToString();
    }

    using (var writer = new StreamWriter(outputFile)) {
      PrintFrequencies(writer, data, 1);
      PrintFrequencies(writer, data, 2);
      PrintSampleCount(writer, data, "GGT");
      PrintSampleCount(writer, data, "GGTA");
      PrintSampleCount(writer, data, "GGTATT");
      PrintSampleCount(writer, data, "GGTATTTTAATT");
      PrintSampleCount(writer, data, "GGTATTTTAATTTATAGT");
      writer.Flush();
    }
  }
}
