import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stockappflutter/components/menu_drawer.dart';
import 'package:stockappflutter/components/news_article_model.dart';
import 'package:stockappflutter/components/news_data.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Article> articles = <Article>[];
  bool _loading = true;
  
  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async{
    NewsData newsClass = NewsData();
    await newsClass.getNews();
    print("API Response: ${newsClass.news.length} articles loaded.");  // Print the number of articles
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 40),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: AutoSizeText("News Room",
                style: TextStyle(fontSize: 30),
                maxFontSize: 40,
                minFontSize: 10,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ),
          ),
        ),
      ),
      endDrawer: MenuDrawer(),
      body: _loading
          ? Center(child: CircularProgressIndicator(),)
          : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return ArticleTile(
              imageUrl: articles[index].urlToImage,
              title: articles[index].title,
              desc: articles[index].description,
            );
          },
        ),
      ),
    );
  }
}

class ArticleTile extends StatelessWidget {
  final String imageUrl, title, desc;
  const ArticleTile({super.key, required this.imageUrl, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(imageUrl: imageUrl),
          ),
          SizedBox(height: 8,),
          Text(
            title, style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 2),
          Text(desc, style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),)
        ]
      )
    );
  }
}