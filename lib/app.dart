import 'package:flutter/material.dart';
import 'features/webview/presentation/pages/webview_page.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Job',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WebViewPage(),
    );
  }
}
