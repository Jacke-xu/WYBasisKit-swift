Pod::Spec.new do |kit|

  kit.name         = 'WYBasisKit'
  kit.version      = '1.2.1'
  kit.summary      = 'WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的各种实用方法、扩展，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。'
  kit.description  = <<-DESC
                         Localizable: 国际化解决方案
                         Practical: 各种系统扩展
                         Networking: 网络请求解决方案
                         Activity: loading指示器
                         Storage: 本地存储
                         Layout: 布局相关
                   DESC

  kit.homepage     = 'https://github.com/Jacke-xu/WYBasisKit-swift'
  kit.license      = { :type => 'MIT', :file => 'License.md' }
  kit.author             = { 'Jacke-xu' => 'mobileAppDvlp@icloud.com' }
  kit.ios.deployment_target = '12.0'
  kit.source       = { :git => 'https://github.com/Jacke-xu/WYBasisKit-swift.git', :tag => "#{kit.version}" }
  kit.swift_versions = '5.0'
  kit.requires_arc = true
  kit.default_subspecs = 'Extension'

    kit.subspec 'Config' do |config|
       config.source_files = 'WYBasisKit/Config/**/*'
       config.frameworks = 'Foundation', 'UIKit'
    end

    kit.subspec 'Localizable' do |localizable|
       localizable.source_files = 'WYBasisKit/Localizable/WYLocalizableManager.swift'
       localizable.frameworks = 'Foundation', 'UIKit'
    end

    kit.subspec 'Extension' do |extension|

       extension.source_files = 'WYBasisKit/Extension/**/*'
       extension.frameworks = 'Foundation', 'UIKit', 'LocalAuthentication', 'Photos', 'CoreFoundation'
       extension.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
       extension.dependency 'WYBasisKit/Localizable'
       extension.dependency 'WYBasisKit/Config'
    end
    
    kit.subspec 'Networking' do |networking|
       networking.source_files = 'WYBasisKit/Networking/**/*', 'WYBasisKit/Extension/UIAlertController/**/*'
       networking.frameworks = 'Foundation', 'UIKit'
       networking.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
       networking.dependency 'WYBasisKit/Localizable'
       networking.dependency 'WYBasisKit/Storage'
       networking.dependency 'Moya'
       networking.dependency 'HandyJSON'
    end

    kit.subspec 'Activity' do |activity|
       activity.source_files = 'WYBasisKit/Activity/WYActivity.swift', 'WYBasisKit/Extension/UIView/UIView.swift', 'WYBasisKit/Extension/UIViewController/UIViewController.swift', 'WYBasisKit/Extension/NSAttributedString/NSAttributedString.swift', 'WYBasisKit/Extension/String/String.swift', 'WYBasisKit/Extension/UIImage/UIImage.swift', 'WYBasisKit/Config/WYBasisKitConfig.swift', 'WYBasisKit/Config/WYConstMethod.swift'
       activity.frameworks = 'Foundation', 'UIKit'
       activity.resource = 'WYBasisKit/Activity/WYActivity.bundle', 'WYBasisKit/Localizable/WYLocalizable.bundle'
       activity.dependency 'WYBasisKit/Localizable'
    end

    kit.subspec 'Storage' do |storage|
       storage.source_files = 'WYBasisKit/Storage/**/*'
       storage.frameworks = 'Foundation', 'UIKit'
    end

    kit.subspec 'Layout' do |layout|

        layout.subspec 'FlowLayout' do |flowLayout|
        
            flowLayout.subspec 'WaterfallParagraph' do |waterfallParagraph|
              waterfallParagraph.source_files = 'WYBasisKit/Layout/FlowLayout/WYWaterfallParagraphLayout.swift'
              waterfallParagraph.frameworks = 'UIKit'
           end

            flowLayout.subspec 'WaterfallsFlow' do |waterfallsFlow|
              waterfallsFlow.source_files = 'WYBasisKit/Layout/FlowLayout/WYWaterfallsFlowLayout.swift'
              waterfallsFlow.frameworks = 'UIKit'
          end

            flowLayout.subspec 'AlignmentFlow' do |alignmentFlow|
              alignmentFlow.source_files = 'WYBasisKit/Layout/FlowLayout/WYAlignmentFlowLayout.swift'
              alignmentFlow.frameworks = 'UIKit'
           end
        end

        layout.subspec 'ScrollText' do |scrollText|
          scrollText.source_files = 'WYBasisKit/Layout/ScrollText/**/*', 'WYBasisKit/Config/WYBasisKitConfig.swift', 'WYBasisKit/Config/WYConstMethod.swift'
          scrollText.frameworks = 'Foundation', 'UIKit'
          scrollText.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
          scrollText.dependency 'WYBasisKit/Localizable'
          scrollText.dependency 'SnapKit'
       end

        layout.subspec 'PagingView' do |pagingView|
          pagingView.source_files = 'WYBasisKit/Layout/PagingView/**/*', 'WYBasisKit/Extension/UIView/**/*', 'WYBasisKit/Extension/UIButton/**/*', 'WYBasisKit/Extension/UIColor/**/*', 'WYBasisKit/Extension/UIImage/**/*', 'WYBasisKit/Config/WYBasisKitConfig.swift', 'WYBasisKit/Config/WYConstMethod.swift'
          pagingView.frameworks = 'Foundation', 'UIKit'
          pagingView.dependency 'SnapKit'
       end

        layout.subspec 'BannerView' do |bannerView|
          bannerView.source_files = 'WYBasisKit/Layout/BannerView/WYBannerView.swift', 'WYBasisKit/Extension/UIView/**/*', 'WYBasisKit/Config/WYBasisKitConfig.swift', 'WYBasisKit/Config/WYConstMethod.swift'
          bannerView.frameworks = 'Foundation', 'UIKit'
          bannerView.resource = 'WYBasisKit/Layout/BannerView/WYBannerView.bundle', 'WYBasisKit/Localizable/WYLocalizable.bundle'
          bannerView.dependency 'WYBasisKit/Localizable'
          bannerView.dependency 'Kingfisher'
       end
    end
end
