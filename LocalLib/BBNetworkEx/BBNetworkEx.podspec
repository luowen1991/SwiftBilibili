#
#  Be sure to run `pod spec lint LWNetworking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name          = "BBNetworkEx"
  spec.version       = "1.0.0"
  spec.summary       = "网络业务库"
  spec.description   = "基于LWNetwork实现的业务库"

  spec.homepage      = "https://www.luowen.cn"

  spec.license       = { :type => 'MIT', :file => 'LICENSE' }

  spec.author        = { "luowen" => "luowen@dushu.io" }
  spec.source       = { :git => 'git@gitlab.dushuclub.io:swift/LWNetwork.git', :tag => "#{spec.version}" }

  spec.platform      = :ios, "11.0"
  spec.swift_version = '5.0'

  spec.resource_bundles = {
     'BBNetworkEx' => ['Assets/*.xcassets']
  }

  spec.source_files = 'Classes/**/*'
  spec.dependency 'LWNetwork'
  spec.dependency 'SnapKit'
  spec.dependency 'Then'
  spec.dependency 'Toast-Swift'
  spec.dependency 'ESPullToRefresh'
  spec.dependency 'LWExtensionKit'

end
