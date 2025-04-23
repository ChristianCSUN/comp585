class MarketData {
  final String name;
  final String symbol;
  final double currentValue;
  final double percentageChange;
  final List<double> graphData;

  MarketData({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.percentageChange,
    required this.graphData,
  });

  factory MarketData.fromApi(Map<String, dynamic> data, List<double> historicalData){
    return MarketData(
      name: data["name"] ?? "Unknown",
      symbol: data["symbol"] ?? "Unknown",
      currentValue: double.tryParse(data["currentValue"]?.toString() ?? "0.0") ?? 0.0,
      percentageChange: double.tryParse(data["percentageChange"]?.toString() ?? "0.0") ??  0.0,
      graphData: historicalData.isNotEmpty ? historicalData : [0.0],
    );
  }
}