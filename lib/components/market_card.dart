import 'package:flutter/material.dart';
import 'package:stockappflutter/components/market_data.dart';

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
                width: 400,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.market.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          widget.market.symbol,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ]
                    ),
                    SizedBox(width: 50),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CustomPaint(
                        painter: MiniGraphPainter(widget.market.graphData),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.market.percentageChange}%",
                          style: TextStyle(
                            fontSize: 16,
                            color: widget.market.percentageChange > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                        Text(
                          "\$${widget.market.currentValue.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ), 
                        ),
                      ]
                    ),
                    IconButton(
                      icon: toggle ? Icon(
                        Icons.star_outlined,
                        color: Colors.yellow,
                        size: 30,
                      )
                      : Icon(
                          Icons.star_outline,
                          color: Colors.yellow,
                          size: 30,
                        ),
                      tooltip: "Add to Favorites",
                      onPressed: (){
                        setState((){
                          toggle = !toggle;
                        });
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
