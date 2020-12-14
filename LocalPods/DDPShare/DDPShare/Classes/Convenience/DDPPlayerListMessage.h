//
//  DDPPlayerListMessage.h
//  DDPShare
//
//  Created by JimHuang on 2019/10/9.
//

#import "DDPBaseMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPPlayerListMessage : DDPBaseMessage
@property (nonatomic, strong) NSArray <NSString *>*paths;
@end

NS_ASSUME_NONNULL_END
