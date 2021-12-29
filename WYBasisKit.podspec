Pod::Spec.new do |kit|

  kit.name         = 'WYBasisKit'
  kit.version      = '1.0.2'
  kit.summary      = '一个大幅提高开发效率的工具库'
  kit.description  = <<-DESC
                          WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的方法，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。
                   DESC

  kit.homepage     = 'https://github.com/Jacke-xu/WYBasisKit-swift'
  kit.license      = { :type => 'MIT', :file => 'License.md' }
  kit.author             = { 'Jacke-xu' => 'mobileAppDvlp@icloud.com' }
  kit.ios.deployment_target = '11.0'
  kit.source       = { :git => 'https://github.com/Jacke-xu/WYBasisKit-swift.git', :tag => "#{kit.version}" }
  kit.swift_versions = '5.0'
  kit.requires_arc = true
  kit.default_subspecs = 'Extension/System', 'Practical/System'
 

    kit.subspec 'Localizable' do |localizable|
       localizable.source_files = 'WYBasisKit/Localizable/WYLocalizableManager.swift'
       localizable.frameworks = 'Foundation', 'UIKit'
    end
    
    kit.subspec 'Extension' do |extension|
       
       extension.subspec 'Refresh' do |refresh|
          refresh.source_files = 'WYBasisKit/Extension/Refresh/**/*', 'WYBasisKit/Config/WYBasisKitConfig.swift'
          refresh.frameworks = 'Foundation', 'UIKit'
          refresh.dependency 'WYBasisKit/Localizable'
          refresh.dependency 'MJRefresh'
       end

       extension.subspec 'System' do |sstm|
          sstm.source_files = 'WYBasisKit/Extension/System/**/*', 'WYBasisKit/Practical/System/ConstDefinition/**/*', 'WYBasisKit/Config/WYBasisKitConfig.swift'
          sstm.frameworks = 'Foundation', 'UIKit'
          sstm.dependency 'WYBasisKit/Localizable'
          sstm.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
       end
    end

    kit.subspec 'Practical' do |practical|

       practical.subspec 'BoolJudge' do |boolJudge|
          boolJudge.source_files = 'WYBasisKit/Practical/BoolJudge/**/*', 'WYBasisKit/Config/WYBasisKitConfig.swift', 'WYBasisKit/Extension/System/String/String.swift'
          boolJudge.frameworks = 'Foundation', 'UIKit', 'libPhoneNumber_iOS'
          boolJudge.dependency 'libPhoneNumber-iOS'
          boolJudge.dependency 'WYBasisKit/Localizable'
          boolJudge.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
       end

       practical.subspec 'System' do |sstm|
          sstm.source_files = 'WYBasisKit/Practical/System/**/*', 'WYBasisKit/Extension/System/UIAlertController/**/*', 'WYBasisKit/Extension/System/NSObject/**/*', 'WYBasisKit/Extension/System/UIDevice/**/*', 'WYBasisKit/Config/WYBasisKitConfig.swift'
          sstm.frameworks = 'Foundation', 'UIKit', 'LocalAuthentication', 'Photos', 'CoreFoundation'
          sstm.dependency 'WYBasisKit/Localizable'
          sstm.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
       end
    end
    
    kit.subspec 'Networking' do |networking|
       networking.source_files = 'WYBasisKit/Networking/**/*', 'WYBasisKit/Extension/System/UIAlertController/**/*'
       networking.frameworks = 'Foundation', 'UIKit'
       networking.dependency 'WYBasisKit/Localizable'
       networking.dependency 'WYBasisKit/Storage'
       networking.dependency 'Moya'
       networking.dependency 'HandyJSON'
       networking.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
    end

    kit.subspec 'Activity' do |activity|
       activity.source_files = 'WYBasisKit/Activity/WYActivity.swift', 'WYBasisKit/Extension/System/UIView/UIView.swift', 'WYBasisKit/Extension/System/NSAttributedString/NSAttributedString.swift', 'WYBasisKit/Extension/System/String/String.swift', 'WYBasisKit/Extension/System/UIImage/UIImage.swift', 'WYBasisKit/Config/WYBasisKitConfig.swift', 'WYBasisKit/Practical/System/ConstDefinition/**/*'
       activity.frameworks = 'Foundation', 'UIKit'
       activity.dependency 'WYBasisKit/Localizable'
       activity.resource = 'WYBasisKit/Activity/WYActivity.bundle', 'WYBasisKit/Localizable/WYLocalizable.bundle'
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
          scrollText.source_files = 'WYBasisKit/Layout/ScrollText/**/*', 'WYBasisKit/Practical/System/ConstDefinition/WYConstDefinition.swift', 'WYBasisKit/Config/WYBasisKitConfig.swift'
          scrollText.frameworks = 'Foundation', 'UIKit'
          scrollText.dependency 'WYBasisKit/Localizable'
          scrollText.dependency 'SnapKit'
          scrollText.resource = 'WYBasisKit/Localizable/WYLocalizable.bundle'
       end

        layout.subspec 'PagingView' do |pagingView|
          pagingView.source_files = 'WYBasisKit/Layout/PagingView/**/*', 'WYBasisKit/Extension/System/UIButton/**/*', 'WYBasisKit/Extension/System/UIColor/**/*', 'WYBasisKit/Extension/System/UIImage/**/*', 'WYBasisKit/Extension/System/UIView/**/*', 'WYBasisKit/Practical/System/ConstDefinition/WYConstDefinition.swift', 'WYBasisKit/Config/WYBasisKitConfig.swift'
          pagingView.frameworks = 'Foundation', 'UIKit'
          pagingView.dependency 'SnapKit'
       end

        layout.subspec 'BannerView' do |bannerView|
          bannerView.source_files = 'WYBasisKit/Layout/BannerView/WYBannerView.swift', 'WYBasisKit/Extension/System/UIView/**/*', 'WYBasisKit/Practical/System/ConstDefinition/WYConstDefinition.swift', 'WYBasisKit/Config/WYBasisKitConfig.swift'
          bannerView.frameworks = 'Foundation', 'UIKit'
          bannerView.dependency 'WYBasisKit/Localizable'
          bannerView.dependency 'SnapKit'
          bannerView.dependency 'Kingfisher'
          bannerView.resource = 'WYBasisKit/Layout/BannerView/WYBannerView.bundle', 'WYBasisKit/Localizable/WYLocalizable.bundle'
       end
    end
end
