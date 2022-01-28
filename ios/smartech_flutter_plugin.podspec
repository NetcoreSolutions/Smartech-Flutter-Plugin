Pod::Spec.new do |s|
  s.name                    = 'smartech_flutter_plugin'
  s.version                 = '2.0.0'
  s.summary                 = 'The Smartech iOS SDK for App Analytics and User Engagement.'
  s.description             = <<-DESC
                                Smartech is a omni channel platform that delivers everything you need to drive mobile engagement and create valuable consumer relationships on mobile.
                                The Smartech iOS SDK enables your native iOS app to use all of the features.
                              DESC
  s.homepage                = "https://netcoresmartech.com"  
  s.documentation_url       = 'https://docs.netcoresmartech.com/'
  s.license                 = { :file => '../LICENSE' }
  s.author                  = { "Netcore Solutions" => "jobin.kurian@netcorecloud.com" } 
  s.platform                = :ios, '10.0'
  s.source                  = { :path => '.' }
  s.source_files            = 'Classes/**/*'
  
  s.dependency 'Flutter'
  s.dependency 'Smartech-iOS-SDK', '~> 3.1.10'
    
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

end