Pod::Spec.new do |s|
  s.name         = 'SoapWebService'
  s.version      = '1.0.5'
  s.summary      = 'The Web service calls on SoapUtility based on the package for iOS.'
  s.homepage     = 'https://github.com/webbabyking/SoapWebService'
  s.license      = 'MIT'
  s.author       = { 'wangjie' => '45522391@qq.com' }
  s.platform     = :ios,'7.0'
  s.source       = { :git => 'https://github.com/webbabyking/SoapWebService.git', :tag => s.version.to_s }
  #s.source_files  = 'SoapWebService/*.{h,m}'
  #s.public_header_files = 'SoapWebService/SoapWebService.h'
  s.default_subspecs = 'SoapWebService'
  s.requires_arc = true
  #s.frameworks = 'Foundation'

  
  s.subspec 'SoapUtility' do |ss|
    ss.public_header_files = 'SoapWebService/SoapUtility/Soap.h'
    ss.source_files = 'SoapWebService/SoapUtility/*.{h,m}'
    ss.ios.frameworks = 'Foundation','UIKit'
    ss.library      = 'xml2'
    ss.xcconfig     = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
    ss.dependency 'KissXML', '~> 5.1.2'
  end
 
  s.subspec 'SoapWebService' do |ss|
  	#ss.dependency 'SoapWebService/SoapUtility'
    ss.source_files = 'SoapWebService/*.{h,m}','SoapWebService/SoapUtility/*.{h,m}'
    ss.public_header_files = 'SoapWebService/SoapWebService.h'
    #ss.ios.frameworks = 'Foundation','UIKit'
    #ss.library      = 'xml2'
    #ss.xcconfig     = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2'}
    #ss.dependency 'KissXML', '~> 5.1.2'
  end

  s.ios.deployment_target = '8.0'

end