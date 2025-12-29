import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../core/constants/app_constants.dart';
import '../../widgets/loading_overlay.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _webViewController;
  late PullToRefreshController _pullToRefreshController;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _initializePullToRefresh();
  }

  void _initializePullToRefresh() {
    _pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (_webViewController != null) {
          if (Platform.isAndroid) {
            _webViewController!.reload();
          } else if (Platform.isIOS) {
            var currentUrl = await _webViewController!.getUrl();
            _webViewController!.loadUrl(
              urlRequest: URLRequest(url: currentUrl),
            );
          }
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_webViewController != null) {
      bool canGoBack = await _webViewController!.canGoBack();
      if (canGoBack) {
        _webViewController!.goBack();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(AppConstants.webViewUrl),
                ),
                pullToRefreshController: _pullToRefreshController,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStop: (controller, url) {
                  _pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                  return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED,
                  );
                },
              ),
              if (_progress < 1.0) LoadingOverlay(progress: _progress),
            ],
          ),
        ),
      ),
    );
  }
}
