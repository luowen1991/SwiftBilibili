#
#  Be sure to run `pod spec lint LWNetworking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name          = "LWNetwork"
  spec.version       = "1.0.0"
  spec.summary       = "网络库"
  spec.description   = "基于Moya与RxSwift的网络组件库"

  spec.homepage      = "https://www.luowen.cn"

  spec.license       = { :type => 'MIT', :file => 'LICENSE' }

  spec.author        = { "luowen" => "luowen@dushu.io" }
  spec.source       = { :git => 'git@gitlab.dushuclub.io:swift/LWNetwork.git', :tag => "#{spec.version}" }

  spec.platform      = :ios, "11.0"
  spec.swift_version = '5.0'

  spec.dependency 'RxSwift'
  spec.dependency 'RxCocoa'
  spec.dependency 'ObjectMapper'
  spec.dependency 'Moya'

  spec.subspec 'Core' do |s|
     s.dependency 'LWNetwork/MoyaSugar'
     s.source_files = 'Classes/Core/**/*.swift'
  end

  spec.subspec 'MoyaSugar' do |s|
     s.source_files = 'Classes/MoyaSugar/**/*.swift'
  end

  spec.subspec 'Cache' do |s|
     s.dependency 'LWNetwork/Core'
     s.source_files = 'Classes/Cache/**/*.swift'
  end

end
