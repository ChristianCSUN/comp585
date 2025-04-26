import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketstackService{
  final String apiKey = "ffc563032e13963ddd9ef6343c78dcd9";
  
  Future <List<Map <String, dynamic>>> fetchPopularMarkets() async {
    List<List<String>> marketInfo = [["GSPC.INDX", "S&P 500"],["DJI.INDX", "DOW"], ["IXIC.INDX","NASDAQ"], ["RUT.INDX","RUSSELL 2000"], ["RUI.INDX","RUSSELL 1000"]];
    List<Map<String, dynamic>> markets = [];
    
    for (List info in marketInfo){
      try{
        final marketData = await fetchMarketData(info[0], info[1]);
        markets.add({
          ...marketData,
        });
      }catch(error){
        print("Failed to fetch data for symbol ${info[0]}");
      }
    }
    return markets;
  }

  // getting current data on a stock / market
  Future <Map<String, dynamic>> fetchMarketData(String symbol, String name) async {
    final url = Uri.parse(
      "https://api.marketstack.com/v2/eod?access_key=$apiKey&symbols=$symbol&limit=2"
    );
    final response = await http.get(url);

    if(response.statusCode == 200){
      print("single market fetch: ${response.body}");
      final data = jsonDecode(response.body)["data"];
      if(data.length < 2){
        throw Exception("Not enough data to calculate percentage change");
      } 
      double currentClose = double.tryParse(data[0]["close"].toString()) ?? 0.0;
      double previousClose = double.tryParse(data[1]["close"].toString()) ?? 0.0;
      final historicalData = await fetchHistoricalClosingData(symbol);
      List<double> graphData = historicalData[0];
      double averageVolume = calcVolumeAverage(historicalData[1]);
      print("name.isEmpty: ${name.isEmpty}");
      if(name.isEmpty){
        name = data[0]["name"] ?? data[1]["name"] ?? "Unknown";
      }
      
      return {
        "name": name,
        "symbol" : data[0]["symbol"] ?? "Unknown",
        "currentValue" : double.parse(currentClose.toStringAsFixed(2)),
        "percentageChange" : double.parse(calcPercentageChange(previousClose, currentClose).toStringAsFixed(2)),
        "graphData": graphData.isNotEmpty ? graphData : [0.0],
        "open" : double.tryParse(data[0]["open"].toString()) ?? 0.0,
        "high" : double.tryParse(data[0]["high"].toString()) ?? 0.0,
        "low" : double.tryParse(data[0]["low"].toString()) ?? 0.0,
        "previousClose" : previousClose,
        "volume" : double.tryParse(data[0]["volume"].toString()) ?? 0.0,
        "avgVolume" : averageVolume,
      };
    }else{
      throw Exception("Failed to fetch data for symbol $symbol");
    }
  }

  // getting historical closing data on a stock / market
  Future <List<List<double>>> fetchHistoricalClosingData(String symbol) async {
    final url = Uri.parse(
      "https://api.marketstack.com/v2/eod?access_key=$apiKey&symbols=$symbol&limit=30"
    );
    final response = await http.get(url);

    if(response.statusCode == 200){
      print("History fetch: ${response.body}"); 
      final data = jsonDecode(response.body)["data"];
      List<double> closeData = [];
      List<double> volumeData = [];
      List<List<double>> historicalData = [];

      if(data != null){
        for (var entry in data){

          closeData.add(double.tryParse(entry["close"].toString()) ?? 0.0);
          volumeData.add(double.tryParse(entry["volume"].toString()) ?? 0.0);
        }
        historicalData.add(closeData.reversed.toList());
        historicalData.add(volumeData.reversed.toList());
        return historicalData;
      }else{
        throw Exception("No historical data found for symbol $symbol");
      }
    }else{
      throw Exception("Failed to fetch historical data for symbol $symbol");
    }
  }

  double calcPercentageChange(double previousClose, double currentClose){
    double change = ((currentClose - previousClose) / previousClose ) * 100; 
    return double.parse(change.toStringAsFixed(2));
  }

  double calcVolumeAverage(List<double> volumes){
      double average =  volumes.reduce((a,b) => a + b) / volumes.length;
      return double.parse(average.toStringAsFixed(2));
  }

}