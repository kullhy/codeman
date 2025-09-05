import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewApp(),
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;

  final url = "https://devu.dentaljob.co.kr/";

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (webViewController != null) {
          if (Platform.isAndroid) {
            webViewController!.reload();
          } else if (Platform.isIOS) {
            var currentUrl = await webViewController!.getUrl();
            webViewController!.loadUrl(
              urlRequest: URLRequest(url: currentUrl),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null) {
          bool canGoBack = await webViewController!.canGoBack();
          if (canGoBack) {
            webViewController!.goBack();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStop: (controller, url) {
              pullToRefreshController.endRefreshing();
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED,
              );
            },
          ),
        ),
      ),
    );
  }
}
