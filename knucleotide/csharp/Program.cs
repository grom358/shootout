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

  static void PrintFrequencies(string data, int k) {
    var counts = CountNucleotides(data, k);
    double total = counts.Values.Sum();

    foreach (var entry in counts.OrderByDescending(e => e.Value)) {
      double frequency = (double)entry.Value / total * 100;
      Console.WriteLine($"{entry.Key.ToUpper()} {frequency:F3}");
    }
    Console.WriteLine();
  }

  static void PrintSampleCount(string data, string sample) {
    int k = sample.Length;
    var counts = CountNucleotides(data, k);
    string sampleLower = sample.ToLower();
    int count = counts.ContainsKey(sampleLower) ? counts[sampleLower] : 0;
    Console.WriteLine($"{count}\t{sample}");
  }

  static void Main() {
    string data;
    using (var reader = new StreamReader(Console.OpenStandardInput(),
                                         Console.InputEncoding)) {
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

    PrintFrequencies(data, 1);
    PrintFrequencies(data, 2);
    PrintSampleCount(data, "GGT");
    PrintSampleCount(data, "GGTA");
    PrintSampleCount(data, "GGTATT");
    PrintSampleCount(data, "GGTATTTTAATT");
    PrintSampleCount(data, "GGTATTTTAATTTATAGT");
  }
}
