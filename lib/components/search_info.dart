class SearchInfo {
  final String name;
  final String symbol;

  SearchInfo({required this.name, required this.symbol});

  factory SearchInfo.fromLine(String line) {
    final parts = line.split(',');

    if (parts.length < 2) {
      throw FormatException("Invalid line format: $line");
    }


    return SearchInfo(
      name: parts[0].trim(),
      symbol: parts[1].trim(),
    );
  }
}