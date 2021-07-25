Pod::Spec.new do |kit|

  kit.name         = 'WYBasisKit'
  kit.version      = '0.2.9'
  kit.summary      = '一个大幅提高开发效率的工具库'
  kit.description  = <<-DESC
                          WYBasisKit 不仅可以帮助开发者快速构建一个工程，还有基于常用网络框架和系统API而封装的方法，开发者只需简单的调用API就可以快速实现相应功能， 大幅提高开发效率。
                   DESC

  kit.homepage     = 'https://github.com/Jacke-xu/WYBasisKit-swift'
  kit.license      = { :type => 'MIT', :file => 'License.md' }
  kit.author             = { 'Jacke-xu' => 'mobileAppDvlp@icloud.com' }
  kit.ios.deployment_target = '10.0'
  kit.source       = { :git => 'https://github.com/Jacke-xu/WYBasisKit-swift.git', :tag => "#{kit.version}" }
  kit.swift_versions = '5.0'
  kit.requires_arc = true
  kit.default_subspec = 'Config', 'Localizable', 'Extension', 'Practical', 'Networking'
 

    kit.subspec 'Config' do |config|
       config.source_files = 'WYBasisKit/Config/**/*'
       config.frameworks = 'Foundation', 'UIKit'
    end

    kit.subspec 'Localizable' do |localizable|
       localizable.source_files = 'WYBasisKit/Localizable/**/*'
       localizable.frameworks = 'Foundation', 'UIKit'
       localizable.dependency 'WYBasisKit/Config'
    end
    
    kit.subspec 'Extension' do |extension|
       extension.source_files = 'WYBasisKit/Extension/**/*', 'WYBasisKit/Practical/ConstDefinition/WYConstDefinition.swift'
       extension.frameworks = 'Foundation', 'UIKit'
       extension.dependency 'WYBasisKit/Localizable'
       extension.dependency 'MJRefresh'
       extension.dependency 'libPhoneNumber-iOS'
       extension.dependency 'MBProgressHUD'
    end

    kit.subspec 'Practical' do |practical|
       practical.source_files = 'WYBasisKit/Practical/**/*', 'WYBasisKit/Extension/UIAlertController/**/*', 'WYBasisKit/Extension/NSObject/**/*', 'WYBasisKit/Extension/UIDevice/**/*'
       practical.frameworks = 'Foundation', 'UIKit', 'LocalAuthentication', 'Photos', 'CoreFoundation'
       practical.dependency 'WYBasisKit/Localizable'
    end
    
    kit.subspec 'Networking' do |networking|
       networking.source_files = 'WYBasisKit/Networking/**/*', 'WYBasisKit/Extension/UIAlertController/**/*'
       networking.frameworks = 'Foundation', 'UIKit'
       networking.dependency 'WYBasisKit/Localizable'
       networking.dependency 'Moya'
       networking.dependency 'HandyJSON'
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
          scrollText.source_files = 'WYBasisKit/Layout/ScrollText/**/*', 'WYBasisKit/Practical/ConstDefinition/WYConstDefinition.swift'
          scrollText.frameworks = 'Foundation', 'UIKit'
          scrollText.dependency 'WYBasisKit/Localizable'
          scrollText.dependency 'SnapKit'
       end

        layout.subspec 'PagingView' do |pagingView|
          pagingView.source_files = 'WYBasisKit/Layout/PagingView/**/*', 'WYBasisKit/Extension/UIButton/**/*', 'WYBasisKit/Extension/UIColor/**/*', 'WYBasisKit/Extension/UIImage/**/*', 'WYBasisKit/Extension/UIView/**/*', 'WYBasisKit/Practical/ConstDefinition/WYConstDefinition.swift'
          pagingView.frameworks = 'Foundation', 'UIKit'
          pagingView.dependency 'WYBasisKit/Config'
          pagingView.dependency 'SnapKit'
       end

        layout.subspec 'BannerView' do |bannerView|
          bannerView.source_files = 'WYBasisKit/Layout/BannerView/**/*.swift', 'WYBasisKit/Extension/UIView/**/*', 'WYBasisKit/Practical/ConstDefinition/WYConstDefinition.swift'
          bannerView.frameworks = 'Foundation', 'UIKit'
          bannerView.dependency 'WYBasisKit/Localizable'
          bannerView.dependency 'SnapKit'
          bannerView.dependency 'Kingfisher'
          bannerView.resource = 'WYBasisKit/Layout/BannerView/WYBannerView.bundle'
       end
    end
end
