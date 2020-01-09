import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

const WEB_LINK = 'https://en.wikipedia.org/wiki/Kraken';
const APP_TITLE = 'WebSite Browser';

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture): assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
             future: _webViewControllerFuture,
             builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
                         final bool webViewReady = snapshot.connectionState == ConnectionState.done;
                         final WebViewController controller = snapshot.data;
                         return Row(
                                  children: <Widget>[
                                               IconButton(
                                                  icon: const Icon(Icons.arrow_back_ios),
                                                  onPressed: !webViewReady
                                                                ? null
                                                                : () => navigate(context, controller, goBack: true),
                                               ),
                                               IconButton(
                                                  icon: const Icon(Icons.arrow_forward_ios),
                                                  onPressed: !webViewReady
                                                                ? null
                                                                : () => navigate(context, controller, goBack: false),
                                               ),
                                             ],
                                );
                      },
           );
  }

  navigate(BuildContext context, WebViewController controller, {bool goBack: false}) async {
    bool canNavigate = goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
       goBack ? controller.goBack() : controller.goForward();
    } 
    else 
    {
      Scaffold.of(context).showSnackBar(
        SnackBar( content: Text("No ${goBack ? 'back' : 'forward'} history item")),
      );
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<WebViewController> _webViewController = Completer<WebViewController>();

  Widget buildAppBar(BuildContext context) {
     return AppBar(
              title: const Text(APP_TITLE),
              elevation: 0, // when elevation equal to 0, no border will be drawed.
              // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
              actions: <Widget>[ NavigationControls(_webViewController.future),      /// ?
                       ],
            );
            
  }
 
  Widget buildWebView(BuildContext context) {
     return WebView(
              initialUrl: WEB_LINK,
              javascriptMode: JavascriptMode.unrestricted,  // allow javaScript in WebView
              onWebViewCreated: (WebViewController webViewController) {
                                  _webViewController.complete(webViewController);  /// what is complete?
                                },
            );
  }

  Widget buildBody(BuildContext context) {
     return Stack(
               alignment : AlignmentDirectional.topStart,
               textDirection: TextDirection.ltr,
               fit : StackFit.loose,
               overflow : Overflow.clip,
               children : <Widget>[
                            buildWebView(context),
                            Positioned(
                              height: 40,
                              left: 0,
                              right: 0,
                              top: 0,
                              child: Container(
                                       color: Colors.blue, 
                                     ),
                            ),
                          ]
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
             appBar: buildAppBar(context),
             body:   buildBody(context),
           );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
                  title: 'Welcome to Flutter',
                  home: MyHomePage(), 
               );
  }
}

void main() => runApp(new MyApp());

