Pod::Spec.new do |livePlayer|

  livePlayer.name         = 'WYLivePlayer'
  livePlayer.version      = '1.0.0'
  livePlayer.summary      = '基于IJKPlayer编译封装的直播播放器，支持RTMP/RTMPS/RTMPT/RTMPE/RTSP/HLS/HTTP(S)-FLV/KMP  等网络协议， 支持录屏功能'
  livePlayer.description  = <<-DESC
                          依赖库
                          libc++.tbd
                          libz.tbd
                          libbz2.tbd
                          AudioToolbox.framework
                          UIKit.framework
                          CoreGraphics.framework
                          AVFoundation.framework
                          CoreMedia.framework
                          CoreVideo.framework
                          MediaPlayer.framework
                          CoreServices.framework
                          OpenGLES.framework
                          QuartzCore.framework
                          VideoToolbox.framework
                   DESC

  livePlayer.homepage     = 'https://github.com/Jacke-xu/WYBasisKit-swift/blob/master/WYBasisKit/LivePlayer/WYLivePlayer.zip'
  livePlayer.license      = { :type => 'MIT', :file => 'License.md' }
  livePlayer.author             = { 'Jacke-xu' => 'mobileAppDvlp@icloud.com' }
  livePlayer.ios.deployment_target = '12.0'
  livePlayer.source       = { :http => 'https://github.com/Jacke-xu/WYBasisKit-swift/blob/master/WYBasisKit/LivePlayer/WYLivePlayer.zip?raw=true' }
  livePlayer.swift_versions = '5.0'
  livePlayer.requires_arc = true
  livePlayer.source_files = 'WYLivePlayer/WYLivePlayer.swift'
  livePlayer.dependency 'SnapKit'
  livePlayer.dependency 'Kingfisher'
  livePlayer.vendored_frameworks = 'WYLivePlayer/IJKMediaFramework.framework'
  livePlayer.libraries = 'c++', 'z', 'bz2'
  livePlayer.frameworks = 'UIKit', 'AudioToolbox', 'CoreGraphics', 'AVFoundation', 'CoreMedia', 'CoreVideo', 'MediaPlayer', 'CoreServices', 'OpenGLES', 'QuartzCore', 'VideoToolbox'
end
