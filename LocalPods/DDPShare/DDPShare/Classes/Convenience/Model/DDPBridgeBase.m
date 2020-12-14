//
//  DDPBridgeBase.m
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import "DDPBridgeBase.h"

@implementation DDPBridgeBase

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)mutableCopy {
    return [self yy_modelCopy];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

@end
