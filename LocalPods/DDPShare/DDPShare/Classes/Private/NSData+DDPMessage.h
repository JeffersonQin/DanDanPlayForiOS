//
//  NSData+DDPMessage.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (DDPMessage)

- (NSString *)ddp_base64EncodedString;

@end

NS_ASSUME_NONNULL_END
