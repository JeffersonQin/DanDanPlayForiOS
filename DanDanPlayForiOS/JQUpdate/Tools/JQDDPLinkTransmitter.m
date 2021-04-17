//
//  JQDDPLinkTransmitter.m
//  DDPlay
//
//  Created by JeffersonQin on 2021/4/7.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQDDPLinkTransmitter.h"
#import "../../Model/DDPLinkInfo.h"
#import "../../Tools/DDPCacheManager.h"
#import "../../Tools/DDPToolsManager.h"

@implementation JQDDPLinkTransmitter

+ (DDPCacheManager *) getCacheManager {
    return [DDPCacheManager shareCacheManager];
}

+ (DDPToolsManager *) getToolsManager {
    return [DDPToolsManager shareToolsManager];
}

+ (DDPLinkInfo *) getLinkInfo {
    return [JQDDPLinkTransmitter getCacheManager].linkInfo ?: [DDPCacheManager shareCacheManager].lastLinkInfo;
}

@end
