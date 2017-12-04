Pod::Spec.new do |s|
  s.name         = "POPSUGARShopSense"
  s.version      = "0.9.9"
  s.summary      = "Objective-C client for the POPSUGAR ShopSense API."
  s.homepage     = "https://github.com/PopSugar/objc-POPSUGAR-ShopSense-client"
  s.author       = { "POPSUGAR Inc" => "shopsense@shopstyle.com" }
  s.license      = 'MIT'

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/PopSugar/objc-POPSUGAR-ShopSense-client.git", :tag => s.version.to_s }
  s.source_files = 'POPSUGARShopSense/*.{h,m}'

  s.requires_arc = true
  
  s.dependency 'AFNetworking', '~> 1.0'
  s.prefix_header_contents = <<-EOS
#ifdef __OBJC__
  #import <Security/Security.h>

  #if __IPHONE_OS_VERSION_MIN_REQUIRED
    #import <SystemConfiguration/SystemConfiguration.h>
    #import <MobileCoreServices/MobileCoreServices.h>
  #else
    #import <SystemConfiguration/SystemConfiguration.h>
    #import <CoreServices/CoreServices.h>
  #endif
#endif /* __OBJC__*/
EOS

end
