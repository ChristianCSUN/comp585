import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MarketstackService{
  final String apiKey = "ffc563032e13963ddd9ef6343c78dcd9";
  
  Future <List<Map <String, dynamic>>> fetchPopularMarkets() async {
    List<List<String>> marketInfo = [
      ["GSPC.INDX", "S&P 500"],
      ["DJI.INDX", "Dow Jones Industrial Average"], 
      ["IXIC.INDX","NASDAQ Composite"], 
      ["AAPL",""], 
      ["MSFT",""]
    ];

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

  Future <List<List<dynamic>>> fetchHistoricalClosingDataWithLimit(String symbol, int limit) async {
    final url = Uri.parse(
      "https://api.marketstack.com/v2/eod?access_key=$apiKey&symbols=$symbol&limit=$limit"
    );
    final response = await http.get(url);

    if(response.statusCode == 200){
      print("History fetch: ${response.body}"); 
      final data = jsonDecode(response.body)["data"];
      List<double> closeData = [];
      List<String> dates = [];
      List<List<dynamic>> historicalData = [];

      if(data != null){
        for (var entry in data){

          closeData.add(double.tryParse(entry["close"].toString()) ?? 0.0);
          dates.add(DateFormat('MMMMd').format(DateTime.parse(entry["date"].toString())));
        }
        historicalData.add(closeData.reversed.toList());
        historicalData.add(dates.reversed.toList());
        return historicalData;
      }else{
        throw Exception("No historical data found for symbol $symbol");
      }
    }else{
      throw Exception("Failed to fetch historical data for symbol $symbol");
    }
  }

  Future <List<List<dynamic>>> fetchYTDClosingData(String symbol) async {
    String jan1 = DateFormat("yyyy-MM-dd").format(DateTime(DateTime.now().year, 1, 1));
    String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final url = Uri.parse(
      "https://api.marketstack.com/v2/eod?access_key=$apiKey&symbols=$symbol&date_from=$jan1&date_to=$today"
    );
    final response = await http.get(url);

    if(response.statusCode == 200){
      print("History fetch: ${response.body}"); 
      final data = jsonDecode(response.body)["data"];
      List<double> closeData = [];
      List<String> dates = [];
      List<List<dynamic>> ytdData = [];

      if(data != null){
        for (var entry in data){

          closeData.add(double.tryParse(entry["close"].toString()) ?? 0.0);
          dates.add(DateFormat('MMMMd').format(DateTime.parse(entry["date"].toString())));
        }
        ytdData.add(closeData.reversed.toList());
        ytdData.add(dates.reversed.toList());
        return ytdData;
      }else{
        throw Exception("No historical data found for symbol $symbol");
      }
    }else{
      throw Exception("Failed to fetch historical data for symbol $symbol");
    }
  }
  
  Future <List<List<dynamic>>> fetchIntradayData(String symbol) async {
    // gets todays date if its a weekday, and gets the past fridays date if its a weekend
    String date = DateTime.now().weekday >= DateTime.monday && DateTime.now().weekday <= DateTime.friday 
                ? DateFormat("yyyy-MM-dd").format(DateTime.now()) 
                : DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(Duration(days: DateTime.now().weekday - DateTime.friday)));
    final intradayUrl = Uri.parse(
      "https://api.marketstack.com/v2/intraday/$date?access_key=$apiKey&symbols=$symbol&interval=15min"
    );
    final eodUrl = Uri.parse(
      "https://api.marketstack.com/v2/eod?access_key=$apiKey&symbols=$symbol&limit=2"
    );

    try{
      final intradayResponse = await http.get(intradayUrl);
      List<double> graphData = [];
      List<String> times = [];
      List<List<dynamic>> dayData = [];

      if(intradayResponse.statusCode == 200){
        print("intraday fetch: ${intradayResponse.body}"); 
        final data = jsonDecode(intradayResponse.body)["data"];
        
        if(data != null && data.isNotEmpty){
          for (var entry in data){
            graphData.add(double.tryParse(entry["close"].toString()) ?? 0.0);
            times.add(DateFormat('hh:mm a').format(DateTime.parse(entry["date"].toString())));
          }
          dayData.add(graphData.reversed.toList());
          dayData.add(times.reversed.toList());
          return dayData;
        }
      }
      final eodResponse = await http.get(eodUrl);
      if(eodResponse.statusCode == 200){
        final eodData = jsonDecode(eodResponse.body)["data"];
        if(eodData != null && eodData.isNotEmpty){
           double currentClose = double.tryParse(eodData[0]["close"].toString()) ?? 0.0;
           double previousClose = double.tryParse(eodData[1]["close"].toString()) ?? 0.0;
           double open = double.tryParse(eodData[0]["open"].toString()) ?? 0.0;
           double high = double.tryParse(eodData[0]["high"].toString()) ?? 0.0;
           double low = double.tryParse(eodData[0]["low"].toString()) ?? 0.0;
           graphData.add(currentClose);
           graphData.add(high);
           graphData.add(low);
           graphData.add(open);
           graphData.add(previousClose);
           times.add("Current");
           times.add("High");
           times.add("Low");
           times.add("Open");
           times.add("Previous");
           dayData.add(graphData.reversed.toList());
           dayData.add(times.reversed.toList());
           return dayData;
        }
      }
      return [];
    }catch(error){
      print("Error getting graph data for 1 day: $error");
      return[];
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
