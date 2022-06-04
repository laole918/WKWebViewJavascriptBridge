# WKWebViewJavascriptBridge

> This project is inspired by [marcuswestin/WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge) and [Lision/WKWebViewJavascriptBridge](https://github.com/Lision/WKWebViewJavascriptBridge)!

Android Java : [https://github.com/laole918/JsBridge](https://github.com/laole918/JsBridge)

# What Can WKWebViewJavascriptBridge Do?

You can write hybrid modules in just a few lines of code by using WKWebViewJavascriptBridge without the need to be concerned with the underlying messaging implementation.

![](Rources/WKWebViewJavascriptBridgeDemo.gif)

# Features

- **Multi-end Consistency:** This iOS Obj-C version project is a mirror of [marcuswestin/WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)(Obj-C) and [Lision/WKWebViewJavascriptBridge](https://github.com/Lision/WKWebViewJavascriptBridge)(Swift),  so they have the same API design, native code, and the Javascript code is exactly the same.
- **High Performance:** The messaging performance is higher than intercept requests.
- **High Speed:** No need to consider alert box safety timeout.
- **Lightweight:** This framework contains only 3 files.
- **Non-intrusive:** There is no need to make the webview class inherit from other base class.

# Usage

### 1. Instantiate WKWebViewJavascriptBridge with a WebView:

```objectivec
self.bridge = [[WKWebViewJavascriptBridge alloc] initWithWebView:self.webView];
```

### 2. Register a Handler in Native, and Call a JS Handler:

```objectivec
[self.bridge registerHandler:@"testiOSCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
    NSLog(@"testiOSCallback called: %@", data);
    responseCallback(@"Response from testiOSCallback");
}];
[self.bridge callHandler:@"testJavascriptHandler" data:@{@"foo": @"before ready"} responseCallback:nil];
```

### 3. Copy and Paste setupWKWebViewJavascriptBridge into Your JS:

```js
function setupWKWebViewJavascriptBridge(callback) {
    if (window.WKWebViewJavascriptBridge) { return callback(WKWebViewJavascriptBridge); }
    if (window.WKWVJBCallbacks) { return window.WKWVJBCallbacks.push(callback); }
    window.WKWVJBCallbacks = [callback];
    /* For Android: Mock messageHandlers in iOS, Keep double-ended code consistent. */
    if (!window.webkit) {
        window.webkit = {};
        window.webkit.messageHandlers = {};
        window.webkit.messageHandlers.iOS_Native_InjectJavascript = window.iOS_Native_InjectJavascript;
        window.webkit.messageHandlers.iOS_Native_FlushMessageQueue = window.iOS_Native_FlushMessageQueue;
    }
    window.webkit.messageHandlers.iOS_Native_InjectJavascript.postMessage(null)
}
```

### 4. Finally, Call setupWKWebViewJavascriptBridge and then Use The Bridge to Register Handlers and Call Native Handlers:

```js
setupWKWebViewJavascriptBridge(function(bridge) {
    /* Initialize your app here */
    bridge.registerHandler('testJavascriptHandler', function(data, responseCallback) {
        console.log('iOS called testJavascriptHandler with', data)
        responseCallback({ 'Javascript Says':'Right back atcha!' })
    })
    bridge.callHandler('testiOSCallback', {'foo': 'bar'}, function(response) {
        console.log('JS got response', response)
    })
})
```

# Installation

Either clone the repo and manually add the Files in [WKWebViewJavascriptBridge](https://github.com/laole918/WKWebViewJavascriptBridge/tree/main/WKWebViewJavascriptBridge).

# Requirements

This framework requires `iOS 9.0+` and `Xcode 9.0+`.
