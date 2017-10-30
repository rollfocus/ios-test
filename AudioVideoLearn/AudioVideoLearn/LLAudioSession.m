//
//  LLAudioSession.m
//  AudioVideoLearn
//
//  Created by lin zoup on 2/21/17.
//  Copyright © 2017 cDuozi. All rights reserved.
//

#import "LLAudioSession.h"
#import <AVFoundation/AVFoundation.h>


@implementation LLAudioSession

- (void)start {
    // init AVAudioSession
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //后台独占播放，不遵从静音播放，可使用蓝牙播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
}

- (void)play {
    // 使用 AudioToolBox 网络歌曲
    // 使用 FFMPEG 播放网络歌曲
}

- (void)liveVideo {
    // 录制视频并进行直播处理
}

@end
