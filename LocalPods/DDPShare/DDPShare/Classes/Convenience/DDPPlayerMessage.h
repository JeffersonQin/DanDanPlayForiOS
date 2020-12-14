//
//  DDPPlayerMessage.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/4.
//

#import "DDPLoalLocalDanmakuMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPPlayerMessage : DDPLoalLocalDanmakuMessage
@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSString *matchName;
@property (assign, nonatomic) NSInteger episodeId;
@end

NS_ASSUME_NONNULL_END
