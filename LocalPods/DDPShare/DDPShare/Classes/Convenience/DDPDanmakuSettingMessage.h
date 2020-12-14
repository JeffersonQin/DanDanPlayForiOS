//
//  DDPDanmakuSettingMessage.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import "DDPBaseMessage.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDPBridgeFilter;

#if TARGET_OS_IPHONE
typedef UIFont DDPFont;
#else
typedef NSFont DDPFont;
#endif

@interface DDPDanmakuSettingMessage : DDPBaseMessage
@property (strong, nonatomic) DDPFont *danmakuFont;

@property (strong, nonatomic) NSNumber *subtitleProtectArea;

/*
 isRegex BOOL
 content NSString
 enable BOOL
 */
@property (strong, nonatomic) NSArray <DDPBridgeFilter *>*filters;

#pragma mark - 播放器相关
@property (strong, nonatomic) NSNumber * _Nullable danmakuSpeed;
@property (strong, nonatomic) NSNumber * _Nullable danmakuOpacity;
@property (strong, nonatomic) NSNumber * _Nullable danmakuLimitCount;

@property (strong, nonatomic) NSNumber * _Nullable danmakuEffectStyle;
@property (strong, nonatomic) NSNumber * _Nullable danmakuShieldType;
@property (strong, nonatomic) NSNumber * _Nullable danmakuOffsetTime;
@property (strong, nonatomic) NSNumber * _Nullable playerSpeed;
@end

NS_ASSUME_NONNULL_END
