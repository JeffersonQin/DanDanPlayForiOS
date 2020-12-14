//
//  NSURL+DDPShare.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/1.
//

#import "DDPMessageProtocol.h"


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (DDPShare)

- (id<DDPMessageProtocol>)makeMessage;

@end

NS_ASSUME_NONNULL_END
