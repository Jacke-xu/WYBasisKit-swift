Pod::Spec.new do |spec|

  spec.name         = "WYBasisKit"
  spec.version      = "0.0.8"
  spec.summary      = "一个大幅提高开发效率的工具库"
  spec.description  = <<-DESC 
                          WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的方法，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。
                   DESC

  spec.homepage     = "https://github.com/Jacke-xu/WYBasisKit-swift"
  spec.license      = { :type => "MIT", :file => "License.md" }
  spec.author             = { "Jacke-xu" => "mobileAppDvlp@icloud.com" }
  spec.ios.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/Jacke-xu/WYBasisKit-swift.git", :tag => "#{spec.version}" }
  spec.swift_versions = "5.0"
  spec.requires_arc = true
  

# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    spec.subspec 'Config' do |sp|
       sp.source_files = 'WYBasisKit/Config/**/*'
       sp.frameworks = 'Foundation', 'UIKit'
    end

    spec.subspec 'Layout' do |sp|
       sp.source_files = 'WYBasisKit/Layout/**/*'
       sp.frameworks = 'Foundation', 'UIKit'
       sp.dependency 'WYBasisKit/Config'
       sp.dependency 'SnapKit'
    end

    spec.subspec 'Networking' do |sp|
       sp.source_files = 'WYBasisKit/Networking/**/*', 'WYBasisKit/Extension/UIAlertController/**/*'
       sp.frameworks = 'Foundation', 'UIKit'
       sp.dependency 'WYBasisKit/Config'
       sp.dependency 'Moya'
       sp.dependency 'HandyJSON'
    end

    spec.subspec 'Extension' do | sp|
       sp.source_files = 'WYBasisKit/Extension/**/*', 'WYBasisKit/Practical/ConstDefinition/**/*'
       sp.frameworks = 'Foundation', 'UIKit'
       sp.dependency 'WYBasisKit/Config'
       sp.dependency 'MJRefresh'
       sp.dependency 'libPhoneNumber-iOS'
       sp.dependency 'MBProgressHUD'
    end

    spec.subspec 'Practical' do |sp|
       sp.source_files = 'WYBasisKit/Practical/**/*', 'WYBasisKit/Extension/UIAlertController/**/*', 'WYBasisKit/Extension/NSObject/**/*', 'WYBasisKit/Extension/UIDevice/**/*'
       sp.frameworks = 'Foundation', 'UIKit', 'LocalAuthentication', 'Photos', 'CoreFoundation'
       sp.dependency 'WYBasisKit/Config'
    end

end
