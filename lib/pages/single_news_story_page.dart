import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../components/menu_drawer.dart';

class SingleNewsStoryPage extends StatefulWidget {
  final String storyUrl;
  const SingleNewsStoryPage({super.key, required this.storyUrl});

  @override
  State<SingleNewsStoryPage> createState() => _SingleNewsStoryPageState();
}

class _SingleNewsStoryPageState extends State<SingleNewsStoryPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.storyUrl));
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
      body: WebViewWidget(controller: _controller),
    );
  }
}