#
#  Be sure to run `pod spec lint LWNetworking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name          = "LWExtensionKit"
  spec.version       = "1.0.0"
  spec.summary       = "系统库的extension"
  spec.description   = "拓展"

  spec.homepage      = "https://www.luowen.cn"

  spec.license       = { :type => 'MIT', :file => 'LICENSE' }

  spec.author        = { "luowen" => "luowen@dushu.io" }
  spec.source       = { :git => 'git@gitlab.dushuclub.io:swift/LWExtensionKit.git', :tag => "#{spec.version}" }

  spec.platform      = :ios, "11.0"
  spec.swift_version = '5.0'

  spec.subspec 'Base' do |s|
     s.source_files = 'Classes/Base/*.swift'
  end

  spec.subspec 'Foundation' do |s|
     s.dependency 'LWExtensionKit/Base'
     s.subspec 'String' do |ss|
       ss.source_files = 'Classes/Foundation/String/*.swift'
     end

  end

  spec.subspec 'UIKit' do |s|
      s.dependency 'LWExtensionKit/Base'
      s.subspec 'UIColor' do |ss|
         ss.source_files = 'Classes/UIKit/UIColor/*.swift'
      end
      s.subspec 'UIDevice' do |ss|
         ss.source_files = 'Classes/UIKit/UIDevice/*.swift'
      end
      s.subspec 'UIViewController' do |ss|
         ss.source_files = 'Classes/UIKit/UIViewController/*.swift'
      end
  end
#
#  spec.subspec 'Rx' do |s|
#    s.dependency 'RxSwift'
#    s.dependency 'RxCocoa'
#  end

end
