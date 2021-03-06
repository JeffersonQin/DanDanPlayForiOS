//
//  DDPMediaPlayer.m
//  test
//
//  Created by JimHuang on 16/3/4.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DDPMediaPlayer.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import <Photos/Photos.h>
#import <BlocksKit/BlocksKit.h>
#import "NSString+Tools.h"
#import "DDPWebDAVInputStream.h"

@interface DDPMediaStreamDelegate : NSObject<NSStreamDelegate>
@property (nonatomic, strong) NSMutableSet <NSStream *>*inputStreams;

@property (nonatomic, copy) void(^progressCallBack)(CGFloat progress);
@end

@implementation DDPMediaStreamDelegate

- (NSMutableSet<NSStream *> *)inputStreams {
    if (_inputStreams == nil) {
        _inputStreams = [NSMutableSet set];
    }
    return _inputStreams;
}

#pragma mark - Protocol (NSStreamDelegate)
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    if (eventCode == NSStreamEventEndEncountered) {
        [self.inputStreams removeObject:aStream];
    }
}

- (void)inputStream:(DDPWebDAVInputStream *)stream downloadProgress:(CGFloat)downloadProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.progressCallBack) {
            self.progressCallBack(downloadProgress);
        }
    });
}

@end

//最大音量
#define MAX_VOLUME 200.0

static char mediaParsingCompletionKey = '0';
//static char mediaStreamKey = '0';

@interface DDPMediaPlayer()<VLCMediaPlayerDelegate, VLCMediaDelegate>
@property (strong, nonatomic) VLCMediaPlayer *localMediaPlayer;
@property (copy, nonatomic) SnapshotCompleteBlock snapshotCompleteBlock;
@property (nonatomic, strong, readonly, class) DDPMediaStreamDelegate *streamDelegate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL timeIsUpdate;
//@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation DDPMediaPlayer
{
    NSTimeInterval _length;
    NSTimeInterval _currentTime;
    DDPMediaPlayerStatus _status;
}

- (instancetype)initWithMedia:(id<DDPMediaItemProtocol>)media {
    if (self = [self init]) {
        [self setMedia:media];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];

        @weakify(self)
        self.class.streamDelegate.progressCallBack = ^(CGFloat progress) {
            @strongify(self)

            if ([self.delegate respondsToSelector:@selector(mediaPlayer:downloadProgress:)]) {
                [self.delegate mediaPlayer:self downloadProgress:progress];
            }
        };
    }
    return self;
}

- (void)dealloc {
    self.class.streamDelegate.progressCallBack = nil;
    [_mediaView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
}

- (void)parseWithCompletion:(void(^)(void))completion {
    objc_setAssociatedObject(self.localMediaPlayer.media, &mediaParsingCompletionKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
    let media = self.localMediaPlayer.media;
    let result = [media parseWithOptions:VLCMediaParseLocal | VLCMediaParseNetwork];
    
    if (result != 0) {
        LOG_ERROR(DDPLogModulePlayer, @"%@ 解析失败", media.url);
    }
}


#pragma mark 属性
- (DDPMediaType)mediaType {
    return [self.media.url isFileURL] ? DDPMediaTypeLocaleMedia : DDPMediaTypeNetMedia;
}

- (NSTimeInterval)length {
    if (_length > 0) return _length;
    
    _length = _localMediaPlayer.media.length.value.floatValue / 1000.0f;
    return _length;
}

- (NSTimeInterval)currentTime {
    return _localMediaPlayer.time.value.floatValue / 1000.0f;
}

- (DDPMediaPlayerStatus)status {
    switch (_localMediaPlayer.state) {
        case VLCMediaPlayerStateStopped:
            if (self.localMediaPlayer.position >= 0.999) {
                _status = DDPMediaPlayerStatusNextEpisode;
            }
            else {
                _status = DDPMediaPlayerStatusStop;
            }
            break;
        case VLCMediaPlayerStatePaused:
            _status = DDPMediaPlayerStatusPause;
            break;
        case VLCMediaPlayerStatePlaying:
            _status = DDPMediaPlayerStatusPlaying;
            break;
        case VLCMediaPlayerStateBuffering:
            if (self.timeIsUpdate) {
                _status = DDPMediaPlayerStatusPlaying;
            }
            else {
                _status = DDPMediaPlayerStatusPause;
            }
            break;
        default:
            _status = DDPMediaPlayerStatusPause;
            break;
    }
    return _status;
}

#pragma mark 音量
- (void)volumeJump:(CGFloat)value {
    [self setVolume: self.volume + value];
}

- (CGFloat)volume {
    return _localMediaPlayer.audio.volume;
}

- (void)setVolume:(CGFloat)volume {
    if (volume < 0) volume = 0;
    if (volume > MAX_VOLUME) volume = MAX_VOLUME;
    
    _localMediaPlayer.audio.volume = volume;
}

#pragma mark 播放位置
- (void)jump:(int)value completionHandler:(void(^)(NSTimeInterval time))completionHandler {
    [self setPosition:([self currentTime] + value) / [self length] completionHandler:completionHandler];
}

- (void)setCurrentTime:(int)time completionHandler:(void(^)(NSTimeInterval time))completionHandler {
    [self setPosition:time / [self length] completionHandler:completionHandler];
}

- (void)setPosition:(CGFloat)position completionHandler:(void(^)(NSTimeInterval time))completionHandler {
    if (position < 0) position = 0;
    if (position > 1) position = 1;
    
    _localMediaPlayer.position = position;
    NSTimeInterval jumpTime = [self length] * position;
    
    if (completionHandler) completionHandler(jumpTime);
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:userJumpWithTime:)]) {
        [self.delegate mediaPlayer:self userJumpWithTime:jumpTime];
    }
}

