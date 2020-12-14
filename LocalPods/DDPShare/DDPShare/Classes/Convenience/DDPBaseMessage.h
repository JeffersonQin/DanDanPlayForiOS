//
//  DDPBaseMessage.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/4.
//

#import <Foundation/Foundation.h>
#import "DDPMessageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPBaseMessage : NSObject<DDPMessageProtocol>
@property (strong, nonatomic) NSString *messageTo;
@property (strong, nonatomic) NSString *messageType;
@property (strong, nonatomic, readonly) NSDictionary <NSString *, NSString *>* messageParameter;

+ (NSString *)messageType;

- (instancetype)initWithObj:(id<DDPMessageProtocol>)obj;
@end

NS_ASSUME_NONNULL_END
