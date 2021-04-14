//
//  DDPSubtitle.m
//  DDPlay
//
//  Created by JeffersonQin on 2021/4/14.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

#import "DDPSubtitle.h"

@implementation DDPSubtitle

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"fileName" : @"fileName",
        @"fileSize" : @"fileSize"
    };
}

@end
