import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:wealth_wise/stocks.dart';
import 'package:comp585/stocks.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //To hold response
  late Stocks stocks;
  //data is loaded flag
  bool isDataLoaded = false;
  //error message
  String errorMessage = '';

  //API Call
  Future<Stocks> getDataFromAPI()async{
    Uri url = Uri.parse('https://raw.githubusercontent.com/stibyzal/stocks/refs/heads/main/stocks');
    var response = await http.get(url);
    if (response.statusCode == HttpStatus.ok){
      //ok
      Stocks stocks = stocksFromJson(response.body);
      return stocks;
    }
    else {
      errorMessage = '${response.statusCode}: ${response.body}';
      return Stocks(data: []);
    }
  }

  assignData()async {
    stocks = await getDataFromAPI();
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    // call method
    assignData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WealthWise'),
          centerTitle: true,
        ),
        body: !isDataLoaded ? const Center(child: CircularProgressIndicator(),):
        errorMessage.isNotEmpty ? Center(child: Text(errorMessage)):
        stocks.data.isEmpty ? const Center(child:  Text('No data')):
        ListView.builder(
          itemCount: stocks.data.length,
          itemBuilder: (context, index) => getMyRow(index),)
    );
  }
  
  Widget getMyRow(int index) {
    return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(stocks.data[index].stockImage),
          ),
            //trailing: , 
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stocks.data[index].stockName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Stock: ${stocks.data[index].stockSymbol}'),
              ],
            ))
    );
  }
}
