// ignore_for_file: deprecated_member_use

import 'package:cuplex/widget/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'dart:developer';

class CustomWebView extends StatefulWidget {
  final String initialUrl;
  final bool showAppBar;
  final String? errorImageUrl;

  const CustomWebView({
    super.key,
    required this.initialUrl,
    this.showAppBar = false,
    this.errorImageUrl,
  });

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  String url = "";
  double progress = 0;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  bool isError = false;
  bool isLoading = true;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      supportZoom: false,
      transparentBackground: true,
      javaScriptEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      builtInZoomControls: false,
      mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      useWideViewPort: false,
      forceDark: AndroidForceDark.FORCE_DARK_AUTO,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.deepPurple,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
            urlRequest: URLRequest(url: await webViewController?.getUrl()),
          );
        }
      },
    );
  }

  void reloadWebView() {
    setState(() {
      isError = false; // Reset the error state
      isLoading = true; // Set loading state to true when starting to reload
    });
    webViewController?.reload();
  }

  @override
  void dispose() {
    // Reset screen orientation to default when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight - 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  if (isError)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Show error image if available, otherwise show error icon
                        widget.errorImageUrl != null
                            ? Image.network(widget.errorImageUrl!)
                            : const Icon(Icons.error_outline, color: Color(0xffecc877), size: 50),
                        const SizedBox(height: 10),
                        const Text('Failed to load the page', style: TextStyle(color: Color(0xffecc877))),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: reloadWebView,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text("Reload", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  else
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.parse(widget.initialUrl)),
                      ),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onEnterFullscreen: (controller) {
                        // Rotate to landscape mode on fullscreen
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                        ]);
                        debugPrint("Entered fullscreen mode");
                      },
                      onExitFullscreen: (controller) {
                        // Revert to portrait mode on exit fullscreen
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                        debugPrint("Exited fullscreen mode");
                      },
                      onLoadStart: (controller, url) async {
                        setState(() {
                          this.url = url.toString();
                          isError = false; // Reset error state on page load
                          isLoading = true; // Set loading state to true when page starts loading
                        });
                      },
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT,
                        );
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        return NavigationActionPolicy.CANCEL;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController!.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          isLoading = false; // Set loading state to false when page finishes loading
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController!.endRefreshing();
                        setState(() {
                          isError = true; // Set error state when load fails
                          isLoading = false; // Stop loading animation on error
                        });
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        debugPrint(consoleMessage.toString());
                      },
                      onLoadResource: (controller, resource) {
                        final url = resource.url;
                        log(url.toString());
                      },
                    ),
                  // Purple loading screen
                  if (isLoading)
                    CustomShimmer(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}