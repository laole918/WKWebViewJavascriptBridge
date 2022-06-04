//
//  WKWebViewJavascriptBridgeBase.h
//  WKWebViewJavascriptBridge
//
//  Created by laole918 on 2022/6/4.
//

#import <Foundation/Foundation.h>

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);
typedef NSDictionary WVJBMessage;

@protocol WKWebViewJavascriptBridgeBaseDelegate <NSObject>
- (void)_evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError * error))completionHandler;
@end

@interface WKWebViewJavascriptBridgeBase : NSObject

@property (weak, nonatomic) id <WKWebViewJavascriptBridgeBaseDelegate> delegate;
@property (strong, nonatomic) NSMutableArray* startupMessageQueue;
@property (strong, nonatomic) NSMutableDictionary* responseCallbacks;
@property (strong, nonatomic) NSMutableDictionary* messageHandlers;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;
- (void)reset;
- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName;
- (void)flushMessageQueue:(NSString *)messageQueueString;
- (void)injectJavascriptFile;

@end
