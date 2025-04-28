import 'package:flutter/material.dart';
import 'package:stockappflutter/components/market_data.dart';
import 'package:stockappflutter/components/menu_drawer.dart';
import 'package:stockappflutter/components/stats_graph.dart';
import 'package:stockappflutter/utilities/database_utils.dart';

import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Stats extends StatefulWidget{
  final MarketData market;
  const Stats({super.key, required this.market});

  @override
  StatsState createState() => StatsState();
}

class StatsState extends State<Stats>{
  final date = DateFormat("MMMMd").format(DateTime.now());
  bool favToggle = false;
  List<bool> intervalButtonStates = List.generate(6, (index) => index == 2);
  String activeInterval = "1M";
  
  @override
  void initState(){
    super.initState();
    checkFavorite();
  }

  Future<void> checkFavorite() async{
    bool result = await isFavorite(widget.market.symbol);
    if(mounted){
      setState(() {
        favToggle = result;
      });
    }
  }

  var intervals = {
    0 : "1D",
    1 : "5D",
    2 : "1M",
    3 : "6M",
    4 : "YTD",
    5 :  "1Y",
  };

  void toggleButtonState(int index){
    setState(() {
      for(int i = 0; i < intervalButtonStates.length; i++){
        intervalButtonStates[i] = i == index ? !intervalButtonStates[index] : false;
      }
      activeInterval = intervals[index]!;
    });
    debugPrint("${intervals[index]} was pressed");
  }

  @override
  Widget build(BuildContext context){
    double priceChange = widget.market.currentValue - widget.market.previousClose;
    final List<Map<String, String>> marketDetails = [
      {"label" : "Name", "value" : widget.market.name},
      {"label" : "Symbol", "value" : widget.market.symbol},
      {"label" : "Current Price", "value" : widget.market.currentValue.toStringAsFixed(2)},
      {"label" : "Percentage Change", "value" : widget.market.percentageChange.toStringAsFixed(2)},
      {"label" : "Previous Close", "value" : widget.market.previousClose.toStringAsFixed(2)},
      {"label" : "Open", "value" : widget.market.open.toStringAsFixed(2)},
      {"label" : "High", "value" : widget.market.high.toStringAsFixed(2)},
      {"label" : "Low", "value" : widget.market.low.toStringAsFixed(2)},
      {"label" : "Volume", "value" : widget.market.volume.toStringAsFixed(2)},
      {"label" : "Average Volume", "value" : widget.market.avgVolume.toStringAsFixed(2)},
    ];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 40),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: Align(
            alignment: Alignment.centerLeft, 
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                AutoSizeText(
                  "${marketDetails[0]["value"]} (${marketDetails[1]["value"]})",
                  style: TextStyle(fontSize: 20),
                  maxFontSize: 40,
                  minFontSize: 10,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 25),
                ),
               ], 
              ), 
            ),
          )
        ),
      ),
      endDrawer: MenuDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: (){
                    setState(() {
                      favToggle = !favToggle;
                    });
                    favToggle ? addFavorite(widget.market.name, widget.market.symbol) : removeFavorite(widget.market.symbol);
                    debugPrint('Favorites Tapped');
                  },
                  icon: Icon(
                    favToggle ? Icons.star_outlined : Icons.star_outline,
                    color: Colors.yellow, 
                    size: 35,
                  ),
                  label: const AutoSizeText(
                    "Favorite",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black),
                  ),
                  iconAlignment: IconAlignment.start,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: favToggle ? Colors.indigo[100] : Colors.transparent,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ 
                        AutoSizeText(
                          marketDetails[2]["label"]!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxFontSize: 12,
                          minFontSize: 10,
                        ),
                        AutoSizeText(
                          "\$${marketDetails[2]["value"]}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxFontSize: 20,
                          minFontSize: 10,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ 
                        AutoSizeText(
                          "Price Change:",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxFontSize: 12,
                          minFontSize: 10,
                        ),
                        AutoSizeText(
                          priceChange > 0 ? "+${(priceChange).toStringAsFixed(2)}" :  (priceChange).toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: priceChange > 0 ? Colors.green[700] : Colors.red,
                          ),
                          maxFontSize: 20,
                          minFontSize: 10,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AutoSizeText(
                          marketDetails[3]["label"]!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxFontSize: 12,
                          minFontSize: 10,
                        ),                        
                        AutoSizeText(
                          widget.market.percentageChange > 0 ? "(+${marketDetails[3]["value"]}%)" :  "(${marketDetails[3]["value"]}%)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.market.percentageChange > 0 ? Colors.green[700] : Colors.red,
                            backgroundColor: widget.market.percentageChange > 0 ? Colors.green[100] : Colors.red[100]
                          ),
                          maxFontSize: 20,
                          minFontSize: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 15),
                child: Center(
                  child: StatsGraph(
                    interval: activeInterval, 
                    symbol: widget.market.symbol
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 2,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 50,
                child: ListView.builder( 
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index){
                    return OutlinedButton(
                        onPressed: () => toggleButtonState(index),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 16),
                          shape: CircleBorder(),
                          backgroundColor: intervalButtonStates[index] ? Colors.indigo[100] : Colors.transparent,
                        ), 
                        child: AutoSizeText("${intervals[index]}"),
                    );
                  }
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              height: 200,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:ListView.builder( 
                  itemCount: 6,
                  itemBuilder: (context, index){
                    final item = marketDetails[index + 4];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          "${item["label"]!}:",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            ),
                          maxFontSize: 30,
                          minFontSize: 10,
                        ),
                        AutoSizeText(
                          item["value"]!,
                          style: TextStyle(
                            fontSize: 22,
                            ),
                          maxFontSize: 30,
                          minFontSize: 10,
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}