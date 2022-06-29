//
//  ViewController.m
//  WKWebViewJavascriptBridgeDemo
//
//  Created by laole918 on 2022/6/4.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"

@interface ViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView * webView;
@property (strong, nonatomic) WKWebViewJavascriptBridge * bridge;
@property (strong, nonatomic) UIButton * callbackBtn;
@property (strong, nonatomic) UIButton * reloadBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup webView
    self.webView = [[WKWebView alloc] init];
    self.webView.frame = self.view.bounds;
    self.webView.navigationDelegate = self;
    [self.view addSubview: self.webView];
    
    // setup btns
    self.callbackBtn = [[UIButton alloc] init];
    self.callbackBtn.backgroundColor = [UIColor colorWithRed:255.0/255 green:166.0/255 blue:124.0/255 alpha:1.0];
    [self.callbackBtn setTitle:@"Call Handler" forState:UIControlStateNormal];
    [self.callbackBtn addTarget:self action:@selector(callHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.callbackBtn aboveSubview:self.webView];
    self.callbackBtn.frame = CGRectMake(10, UIScreen.mainScreen.bounds.size.height - 80, UIScreen.mainScreen.bounds.size.width * 0.4, 35);
    self.reloadBtn = [[UIButton alloc] init];
    self.reloadBtn.backgroundColor = [UIColor colorWithRed:216.0/255 green:103.0/255 blue:216.0/255 alpha:1.0];
    [self.reloadBtn setTitle:@"Reload WebView" forState:UIControlStateNormal];
    [self.reloadBtn addTarget:self action:@selector(reloadWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.reloadBtn aboveSubview:self.webView];
    self.reloadBtn.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width * 0.6 - 10, UIScreen.mainScreen.bounds.size.height - 80, UIScreen.mainScreen.bounds.size.width * 0.4, 35);
    
    // setup bridge
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [[WKWebViewJavascriptBridge alloc] initWithWebView:self.webView];
    [self.bridge registerHandler:@"testiOSCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testiOSCallback called: %@", data);
        responseCallback(@"Response from testiOSCallback");
    }];
    [self.bridge callHandler:@"testJavascriptHandler" data:@{@"foo": @"before ready"} responseCallback:nil];
}

-(void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    [self loadDemoPage];
}

-(void)loadDemoPage {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"html"];
    NSString* pageHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.webView loadHTMLString:pageHtml baseURL:baseURL];
}

- (void)callHandler {
    WVJBMessage * data = @{@"greetingFromiOS": @"Hi there, JS!"};
    [self.bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id responseData) {
        NSLog(@"testJavascriptHandler responded: %@", responseData);
    }];
}

- (void)reloadWebView {
    [self.webView reload];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

@end
