import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) async {
          // Wait and then click the first short
          await Future.delayed(const Duration(seconds: 3)); // Let the page load
          await _controller.runJavaScript('''
            (function() {
              let firstShort = document.querySelector('ytd-rich-grid-video-renderer a#thumbnail');
              if (firstShort) {
                firstShort.click();
              }
            })();
          ''');
        },
      ))
      ..loadRequest(Uri.parse('https://www.youtube.com/@calm/shorts'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calm Shorts'),
        backgroundColor: Colors.deepPurple,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