- (CGFloat)position {
    return _localMediaPlayer.position;
}

#pragma mark 字幕
- (void)setSubtitleDelay:(CGFloat)subtitleDelay {
    _localMediaPlayer.currentVideoSubTitleDelay = subtitleDelay * 1000000.0;
}

- (CGFloat)subtitleDelay {
    return _localMediaPlayer.currentVideoSubTitleDelay / 1000000.0;
}

- (NSArray *)subtitleIndexs {
    return _localMediaPlayer.videoSubTitlesIndexes;
}

- (NSArray *)subtitleTitles {
    return _localMediaPlayer.videoSubTitlesNames;
}

- (void)setCurrentSubtitleIndex:(int)currentSubtitleIndex {
    _localMediaPlayer.currentVideoSubTitleIndex = currentSubtitleIndex;
}

- (int)currentSubtitleIndex {
    return _localMediaPlayer.currentVideoSubTitleIndex;
}


- (NSArray<NSNumber *> *)audioChannelIndexs {
    return _localMediaPlayer.audioTrackIndexes;
}

- (NSArray<NSString *> *)audioChannelTitles {
    return _localMediaPlayer.audioTrackNames;
}

- (void)setCurrentAudioChannelIndex:(int)currentAudioChannelIndex {
    _localMediaPlayer.currentAudioTrackIndex = currentAudioChannelIndex;
}

- (int)currentAudioChannelIndex {
    return _localMediaPlayer.currentAudioTrackIndex;
}


- (void)setSpeed:(float)speed {
    _localMediaPlayer.rate = speed;
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:rateChange:)]) {
        [self.delegate mediaPlayer:self rateChange:_localMediaPlayer.rate];
    }
}

- (float)speed {
    return _localMediaPlayer.rate;
}

- (void)setVideoAspectRatio:(CGSize)videoAspectRatio {
    if (CGSizeEqualToSize(videoAspectRatio, CGSizeZero)) {
        self.localMediaPlayer.videoAspectRatio = nil;
    }
    else {
        self.localMediaPlayer.videoAspectRatio = (char *)[NSString stringWithFormat:@"%ld:%ld", (long)videoAspectRatio.width, (long)videoAspectRatio.height].UTF8String;
    }
}

#pragma mark 播放器控制
- (BOOL)isPlaying {
    return [_localMediaPlayer isPlaying];
}

- (void)play {
    [_localMediaPlayer play];
}

- (void)pause {
    [_localMediaPlayer pause];
}

- (void)stop {
    [_localMediaPlayer stop];
}


