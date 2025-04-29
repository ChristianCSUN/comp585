import 'package:flutter/material.dart';
import 'package:stockappflutter/marketstack_service.dart';
import 'package:stockappflutter/components/menu_drawer.dart';
import 'package:stockappflutter/components/market_card.dart';
import 'package:stockappflutter/components/market_data.dart';
import 'package:intl/intl.dart';
import 'package:stockappflutter/components/search_bar.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final  date = DateFormat('MMMM d, yyyy').format(DateTime.now());
  final MarketstackService MSS = MarketstackService();

  late Future<List<MarketData>> _popularMarkets;

  @override
  void initState(){
    super.initState();
    _popularMarkets = fetchMarkets();
  }

  Future<List<MarketData>> fetchMarkets() async {
    final markets = await MSS.fetchPopularMarkets();
    return markets.map((market) => MarketData.fromApi(market)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Markets',
          style: TextStyle(fontSize: 40),
        ),
        iconTheme: IconThemeData(size: 40),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                date,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      endDrawer: MenuDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
                height: 10
            ),
            FutureBuilder<List<MarketData>>(
              future: _popularMarkets,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if (snapshot.hasError){
                  print(snapshot.error);
                  return Center(
                      child: Text("Error: ${snapshot.error}")
                  );
                }else if(snapshot.hasData){
                  final markets = snapshot.data!;
                  return Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                            child: SearchBarWidget(markets: markets, onChanged: (query){debugPrint("Search query: $query");},),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: markets.length,
                              itemBuilder: (context, index){
                                final market = markets[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: MarketCard(market: market),
                                );
                              },
                            ),
                          )
                        ],
                      )
                  );
                }else{
                  return const Center(child: Text("No market data Available."));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}