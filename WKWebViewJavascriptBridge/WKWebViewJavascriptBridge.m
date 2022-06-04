//
//  WKWebViewJavascriptBridge.m
//  WKWebViewJavascriptBridge
//
//  Created by laole918 on 2022/6/4.
//

#import "WKWebViewJavascriptBridge.h"

#define iOS_Native_InjectJavascript @"iOS_Native_InjectJavascript"
#define iOS_Native_FlushMessageQueue @"iOS_Native_FlushMessageQueue"

@interface WKWebViewJavascriptBridge () <WKScriptMessageHandler, WKWebViewJavascriptBridgeBaseDelegate>
@property (weak, nonatomic) WKWebView * webView;
@property (strong, nonatomic) WKWebViewJavascriptBridgeBase * base;
@end

@implementation WKWebViewJavascriptBridge

- (instancetype)initWithWebView:(WKWebView *)webView {
    if (self == [super init]) {
        self.webView = webView;
        self.base = [[WKWebViewJavascriptBridgeBase alloc] init];
        self.base.delegate = self;
        [self addScriptMessageHandlers];
    }
    return self;
}

-(void)dealloc {
    [self removeScriptMessageHandlers];
    self.base = nil;
    self.webView = nil;
}

+ (void)enableLogging {
    [WKWebViewJavascriptBridgeBase enableLogging];
}

+ (void)setLogMaxLength:(int)length {
    [WKWebViewJavascriptBridgeBase setLogMaxLength:length];
}

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler {
    self.base.messageHandlers[handlerName] = [handler copy];
}

- (void)removeHandler:(NSString*)handlerName {
    [self.base.messageHandlers removeObjectForKey:handlerName];
}

- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [self.base sendData:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)flushMessageQueue {
    [self.webView evaluateJavaScript:@"WKWebViewJavascriptBridge._fetchQueue();" completionHandler:^(id result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"WKWebViewJavascriptBridge: WARNING: Error when trying to fetch data from WKWebView: %@", [error description]);
        }
        [self.base flushMessageQueue:result];
    }];
}

- (void)addScriptMessageHandlers {
    [self.webView.configuration.userContentController addScriptMessageHandler:[[LeakAvoider alloc] initWithDelegate:self] name:iOS_Native_InjectJavascript];
    [self.webView.configuration.userContentController addScriptMessageHandler:[[LeakAvoider alloc] initWithDelegate:self] name:iOS_Native_FlushMessageQueue];
}

- (void)removeScriptMessageHandlers {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:iOS_Native_InjectJavascript];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:iOS_Native_FlushMessageQueue];
}

- (void) _evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqual:iOS_Native_FlushMessageQueue]) {
        [self flushMessageQueue];
    }
    
    if ([message.name isEqual:iOS_Native_InjectJavascript]) {
        [self.base injectJavascriptFile];
    }
}

@end

@implementation LeakAvoider

- (instancetype)initWithDelegate:(id) delegate {
    if (self == [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
