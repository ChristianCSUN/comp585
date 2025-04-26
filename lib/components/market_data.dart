class MarketData {
  final String name;
  final String symbol;
  final double currentValue;
  final double percentageChange;
  final List<double> graphData;
  final double open;
  final double high;
  final double low;
  final double previousClose;
  final double volume;
  final double avgVolume;

  MarketData({
    required this.name,
    required this.symbol,
    required this.currentValue,
    required this.percentageChange,
    required this.graphData,
    required this.open,
    required this.high,
    required this.low,
    required this.previousClose,
    required this.volume,
    required this.avgVolume,
  });

  factory MarketData.fromApi(Map<String, dynamic> data){
    return MarketData(
      name: data["name"] ?? "Unknown",
      symbol: data["symbol"] ?? "Unknown",
      currentValue: double.tryParse(data["currentValue"]?.toString() ?? "0.0") ?? 0.0,
      percentageChange: double.tryParse(data["percentageChange"]?.toString() ?? "0.0") ??  0.0,
      graphData: data["graphData"]?.isNotEmpty ? List<double>.from(data["graphData"]) : [0.0],
      open:  double.tryParse(data["open"]?.toString() ?? "0.0") ?? 0.0,
      high: double.tryParse(data["high"]?.toString() ?? "0.0") ?? 0.0,
      low: double.tryParse(data["low"]?.toString() ?? "0.0") ?? 0.0,
      previousClose: double.tryParse(data["previousClose"]?.toString() ?? "0.0") ?? 0.0,
      volume: double.tryParse(data["volume"]?.toString() ?? "0.0") ?? 0.0,
      avgVolume: double.tryParse(data["avgVolume"]?.toString() ?? "0.0") ?? 0.0,
    );
  }
}