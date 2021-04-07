//
//  JQDDPLinkTransmitter.h
//  DanDanPlayForiOS
//
//  Created by JeffersonQin on 2021/4/7.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef JQDDPLinkTransmitter_h
#define JQDDPLinkTransmitter_h

@class DDPLinkInfo;
@class DDPCacheManager;
@class DDPToolsManager;

@interface JQDDPLinkTransmitter : NSObject

+ (DDPToolsManager *) getToolsManager;

+ (DDPCacheManager *) getCacheManager;

+ (DDPLinkInfo *) getLinkInfo;

@end

#endif /* JQDDPLinkTransmitter_h */
