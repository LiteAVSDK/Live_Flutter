#
#  Be sure to run `pod spec lint TXCustomBeautyProcessPlugin.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name          = "TXCustomBeautyProcesserPlugin"
  spec.version       = "1.0.2"
  spec.summary       = "腾讯云实时音视频第三方美颜插件"
  spec.description   = <<-DESC
  腾讯云实时音视频第三方美颜插件
                   DESC

  spec.homepage      = "https://github.com/LiteAVSDK/Live_Flutter/tree/main/beauty_processer_plugin/iOS"
  spec.license       = { :type => 'MIT', :file => 'LICENSE' }
  spec.author        = 'tencent video cloud'
  spec.source        = { :git => 'https://github.com/LiteAVSDK/Live_Flutter.git', :tag => "v1.0.2" }
  spec.source_files  = 'beauty_processer_plugin/iOS/Classes/*.swift'
  spec.ios.deployment_target = "9.0"
  
  spec.requires_arc = true 
  spec.static_framework = true
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  spec.swift_version = '5.0'

end