#pragma mark 功能
- (void)saveVideoSnapshotwithSize:(CGSize)size completionHandler:(SnapshotCompleteBlock)completion {
    //vlc截图方式
    NSError *error = nil;
    NSString *directoryPath = [NSString stringWithFormat:@"%@/VLC_snapshot", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    //创建文件错误
    if (error) {
        if (completion) {
            completion(nil, error);
        }
        return;
    }
    
    self.snapshotCompleteBlock = completion;
    
    NSString *aPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu", (unsigned long)[NSDate date].hash]];
    if ([self.media.url.absoluteString containsString:@"smb"]) {
        UIView *aView = self.localMediaPlayer.drawable;
        UIImage *tempImage = [aView snapshotImageAfterScreenUpdates:YES];
        [self saveImage:tempImage];
    }
    else {
        [self.localMediaPlayer saveVideoSnapshotAt:aPath withWidth:size.width andHeight:size.height];
    }
}

- (int)openVideoSubTitlesFromFile:(NSURL *)path {
    //    if (self.mediaType == DDPMediaTypeLocaleMedia) {
    return [_localMediaPlayer addPlaybackSlave:path type:VLCMediaPlaybackSlaveTypeSubtitle enforce:YES];
    //    }
    
    //    return [_localMediaPlayer openVideoSubTitlesFromFile:a];
}

- (void)setMedia:(id<DDPMediaItemProtocol>)media {
    if (!media) return;
    
    _media = media;
    NSDictionary *mediaOptions = media.mediaOptions;
    if ([mediaOptions[@"isWebDav"] isEqual:@(YES)]) {
        NSNumber *fileSize = mediaOptions[@"fileSize"];
        DDPWebDAVInputStream *stream = [[DDPWebDAVInputStream alloc] initWithURL:_media.url fileLength:fileSize.integerValue];
        stream.delegate = self.class.streamDelegate;
        [stream open];
        [self.class.streamDelegate.inputStreams addObject:stream];
        VLCMedia *vlcMedia = [[VLCMedia alloc] initWithStream:stream];
        vlcMedia.delegate = self;
        self.localMediaPlayer.media = vlcMedia;
    } else {
        VLCMedia *vlcMedia = [[VLCMedia alloc] initWithURL:_media.url];
        vlcMedia.delegate = self;
        if (media.mediaOptions) {
            [vlcMedia addOptions:media.mediaOptions];
        }
        self.localMediaPlayer.media = vlcMedia;
    }
    
    
    LOG_INFO(DDPLogModulePlayer, @"设置播放路径：%@", _media.url);
    
    _length = -1;
}

#pragma mark - VLCMediaPlayerDelegate
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:progress:currentTime:totalTime:)]) {
        NSTimeInterval nowTime = [self currentTime];
        NSTimeInterval videoTime = [self length];
        
        NSString *nowDateTime = ddp_mediaFormatterTime(nowTime);
        NSString *videoDateTime = ddp_mediaFormatterTime(videoTime);
        
        CGFloat progress = videoTime == 0 ? 0.0 : nowTime / videoTime;
        
        if (!(videoDateTime && nowDateTime)) return;
        [self.delegate mediaPlayer:self progress:progress currentTime:nowDateTime totalTime:videoDateTime];
    }
    
    @weakify(self)
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        self.timeIsUpdate = NO;
    } repeats:NO];
    
    if (self.timeIsUpdate == NO) {
        self.timeIsUpdate = YES;
        [self mediaPlayerStateChanged:nil];
    }
}

- (void)mediaPlayerSnapshot:(NSNotification *)aNotification {
    UIImage *tempImage = self.localMediaPlayer.lastSnapshot;
    [self saveImage:tempImage];
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    LOG_INFO(DDPLogModulePlayer, @"播放器状态 %@", VLCMediaPlayerStateToString(self.localMediaPlayer.state));
    
    if ([self.delegate respondsToSelector:@selector(mediaPlayer:statusChange:)]) {
        DDPMediaPlayerStatus status = [self status];
        [self.delegate mediaPlayer:self statusChange:status];
    }
}

- (void)mediaDidFinishParsing:(VLCMedia *)aMedia {
    void(^action)(void) = objc_getAssociatedObject(aMedia, &mediaParsingCompletionKey);
    if (action) {
        action();
    }
    
    objc_setAssociatedObject(aMedia, &mediaParsingCompletionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 私有方法
- (void)saveImage:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                if (self.snapshotCompleteBlock) {
                    self.snapshotCompleteBlock(image, nil);
                    self.snapshotCompleteBlock = nil;
                }
            }
            else {
                if (self.snapshotCompleteBlock) {
                    self.snapshotCompleteBlock(nil, error);
                    self.snapshotCompleteBlock = nil;
                }
            }
        });
    }];
}

//电话事件
- (void)handleInterreption:(NSNotification *)aNotification {
    BOOL interruption = [aNotification.userInfo[AVAudioSessionInterruptionTypeKey] boolValue];
    //中断
    if (interruption) {
        if (self.isPlaying) {
            [self pause];
        }
    }
    //恢复
    else {
//        if (self.isPlaying == NO) {
//            [self play];
//        }
    }
}

#pragma mark 播放结束
- (void)playEnd:(NSNotification *)sender {
    if (self.mediaType == DDPMediaTypeNetMedia) {
        _status = DDPMediaPlayerStatusStop;
        if ([self.delegate respondsToSelector:@selector(mediaPlayer:statusChange:)]) {
            [self.delegate mediaPlayer:self statusChange:DDPMediaPlayerStatusStop];
        }
    }
}

#pragma mark - 懒加载
- (VLCMediaPlayer *)localMediaPlayer {
    if(_localMediaPlayer == nil) {
        _localMediaPlayer = [[VLCMediaPlayer alloc] init];
        _localMediaPlayer.drawable = self.mediaView;
        _localMediaPlayer.delegate = self;
    }
    return _localMediaPlayer;
}

- (UIView *)mediaView {
    if (_mediaView == nil) {
        _mediaView = [[UIView alloc] init];
    }
    return _mediaView;
}

+ (DDPMediaStreamDelegate *)streamDelegate {
    static DDPMediaStreamDelegate *streamDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamDelegate = [DDPMediaStreamDelegate new];
    });
    return streamDelegate;
}

@end
