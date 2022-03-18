import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class LiveWebView extends StatefulWidget {
  final String urlString;

  const LiveWebView({Key? key, required this.urlString}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveWebViewState();
  }
}

class _LiveWebViewState extends State<LiveWebView> {

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Center(
          child: WebView(
            initialUrl: widget.urlString,
          ),
        ),
      ),
    );
  }
}
