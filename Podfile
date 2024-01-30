platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!
use_modular_headers!
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'WYBasisKit' do
  pod 'SnapKit'
  pod 'Kingfisher'
  pod 'Moya'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
