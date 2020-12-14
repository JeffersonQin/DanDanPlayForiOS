//
//  DDPBaseMessage.m
//  DDPShare
//
//  Created by JimHuang on 2019/9/4.
//

#import "DDPBaseMessage.h"
#import <YYModel/YYModel.h>
#import "DDPBaseMessage+DDPPrivate.h"

@implementation DDPBaseMessage

- (NSString *)messageType {
    return self.class.messageType;
}

+ (NSString *)messageType {
    return NSStringFromClass(self.class);
}

- (NSDictionary<NSString *,NSString *> *)messageParameter {
    NSDictionary *dic = [self yy_modelToJSONObject];
    return dic;
}

- (instancetype)initWithObj:(id<DDPMessageProtocol>)obj {
    self = [self init];
    if (self) {
        _messageTo = obj.messageTo;
        _messageType = obj.messageType;
        [self yy_modelSetWithDictionary:obj.messageParameter];
    }
    return self;
}

+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return @[NSStringFromSelector(@selector(messageParameter))];
}

@end
