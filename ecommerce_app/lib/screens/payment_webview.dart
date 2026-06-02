import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/utils/snackbar_helper.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({super.key, required this.paymentUrl});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print('PAGE START: $url');
          },

          onPageFinished: (url) {
            print('PAGE FINISH: $url');
          },

          onNavigationRequest: (NavigationRequest request) {
            print('NAVIGATE: ${request.url}');

            // SUCCESS URL
            if (request.url.contains('payment-success')) {
              showAppSnackBar(
                context,
                const SnackBar(content: Text('Payment Success')),
              );

              Navigator.pop(context, true);

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoMo Payment')),

      body: WebViewWidget(controller: controller),
    );
  }
}
