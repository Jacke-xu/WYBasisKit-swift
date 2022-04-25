/*
 * IJKMediaPlayer.h
 *
 * Copyright (c) 2013 Bilibili
 * Copyright (c) 2013 Zhang Rui <bbcallen@gmail.com>
 *
 * This file is part of ijkPlayer.
 *
 * ijkPlayer is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * ijkPlayer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with ijkPlayer; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#import "IJKMediaPlayback.h"
#import "IJKMPMoviePlayerController.h"

#import "IJKFFOptions.h"
#import "IJKFFMoviePlayerController.h"

#import "IJKAVMoviePlayerController.h"

#import "IJKMediaModule.h"

/*
 支持RTMP/RTMPS/RTMPT/RTMPE/RTSP/HLS/HTTP(S)-FLV/KMP  等网络协议
 支持录屏
 */

/*
 集成/编译参考
 https://www.jianshu.com/p/2ea6f8e7ed1f
 https://www.jianshu.com/p/c9640c86ff17
 */

/*
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
 */

/*
 播放示例
 #import <IJKMediaFramework/IJKMediaFramework.h>

 @property(nonatomic, strong) id<IJKMediaPlayback>player;

 NSString *videoUrl = @"xxxxxxx";

 IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
 self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:videoUrl] withOptions:options];
 UIView *playerView = [self.player view];
 playerView.frame = self.view.bounds;
 playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 [self.view addSubview:playerView];
 [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
 self.player.shouldAutoplay = YES;
 [self.player prepareToPlay];
 */

/*
 视屏录制示例
 #import <IJKMediaFramework/IJKMediaFramework.h>
 #import <Photos/Photos.h>
 
 @property (nonatomic, strong) NSString *savedVideoPath;

 - (void)recordBtnCicked:(UIButton *)sender {

 if (![self.player isRecording]) {
     
     [self.player startRecordWithFileName:[self getNowSavedVideoPath]];
     
 }else{
     [self.player stopRecord];
     NSLog(@"保存的视频路径：%@",self.savedVideoPath);

     PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
     [photoLibrary performChanges:^{
         [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL
     fileURLWithPath:self.savedVideoPath]];
     } completionHandler:^(BOOL success, NSError * _Nullable error) {
         if (success) {
             NSLog(@"已将视频保存至相册");
         } else {
             NSLog(@"未能保存视频到相册");
         }
     }];
 }
 }
 - (NSString *)getNowSavedVideoPath{
 if (![self.player isRecording]) {
     
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     
     NSError *error;
     NSString *defaultVideoPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"videoFile"];
     if (![[NSFileManager defaultManager]createDirectoryAtPath:defaultVideoPath withIntermediateDirectories:YES attributes:nil error:&error]) {
         NSLog(@"创建defaultVideoPath=============================%@",error);
     }
     
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
     [formatter setDateStyle:NSDateFormatterMediumStyle];
     [formatter setTimeStyle:NSDateFormatterShortStyle];
     [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss:SSS"];
     NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
     [formatter setTimeZone:timeZone];
     NSDate *datenow = [NSDate date];
     NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
     
     
     int i = arc4random() % 10000000 ;
     
     NSString *resultStr = [NSString stringWithFormat:@"%@_%d.mp4",timeSp,i];
     
     NSString *savedVideoPath = [defaultVideoPath stringByAppendingPathComponent:resultStr];
     
     self.savedVideoPath = savedVideoPath;
     }

     return self.savedVideoPath;
 }
 */
