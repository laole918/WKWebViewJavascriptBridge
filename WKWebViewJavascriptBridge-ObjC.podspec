Pod::Spec.new do |s|
  s.name             = 'WKWebViewJavascriptBridge-ObjC'
  s.version          = '1.0.0'
  s.summary          = 'An iOS bridge for sending messages between Obj-C and JavaScript in WKWebViews.'

  s.homepage         = 'https://github.com/laole918/WKWebViewJavascriptBridge'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'laole918' => 'laole918@qq.com' }
  s.source           = { :git => 'https://github.com/laole918/WKWebViewJavascriptBridge.git', :tag => s.version.to_s }

  s.platform         = :ios, '9.0'
  s.requires_arc     = true

  s.source_files = 'WKWebViewJavascriptBridge/*.{h,m}'
  s.private_header_files = 'WKWebViewJavascriptBridge/WKWebViewJavascriptBridgeJS.h'
end
