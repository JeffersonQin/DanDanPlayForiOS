//
//  DDPSendDanmakuMessage.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/13.
//

#import "DDPBaseMessage.h"

NS_ASSUME_NONNULL_BEGIN
@class DDPBridgeDanmaku;

@interface DDPSendDanmakuMessage : DDPBaseMessage
@property (assign, nonatomic) NSInteger episodeId;
@property (strong, nonatomic) DDPBridgeDanmaku * _Nullable danmaku;
@end

NS_ASSUME_NONNULL_END
