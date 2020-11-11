
Pod::Spec.new do |spec|
  spec.name         = "BBNetworking"
  spec.version      = "0.0.1"
  spec.summary      = "网络库"
  spec.description  = <<-DESC
            基于moya的二次封装
                   DESC

  spec.homepage     = "https://www.qyizhong.cn"
  spec.license      = "MIT"
  spec.author             = { "luowen" => "luowen@dushu.io" }
  spec.ios.deployment_target = "11.0"
  spec.source       = { :git => "", :tag => "0.0.1" }
  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
  spec.source_files  = "Classes/**/*"
  spec.swift_version = "5.0"
  spec.dependency "ObjectMapper", "~> 4.2.0"
  spec.dependency "Moya/RxSwift", "~> 14.0.0"
  spec.dependency "RxCocoa", "~> 5.1.1"
  spec.dependency "SwiftyJSON", "~> 5.0"

end
