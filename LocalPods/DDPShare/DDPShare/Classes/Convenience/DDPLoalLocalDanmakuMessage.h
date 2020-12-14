//
//  DDPLoalLocalDanmakuMessage.h
//  DDPShare
//
//  Created by JimHuang on 2019/11/26.
//

#import "DDPBaseMessage.h"

NS_ASSUME_NONNULL_BEGIN
@class DDPBridgeDanmaku;
@interface DDPLoalLocalDanmakuMessage : DDPBaseMessage
@property (copy, nonatomic) NSArray <DDPBridgeDanmaku *>*danmaku;
@end

NS_ASSUME_NONNULL_END
