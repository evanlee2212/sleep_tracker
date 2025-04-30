import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    // Set status bar icons to dark (for white background)
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) async {
          await Future.delayed(const Duration(seconds: 3)); // shorter delay

          final result = await _controller.runJavaScriptReturningResult('''
            (function() {
              const elements = document.querySelectorAll('a#thumbnail');
              for (let el of elements) {
                const parent = el.closest('ytd-rich-grid-video-renderer');
                if (parent && parent.innerText.includes("What’s on your reading list")) {
                  window.scrollTo(0, el.getBoundingClientRect().top + window.scrollY - 0);
                  el.click();
                  return "Clicked based on caption";
                }
              }
              return "Caption not found";
            })();
          ''');

          if (result.toString().contains("Caption not found")) {
            await _controller.runJavaScript('''
              window.scrollTo(0, document.body.scrollHeight * 0.1);
              setTimeout(() => {
                const el = document.querySelector('ytd-rich-grid-video-renderer a#thumbnail');
                if (el) el.click();
              }, 0); // fast fallback click
            ''');
          }
        },
      ))
      ..loadRequest(Uri.parse('https://www.youtube.com/@calm/shorts'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calm Shorts',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
