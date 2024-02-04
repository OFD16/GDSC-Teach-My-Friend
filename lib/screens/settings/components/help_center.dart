import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  var privacyPolicyController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'https://www.privacypolicies.com/live/ee27757d-c7f9-492c-9b31-a9decd998902'));

  var termsOfUseController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        "https://www.privacypolicies.com/live/a0ba44c6-fa2d-41b4-ad0d-9a5224a45700"));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Help Center",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const ExpansionTile(
          title: Text("FAQ"),
          trailing: Icon(Icons.arrow_forward_ios),
          children: [
            ListTile(
              title: Text("How to use the app?"),
              subtitle: Text(
                  "You can use the app by following the instructions provided in the app. If you have any questions, you can contact us."),
            ),
            ListTile(
              title: Text("How to get coupons?"),
              subtitle: Text(
                  "You can get coupons by participating in our promotions and events. You can also get coupons by referring your friends."),
            ),
          ],
        ),
        const ExpansionTile(
          title: Text("Contact Us"),
          trailing: Icon(Icons.arrow_forward_ios),
          children: [
            ListTile(
              title: Text("Email"),
              subtitle: Text("sharey.info@gmail.com"),
            ),
            ListTile(
              title: Text("Phone"),
              subtitle: Text("+1 123 456 7890"),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text("Privacy Policy"),
          trailing: const Icon(Icons.arrow_forward_ios),
          children: [
            const ListTile(
              title: Text("We care about your privacy!"),
              subtitle: Text(
                  "We do not share your personal information with anyone. We only use your information to provide you with the best service."),
            ),
            ListTile(
              title: const Text("Privacy Policy Details"),
              subtitle: RichText(
                text: TextSpan(
                  text: "You can read our privacy policy ",
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: "here",
                      mouseCursor: MaterialStateMouseCursor.clickable,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Open in-app web view here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewWidget(
                                  controller: privacyPolicyController),
                            ),
                          );
                        },
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text("Terms of Service"),
          trailing: const Icon(Icons.arrow_forward_ios),
          children: [
            const ListTile(
              title: Text("Using app terms and conditions"),
              subtitle: Text(
                  "You must agree to our terms and conditions to use the app."),
            ),
            ListTile(
              title: const Text("Terms of Service Details"),
              subtitle: RichText(
                  text: TextSpan(
                text: "You can read our terms of service ",
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: "here",
                    mouseCursor: MaterialStateMouseCursor.clickable,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Open in-app web view here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WebViewWidget(controller: termsOfUseController),
                          ),
                        );
                      },
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ],
    );
  }
}

// class InAppWebViewPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final webUri = WebUri.uri(Uri.parse(
//         'https://www.privacypolicies.com/live/ee27757d-c7f9-492c-9b31-a9decd998902'));

//     return InAppWebView(
//       initialUrlRequest: URLRequest(url: WebUri("https://inappwebview.dev/")),
//     );
//   }
// }
