#
#  Be sure to run `pod spec lint TXCustomBeautyProcessPlugin.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "TXCustomBeautyProcessPlugin"
  spec.version      = "1.0.0"
  spec.summary      = "腾讯云实时音视频第三方美颜插件"
  spec.description  = <<-DESC
  腾讯云实时音视频第三方美颜插件
                   DESC
  spec.source           = { :path => '.' }
  spec.homepage     = "https://cloud.tencent.com/product/mlvb"
  spec.license      = { :file => '../LICENSE' }
  spec.author             = 'tencent video cloud'
  spec.source_files  = 'Classes/**/*'
  spec.platform = :ios, '9.0'
  
  spec.static_framework = true
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  spec.swift_version = '5.0'
  
  # live
  spec.vendored_frameworks = '**/*.framework'
  spec.dependency 'TXLiteAVSDK_Live', '9.9.11217'

end
