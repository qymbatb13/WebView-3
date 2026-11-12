import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLocalPage extends StatefulWidget {
  const WebViewLocalPage({super.key});

  @override
  State<WebViewLocalPage> createState() => _WebViewLocalPageState();
}

class _WebViewLocalPageState extends State<WebViewLocalPage> {
  late final WebViewController _webController;

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'MyJSChannel',
        onMessageReceived: (message) {
          log('Javascript: ${message.message}');
          _showMessage(message.message);
        },
      )
      ..loadFlutterAsset('assets/index.html');
  }

  Future<void> _showMessage(String message) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(message, style: const TextStyle(fontSize: 35)),
        actions: [
          TextButton(
            onPressed: () {
              _webController.runJavaScript('sendOK()');
              Navigator.pop(dialogContext);
            },
            child: const Text('Хорошо'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView Local')),
      body: WebViewWidget(controller: _webController),
    );
  }
}
