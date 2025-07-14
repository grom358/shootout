#include <algorithm>
#include <iomanip>
#include <fstream>
#include <iostream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>
#include <system_error>

std::unordered_map<std::string_view, int>
countNucleotides(const std::string_view &data, int k) {
  std::unordered_map<std::string_view, int> counts;
  int endIndex = data.length() - k;
  for (int i = 0; i <= endIndex; i++) {
    std::string_view fragment = data.substr(i, k);
    counts[fragment]++;
  }
  return counts;
}

bool sortByValueDesc(const std::pair<std::string_view, int> &a,
                     const std::pair<std::string_view, int> &b) {
  return a.second > b.second;
}

void printFrequencies(std::ostream &out, const std::string &data, int k) {
  std::unordered_map<std::string_view, int> counts = countNucleotides(data, k);
  double total = 0;
  for (const auto &entry : counts) {
    total += entry.second;
  }

  std::vector<std::pair<std::string_view, int>> sortedEntries(counts.begin(),
                                                              counts.end());
  std::sort(sortedEntries.begin(), sortedEntries.end(), sortByValueDesc);

  for (const auto &entry : sortedEntries) {
    double frequency = static_cast<double>(entry.second) / total * 100;
    std::string keyUpper = std::string(entry.first);
    transform(keyUpper.begin(), keyUpper.end(), keyUpper.begin(), ::toupper);
    out << keyUpper << " " << std::fixed << std::setprecision(3)
              << frequency << std::endl;
  }
  out << std::endl;
}

void printSampleCount(std::ostream &out, const std::string &data, const std::string &sample) {
  int k = sample.length();
  std::unordered_map<std::string_view, int> counts = countNucleotides(data, k);
  std::string sampleLower = sample;
  transform(sampleLower.begin(), sampleLower.end(), sampleLower.begin(),
            ::tolower);
  out << counts[sampleLower] << "\t" << sample << std::endl;
}

int main(int argc, char** argv) {
  if (argc < 3) {
    std::cerr << "Usage: " << argv[0] << " <input.txt> <output.txt>" << std::endl;
    return 1;
  }

  const char *input_path = argv[1];
  const char *output_path = argv[2];

  std::ifstream input_file(input_path, std::ios::binary);
  if (!input_file) {
    std::error_code ec(errno, std::generic_category());
    std::cerr << "Failed to open input file '" << input_path << "': " << ec.message() << std::endl;
    return 1;
  }

  std::ofstream output_file(output_path, std::ios::binary);
  if (!output_file) {
    std::error_code ec(errno, std::generic_category());
    std::cerr << "Failed to open output file '" << output_path << "': " << ec.message() << std::endl;
    return 1;
  }

  std::string line;
  while (std::getline(input_file, line)) {
    if (line.find(">THREE") != std::string::npos) {
      break;
    }
  }

  // Extract DNA sequence THREE.
  std::string data;
  while (std::getline(input_file, line)) {
    data += line;
  }

  printFrequencies(output_file, data, 1);
  printFrequencies(output_file, data, 2);
  printSampleCount(output_file, data, "GGT");
  printSampleCount(output_file, data, "GGTA");
  printSampleCount(output_file, data, "GGTATT");
  printSampleCount(output_file, data, "GGTATTTTAATT");
  printSampleCount(output_file, data, "GGTATTTTAATTTATAGT");

  return 0;
}
