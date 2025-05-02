import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../widgets/bg_container.dart';

class EconomicCalendarScreen extends StatelessWidget {
  const EconomicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const htmlContent = '''
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body { margin: 0; padding: 0; }
        </style>
      </head>
      <body>
        <div id="economicCalendarWidget"></div>
        <script async type="text/javascript" data-type="calendar-widget" 
          src="https://www.tradays.com/c/js/widgets/calendar/widget.js?v=12">
          {"width":"100%","height":"600px","mode":"2"}
        </script>
      </body>
    </html>
    ''';

    return BackgroundContainer(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        title: const Text(
        'Economic Calendar',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
    ),
    elevation: 0,
    centerTitle: true,
    ),
    body: WebViewWidget(
        controller: WebViewController()
          ..loadHtmlString(htmlContent)
          ..setJavaScriptMode(JavaScriptMode.unrestricted),
      )) );
  }
}
