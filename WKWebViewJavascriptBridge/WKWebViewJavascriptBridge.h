//
//  WKWebViewJavascriptBridge.h
//  WKWebViewJavascriptBridge
//
//  Created by laole918 on 2022/6/4.
//

#import <Foundation/Foundation.h>
#import "WKWebViewJavascriptBridgeBase.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKScriptMessageHandler.h>

@interface WKWebViewJavascriptBridge : NSObject
+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;

- (instancetype)initWithWebView:(WKWebView *)webView;
- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
@end

@interface LeakAvoider : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak) id delegate;
- (instancetype)initWithDelegate:(id) delegate;
@end
