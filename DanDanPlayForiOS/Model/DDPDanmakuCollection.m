//
//  DDPDanmakuCollection.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/4/18.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "DDPDanmakuCollection.h"

@implementation DDPDanmakuCollection

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"collection" : [DDPDanmaku class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"collection" : @"Comments"};
}

@end
