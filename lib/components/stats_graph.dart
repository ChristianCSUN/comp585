import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stockappflutter/marketstack_service.dart';
import 'package:intl/intl.dart';

class StatsGraph extends StatefulWidget{
  final String  interval;
  final String symbol;
  const StatsGraph({super.key, required this.interval, required this.symbol});

  @override
  StatsGraphState createState() => StatsGraphState();
}

class StatsGraphState extends State<StatsGraph>{
  final MarketstackService MSS = MarketstackService();
  late Future<List<List<dynamic>>> _graphData;

  final Map<String, int> intervalToLimit = {
    "1D" : 1,
    "5D": 5,
    "1M": 30,
    "6M" : 180,
    "YTD": -1,
    "1Y": 365,
  };

  @override
  void initState(){
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant StatsGraph oldWidget){
    super.didUpdateWidget(oldWidget);
    if(oldWidget.interval != widget.interval || oldWidget.symbol != widget.symbol){
      _fetchData();
    }
  }

  void _fetchData(){
    setState(() {
      _graphData = fetchGraphData(widget.interval, widget.symbol);
    });
  }

  Future<List<List<dynamic>>> fetchGraphData(String interval, String symbol) async {
    int? limit = intervalToLimit[interval];
    if(limit == null) throw Exception("Invalid interval");
    try{

     return limit == 1 
      ? await MSS.fetchIntradayData(symbol) 
      : limit == -1 
      ? await MSS.fetchYTDClosingData(symbol)
      : await MSS.fetchHistoricalClosingDataWithLimit(symbol, limit);
    }catch(error){
      debugPrint("There was an error getting the graph data: $error");
      return [];
    }
  }
  @override
  Widget build(BuildContext context){
    return Center(
      child: FutureBuilder<List<List<dynamic>>>(
        future: _graphData,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            debugPrint("Error Generating graph: ${snapshot.error}");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  Icon(
                    Icons.error_outline_outlined,
                    color: Colors.grey,
                    size: 40,
                  ),
                  Text("Cannot Display Graph At This Time,"),
                  Text("Please Try Again Later"),
                ],
              ),
            );
          }else if(snapshot.hasData && snapshot.data!.isNotEmpty){
            List<double> graphData = List<double>.from(snapshot.data![0]);
            List<String> xTitles = List<String>.from(snapshot.data![1]);
            List<FlSpot> spots = List.generate(graphData.length, (index) => FlSpot(index.toDouble(), graphData[index]));
            final bool isTrendingUp = graphData.last > graphData.first;
            String? previousTitle;
            
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedSpots){
                          return touchedSpots.map((spot) {
                            int index = spot.x.toInt();
                            if(index >= 0 && index < xTitles.length){
                              return LineTooltipItem(
                                widget.interval == "1D" 
                                ? "${xTitles[index]}\n\$${spot.y.toStringAsFixed(2)}"
                                : "${xTitles[index]}\n\$${spot.y.toStringAsFixed(2)}",
                                TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }
                          }).toList();
                        
                        }
                      ),
                    ),
                    
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta){
                            int index = value.toInt();
                            if(index >= 0 && index < xTitles.length){
                              String currentTitle = xTitles[index];
                              if(previousTitle != currentTitle){
                                previousTitle = currentTitle;
                                return Padding( 
                                  padding: EdgeInsets.only(top:35),
                                  child: Transform.rotate( 
                                    angle: -1.3,
                                    child: widget.interval == "1D" 
                                    ? Text(xTitles[index])
                                    : Text(xTitles[index]),
                                  ),
                                );
                              }
                            }
                            return Text("");
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta){
                            if(value == meta.max || value == meta.min){
                              return const Text("");
                            }
                            return Text(meta.formattedValue);
                          }
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black, width: 4
                        ),
                        left: BorderSide(
                          color: Colors.black, width: 4,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        color: isTrendingUp ? Colors.green : Colors.red,
                        belowBarData: BarAreaData(
                          show: true,
                          color: isTrendingUp ? Colors.green[200] : Colors.red[200],
                        ),
                      ),
                  ],
                  ),
                ),
              ),
            );
          }else{
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  Icon(
                    Icons.error_outline_outlined,
                    color: Colors.grey,
                    size: 40,
                  ),
                  Text("Cannot Display Graph At This Time,"),
                  Text("Please Try Again Later"),
                ],
              ),
            );
          }
        }
      ),
    );
  }
}

