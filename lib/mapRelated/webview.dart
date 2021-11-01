/*import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

import '../main.dart';
import 'map.dart';

class WebView extends StatefulWidget {
  WebView({Key key, this.title, this.url});

  final String title;
  final String url;

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();
  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> _onWillPop(BuildContext context) async {
    print('button pressed');
    activeMapTile = 5;
    setState(() {
      //mapTileSwitchController.add(1);
      redrawLayoutController.add(1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('hello'),
        ),
        body: SafeArea(
            child: EasyWebView(
              src: 'https://www.google.com/maps/d/u/1/embed?mid=1W2PpUT4oZgrJTacKr_LLBK8JTrKSdmBn&ll=' + mapRefPoint.latitude.toString() + '%2C' + mapRefPoint.longitude.toString() + '&z=14',
            ),),
      ),
    );
  }
}*/