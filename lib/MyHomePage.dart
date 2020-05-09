
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Utilities/Constant.dart';
import 'package:mobile/Utilities/ProgressHud.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Utilities/Tools.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  bool _isLoading = true;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ProgressHud(
        inAsyncCall: _isLoading,
        opacity: 0.0,
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              WebView(
                initialUrl: Constant.urlMicrosoftLearnFR,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet(),

                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    Tools.logCat('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  Tools.logCat('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  Tools.logCat('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  Tools.logCat('Page finished loading: $url');
                  setState(() {
                    _isLoading = false;
                  });
                },
                gestureNavigationEnabled: true,
              )
            ],
          ),
        ),
      )
//      Builder(builder: (BuildContext context) {
//        return Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                'You have pushed the button this many times:',
//              ),
//              Text(
//                '$_counter',
//                style: Theme.of(context).textTheme.display1,
//              ),
//            ],
//          ),
//        );
//      }),

      /*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),*/
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), */// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  void pageFinishedLoading(String url) {
    setState(() {
      _isLoading = false;
    });
  }
}
