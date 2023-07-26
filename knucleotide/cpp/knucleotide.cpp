#include <algorithm>
#include <iomanip>
#include <iostream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

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

void printFrequencies(const std::string &data, int k) {
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
    std::cout << keyUpper << " " << std::fixed << std::setprecision(3)
              << frequency << std::endl;
  }
  std::cout << std::endl;
}

void printSampleCount(const std::string &data, const std::string &sample) {
  int k = sample.length();
  std::unordered_map<std::string_view, int> counts = countNucleotides(data, k);
  std::string sampleLower = sample;
  transform(sampleLower.begin(), sampleLower.end(), sampleLower.begin(),
            ::tolower);
  std::cout << counts[sampleLower] << "\t" << sample << std::endl;
}

int main() {
  std::string line;
  while (std::getline(std::cin, line)) {
    if (line.find(">THREE") != std::string::npos) {
      break;
    }
  }

  // Extract DNA sequence THREE.
  std::string data;
  while (std::getline(std::cin, line)) {
    data += line;
  }

  printFrequencies(data, 1);
  printFrequencies(data, 2);
  printSampleCount(data, "GGT");
  printSampleCount(data, "GGTA");
  printSampleCount(data, "GGTATT");
  printSampleCount(data, "GGTATTTTAATT");
  printSampleCount(data, "GGTATTTTAATTTATAGT");

  return 0;
}
