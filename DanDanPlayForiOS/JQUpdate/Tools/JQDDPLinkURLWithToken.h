//
//  JQDDPLinkURLWithToken.h
//  DanDanPlayForiOS
//
//  Created by JeffersonQin on 2021/4/16.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDPMacroDefinition.h"
#import "DDPConstant.h"
#import "DDPCacheManager.h"

#ifndef JQDDPLinkURLWithToken_h
#define JQDDPLinkURLWithToken_h

@interface JQDDPLinkURLWithToken : NSObject

+ (NSURL *)ddp_linkImageURL_withToken:(NSString *)ip hash:(NSString *)hash;
+ (NSURL *)ddp_linkVideoURL_withToken:(NSString *)ip hash:(NSString *)hash;
+ (NSURL *)ddp_linkSubtitleURL_withToken:(NSString *)ip Id:(NSString *)Id fileName:(NSString *)fileName;

@end

#endif /* JQDDPLinkURLWithToken_h */
