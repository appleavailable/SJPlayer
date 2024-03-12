//
//  SJIJKMediaPlaybackController.m
//  SJVideoPlayer_Example
//
//  Created by BlueDancer on 2019/10/12.
//  Copyright © 2019 changsanjiang. All rights reserved.
//

#import "SJIJKMediaPlaybackController.h"
#import "SJIJKMediaPlayerLayerView.h"

#if __has_include(<SJUIKit/SJRunLoopTaskQueue.h>)
#import <SJUIKit/SJRunLoopTaskQueue.h>
#else
#import "SJRunLoopTaskQueue.h"
#endif

NS_ASSUME_NONNULL_BEGIN
@interface SJIJKMediaPlaybackController ()

@end

@implementation SJIJKMediaPlaybackController
@dynamic currentPlayer;

- (void)dealloc {
    [self.currentPlayer stop];
}

- (void)stop {
    [self.currentPlayer stop];
    [super stop];
}

- (IJKFFOptions *)options {
    if ( _options == nil ) {
        _options = IJKFFOptions.optionsByDefault;
        //播放前的探测Size，默认是1M, 改小一点会出画面更快 可能会导致播放一段时间没有声音
//        [_options setPlayerOptionIntValue:1024 * 40 forKey:@"probesize"];
        //设置播放前的探测时间 1,达到首屏秒开效果
        [_options setPlayerOptionIntValue:1 forKey:@"analyzeduration"];
        //可以通过修改 framedrop 的数值来解决不同步的问题，framedrop 是在视频帧处理不过来的时候丢弃一些帧达到同步的效果
        [_options setPlayerOptionIntValue:5 forKey:@"framedrop"];
        //播放器采用硬解码，0的话是软解吗
        [_options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
        //设置seekTo能够快速seek到指定位置并播放
        [_options setPlayerOptionValue:@"fastseek" forKey:@"fflags"];
        //缓冲区大小,可使seek速度变快
//        [_options setPlayerOptionIntValue:900*1024 forKey:@"max-buffer-size"];
        //精准seek关闭
        [_options setPlayerOptionIntValue:0 forKey:@"enable-accurate-seek"];
//        [_options setPlayerOptionIntValue:1 forKey:@"inbuf"];
        //最大fps
        [_options setPlayerOptionIntValue:30 forKey:@"max-fps"];
        //帧速率(fps) 可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97
        [_options setPlayerOptionIntValue:29.97 forKey:@"r"];
        //解码参数，画面更清晰
        [_options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
        //这个目前理解应该是丢帧数设置
        [_options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
    }
    return _options;
}

- (void)playerWithMedia:(SJVideoPlayerURLAsset *)media completionHandler:(void (^)(id<SJMediaPlayer> _Nullable))completionHandler {
    __weak typeof(self) _self = self;
    SJRunLoopTaskQueue.main.enqueue(^{
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        SJIJKMediaPlayer *player = [SJIJKMediaPlayer.alloc initWithURL:media.mediaURL startPosition:media.startPosition options:self.options];
        player.pauseWhenAppDidEnterBackground = self.pauseWhenAppDidEnterBackground;
        if ( completionHandler ) completionHandler(player);
    });
}

- (UIView<SJMediaPlayerView> *)playerViewWithPlayer:(SJIJKMediaPlayer *)player {
    return [SJIJKMediaPlayerLayerView.alloc initWithPlayer:player];
}

- (void)setPauseWhenAppDidEnterBackground:(BOOL)pauseWhenAppDidEnterBackground {
    [super setPauseWhenAppDidEnterBackground:pauseWhenAppDidEnterBackground];
    self.currentPlayer.pauseWhenAppDidEnterBackground = pauseWhenAppDidEnterBackground;
}

#pragma mark -

- (void)setMinBufferedDuration:(NSTimeInterval)minBufferedDuration {
#ifdef DEBUG
    NSLog(@"%d \t %s \t 未实现该方法!", (int)__LINE__, __func__);
#endif
}

- (NSTimeInterval)durationWatched {
#ifdef DEBUG
    NSLog(@"%d \t %s \t 未实现该方法!", (int)__LINE__, __func__);
#endif
    return 0;
}

- (SJPlaybackType)playbackType {
#ifdef DEBUG
    NSLog(@"%d \t %s \t 未实现该方法!", (int)__LINE__, __func__);
#endif
    return SJPlaybackTypeUnknown;
}
@end
NS_ASSUME_NONNULL_END
