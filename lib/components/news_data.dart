import 'dart:convert';
import 'package:stockappflutter/components/news_article_model.dart';
import 'package:http/http.dart' as http;

class NewsData {
  List<Article> news = [];

  Future<void> getNews() async{
    String url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=dc09338353744bd9a38effa48b78e2a4";

    try{
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        print('Number of articles returned: ${jsonData["articles"].length}');

        if (jsonData['status'] == "ok") {
          jsonData["articles"].forEach((element){

/*
            Debugging stuff
            print("Title: " + element["title"] + "\n");
            print("Description: " + element["description"] + "\n");
            print("URL: " + element["url"] + "\n");
            print("Image: " + element["urlToImage"] + "\n");
            print("Content: " + element["content"] + "\n");
            print("Date: " + element["publishedAt"] + "\n\n\n");
*/

            if (element["urlToImage"] != null && element['description'] != null){
              Article articleModel = Article(
                  title: element["title"] ?? "No title",
                  description: element["description"] ?? "No description",
                  url: element["url"] ?? "No url",
                  urlToImage: element["urlToImage"] ?? "No urlToImage",
                  content: element["content"] ?? "No content",
                  publishedAt: element["publishedAt"] ?? "No publication date"
              );
              news.add(articleModel);
            }
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}