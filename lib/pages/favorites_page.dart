import 'package:flutter/material.dart';
import 'package:stockappflutter/marketstack_service.dart';
import 'package:stockappflutter/components/market_card.dart';
import 'package:stockappflutter/components/market_data.dart';
import 'package:stockappflutter/components/menu_drawer.dart';
import 'package:stockappflutter/utilities/database_utils.dart';

import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Favorites extends StatefulWidget{
  const Favorites({super.key});

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites>{
  Map<String, Map<String, String>> favorites = {};
  final MarketstackService MSS = MarketstackService();
  late Future<List<MarketData>> _markets;
  final  date = DateFormat('MMMMd').format(DateTime.now());

  @override
  void initState(){
    super.initState();
    fetchUserFavorites((updatedFavorites){
      if(mounted){
        setState((){
          favorites = updatedFavorites;
          _markets = fetchMarkets(favorites);
        });
      }
    });
    _markets = fetchMarkets(favorites);
  }

  Future<List<MarketData>> fetchMarkets(Map<String, Map<String, String>> favorites) async {
    final markets = [];
    for(var favorite in favorites.values){
      final symbol = favorite["symbol"] ?? "Unknown Symbol";
      final name = favorite["name"] ?? "Unknown Name";
      try{
        final market = await MSS.fetchMarketData(symbol, name);
        markets.add(market);
      }catch(error){
        debugPrint("Failed to fetch market data for $symbol: $error");
      }
    }
    return markets.map((market) => MarketData.fromApi(market)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        iconTheme: IconThemeData(size: 40),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Favorites",
                    style: TextStyle(fontSize: 30),
                    maxFontSize: 40,
                    minFontSize: 10,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AutoSizeText(
                    date,
                    style: TextStyle(fontSize: 25),
                    maxFontSize: 30,
                    minFontSize: 10,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
            Divider(
              thickness: 2,
              color: Colors.black,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(height: 15),
            FutureBuilder<List<MarketData>>(
              future: _markets,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if (snapshot.hasError){
                  debugPrint("Error: ${snapshot.error}");
                  return Center(
                    child: Text("Error: ${snapshot.error}")
                  );
                }else if(snapshot.hasData && snapshot.data!.isNotEmpty){
                  final markets = snapshot.data!;
                  return Expanded( 
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
                  );
                }else{
                  return const Center(child: Text("No Favorites Available."));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
