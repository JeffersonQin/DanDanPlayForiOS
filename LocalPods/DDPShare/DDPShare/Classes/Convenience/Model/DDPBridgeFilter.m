//
//  DDPBridgeFilter.m
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import "DDPBridgeFilter.h"

@implementation DDPBridgeFilter
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"isRegex" : @"IsRegex",
             @"name" : @"Name",
             @"content" : @"_text"
             };
}

- (NSUInteger)hash {
    if (self.identity == 0) {
        return self.name.hash;
    }
    
    if (self.name.length == 0) {
        return self.identity;
    }
    
    return self.identity ^ self.name.hash;
}

- (BOOL)isEqual:(DDPBridgeFilter *)object {
    if ([object isKindOfClass:self.class] == NO) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    return self.identity == object.identity && [self.name isEqualToString:object.name];
}
@end
