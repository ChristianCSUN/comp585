import 'package:flutter/material.dart';
import 'package:stockappflutter/components/market_data.dart';
import 'package:stockappflutter/pages/stats.dart';
import 'package:stockappflutter/utilities/database_utils.dart';

import 'package:auto_size_text/auto_size_text.dart';

class MarketCard extends StatefulWidget {
  final MarketData market;
  const MarketCard({super.key, required this.market});

  @override
  MarketCardState createState() => MarketCardState();
}

class MarketCardState extends State<MarketCard> {  
  bool toggle = false;
  List<Color> colors = [Colors.blue, Colors.purple];
  
  @override
  void initState(){
    super.initState();
    checkFavorite();
  }

  Future<void> checkFavorite() async{
    bool result = await isFavorite(widget.market.symbol);
    if(mounted){
      setState(() {
        toggle = result;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card Tapped.');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Stats(market: widget.market))
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width *.9, //400,
                height: MediaQuery.of(context).size.height *.1,//100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            widget.market.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxFontSize: 20,
                            minFontSize: 10,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            wrapWords: true,
                          ),
                          AutoSizeText(
                            widget.market.symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                              maxFontSize: 20,
                              minFontSize: 10,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CustomPaint(
                          painter: MiniGraphPainter(widget.market.graphData),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          "${widget.market.percentageChange}%",
                          style: TextStyle(
                            color: widget.market.percentageChange > 0 ? Colors.green : Colors.red,
                          ),
                          maxFontSize: 20,
                          minFontSize: 10,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          "\$${widget.market.currentValue.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxFontSize: 20,
                          minFontSize: 10,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ),
                    IconButton(
                      icon: Icon(
                         toggle ? Icons.star_outlined : Icons.star_outline,
                        color: Colors.yellow,
                        size: 30,
                      ),
                      tooltip: "Add to Favorites",
                      onPressed: (){
                        setState((){
                          toggle = !toggle;
                        });
                        toggle ? addFavorite(widget.market.name, widget.market.symbol) : removeFavorite(widget.market.symbol);
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MiniGraphPainter extends CustomPainter {
  final List<double> graphData;
  MiniGraphPainter(this.graphData);
  
  @override
  void paint(Canvas canvas, Size size){
    final bool isTrendingUp = graphData.last > graphData.first;
    final paint = Paint()
      ..color = isTrendingUp ? Colors.green : Colors.red 
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final double maxValue = graphData.reduce((a,b) => a > b ? a : b);
    final double minValue = graphData.reduce((a,b) => a < b ? a : b);
    final range = maxValue - minValue;
    
    final double stepX = size.width / (graphData.length - 1);
    
    final List<Offset> points = graphData.asMap().entries.map((entry){
      final index = entry.key;
      final value = entry.value;
      final normalizedY = (value - minValue) / range;
      final offsetY = size.height *  (1 - normalizedY);
      return Offset(stepX * index, offsetY);
    }).toList();
    
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var point in points){
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate){
    return false;
  }
}
