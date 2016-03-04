Pod::Spec.new do |s|
  s.name         = 'SoapWebService'
  s.version      = '1.0.3'
  s.summary      = 'The Web service calls on SoapUtility based on the package for iOS.'
  s.description  = <<-DESC
                   The Web service calls on SoapUtility based on the package for iOS.
                   DESC
  s.homepage     = 'https://github.com/webbabyking/SoapWebService'
  s.license      = 'MIT'
  s.author       = { 'wangjie' => 'wangjie@qq.com' }
  s.platform     = :ios,'7.0'
  s.source       = { :git => 'https://github.com/webbabyking/SoapWebService.git', :tag => '1.0.3'}
  s.source_files  = 'SoapWebService/*.{h,m}','SoapUtility/*.{h,m}'
  s.public_header_files = 'SoapWebService/SoapWebService.h'
  s.requires_arc = true
  s.frameworks = 'Foundation'
  
  s.ios.deployment_target = '7.0'

  s.subspec 'SoapWebService' do |ss|
    ss.source_files = 'SoapWebService/*.{h,m}'
    ss.public_header_files = 'SoapWebService/SoapWebService.h'
    ss.ios.frameworks = 'Foundation'
  end

  s.subspec 'SoapUtility' do |ss|
    ss.source_files = 'SoapUtility/*.{h,m}'
    ss.public_header_files = 'SoapUtility/Soap.h'
    ss.ios.frameworks = 'Foundation','UIKit'
    ss.dependency 'KissXML', '~> 5.0.3'
    ss.library      = 'xml2'
    ss.xcconfig     = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
  end

  

end