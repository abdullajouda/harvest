import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:harvest/customer/models/orders.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Wallet/wallet.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'Basket/basket.dart';
import 'Basket/order_done.dart';

class WebViewExample extends StatefulWidget {
  final String url;
  final Order order;
  final String path;

  WebViewExample({Key key, this.url, this.order, this.path}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  onButtonClicked() {
    flutterWebviewPlugin.close();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDone(
            order: widget.order,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.launch(widget.url);
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      // print(url);
      if (url.contains('fail')) {
        flutterWebviewPlugin.close();
        if (widget.path == 'wallet') {
          Navigator.of(context, rootNavigator: true)
              .pushReplacement(MaterialPageRoute(
            builder: (context) => Wallet(),
          ));
        } else {
          Navigator.of(context, rootNavigator: true)
              .pushReplacement(MaterialPageRoute(
            builder: (context) => Basket(),
          ));
        }
      } else if (url.contains('success')) {
        if (widget.path == 'wallet') {
          flutterWebviewPlugin.close();
          Navigator.of(context, rootNavigator: true)
              .pushReplacement(MaterialPageRoute(
            builder: (context) => Wallet(),
          ));
        } else {
          onButtonClicked();
        }
      }
    });
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: WebviewScaffold(
        url: widget.url,
        withZoom: true,
      ),
    );
  }
}
