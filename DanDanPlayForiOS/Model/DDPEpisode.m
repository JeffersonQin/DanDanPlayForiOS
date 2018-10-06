//
//  DDPEpisode.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/4/18.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "DDPEpisode.h"

@implementation DDPEpisode

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"identity" : @[@"Id", @"episodeId"],
             @"name" : @[@"Title", @"episodeTitle"],
             @"time" : @"Time",
             @"isOnAir" : @"IsOnAir"};
}

@end
