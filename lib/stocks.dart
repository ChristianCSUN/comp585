// To parse this JSON data, do
//
//     final stocks = stocksFromJson(jsonString);

import 'dart:convert';

Stocks stocksFromJson(String str) => Stocks.fromJson(json.decode(str));

String stocksToJson(Stocks data) => json.encode(data.toJson());

class Stocks {
  final List<Datum> data;

  Stocks({
    required this.data,
  });

  factory Stocks.fromJson(Map<String, dynamic> json) => Stocks(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final int id;
  final String stockName;
  final String stockSymbol;
  final String stockImage;

  Datum({
    required this.id,
    required this.stockName,
    required this.stockSymbol,
    required this.stockImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    stockName: json["stockName"],
    stockSymbol: json["stockSymbol"],
    stockImage: json["stockImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "stockName": stockName,
    "stockSymbol": stockSymbol,
    "stockImage": stockImage,
  };
}
