import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../shared/components/constants.dart';
import '../../shared/cubit/news_cubit.dart';
import '../../shared/styles/colors.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({
    Key? key,
    required this.url,
    required this.cubit,
  }) : super(key: key);

  final String url;
  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit.incrementViewedNews();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: TextStyle(
            color: titleColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
