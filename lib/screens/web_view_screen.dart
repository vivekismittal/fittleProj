import 'package:fittle_ai/resources/components/app_loader.dart';
import 'package:fittle_ai/screens/common/custom_loader_screen.dart';
import 'package:fittle_ai/utils/screen_paths.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String url = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: WebViewStack(
        url: url,
      ),
    );
  }
}

class WebViewStack extends StatefulWidget {
  const WebViewStack({super.key, required this.url});
  final String url;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical:48.0),
          child: WebViewWidget(
            controller: controller,
          ),
        ),
        if (loadingPercentage < 100)
          Center(child: darkAppLoader())
      ],
    );
  }
}
