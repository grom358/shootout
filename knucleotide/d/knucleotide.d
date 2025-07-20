import std.stdio;
import std.string;
import std.algorithm;
import std.range;

int[string] countNucleotides(string data, size_t k) {
    int[string] counts;
    size_t endIndex = data.length - k;
    for (size_t i = 0; i <= endIndex; ++i) {
        auto fragment = data[i .. i + k].toLower();
        counts[fragment]++;
    }
    return counts;
}

void printFrequencies(File file, string data, int k) {
    auto counts = countNucleotides(data, k);

    double total = 0;
    foreach (count; counts.byValue)
        total += count;

    auto sortedEntries = counts.byKeyValue.array;
    sort!((a, b) => a.value > b.value)(sortedEntries);

    foreach (entry; sortedEntries) {
        double freq = cast(double)(entry.value) / total * 100;
        file.writeln(format("%s %.3f", entry.key.toUpper(), freq));
    }

    file.writeln();
}

void printSampleCount(File file, string data, string sample) {
    auto counts = countNucleotides(data, sample.length);
    string sampleLower = sample.toLower();
    file.writeln(format("%s\t%s", counts.get(sampleLower, 0), sample));
}

int main(string[] args) {
    if (args.length != 3) {
        stderr.writeln("Usage: ", args[0], " <input.txt> <output.txt>");
        return 1;
    }

    string inputPath = args[1];
    string outputPath = args[2];

    auto inputFile = File(inputPath, "rb");
    auto outputFile = File(outputPath, "wb");

    string line;
    while (!inputFile.eof && (line = inputFile.readln()).length) {
        if (line.startsWith(">THREE"))
            break;
    }

    // Read DNA sequence THREE
    string data;
    while (!inputFile.eof) {
        data ~= inputFile.readln().strip();
    }

    printFrequencies(outputFile, data, 1);
    printFrequencies(outputFile, data, 2);
    printSampleCount(outputFile, data, "GGT");
    printSampleCount(outputFile, data, "GGTA");
    printSampleCount(outputFile, data, "GGTATT");
    printSampleCount(outputFile, data, "GGTATTTTAATT");
    printSampleCount(outputFile, data, "GGTATTTTAATTTATAGT");

    return 0;
}
