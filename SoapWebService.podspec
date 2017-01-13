Pod::Spec.new do |s|
  s.name         = 'SoapWebService'
  s.version      = '1.0.5'
  s.summary      = 'The Web service calls on SoapUtility based on the package for iOS.'
  s.homepage     = 'https://github.com/webbabyking/SoapWebService'
  s.license      = 'MIT'
  s.author       = { 'wangjie' => 'wangjie@qq.com' }
  s.platform     = :ios,'7.0'
  s.source       = { :git => 'https://github.com/webbabyking/SoapWebService.git', :tag => '1.0.5'}
  #s.source_files  = 'SoapWebService/*.{h,m}'
  #s.public_header_files = 'SoapWebService/SoapWebService.h'
  s.default_subspecs = 'SoapWebService'
  s.requires_arc = true
  #s.frameworks = 'Foundation'

  
  s.subspec 'SoapUtility' do |ss|
    ss.dependency 'KissXML', '~> 5.1.2'
    ss.source_files = 'SoapWebService/**/*.{h,m}'
    ss.private_header_files = 'SoapWebService/**/*.h'
    ss.public_header_files = 'SoapWebService/SoapUtility/Soap.h'
    ss.ios.frameworks = 'Foundation','UIKit'
    ss.library      = 'xml2'
    ss.xcconfig     = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
  end
 
  s.subspec 'SoapWebService' do |ss|
  	ss.dependency 'SoapWebService/SoapUtility'
    ss.source_files = 'SoapWebService/*.{h,m}'
    ss.public_header_files = 'SoapWebService/SoapWebService.h'
    ss.ios.frameworks = 'Foundation'
  end

  s.ios.deployment_target = '8.0'

end