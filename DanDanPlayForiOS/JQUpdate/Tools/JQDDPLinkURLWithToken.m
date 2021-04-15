//
//  JQDDPLinkURLWithToken.m
//  DDPlay
//
//  Created by JeffersonQin on 2021/4/16.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

#import "JQDDPLinkURLWithToken.h"

@implementation JQDDPLinkURLWithToken

+ (NSString *)getAPIToken {
    return [[DDPCacheManager shareCacheManager].linkInfo.apiToken stringByURLEncode];
}

+ (NSURL *)ddp_linkImageURL_withToken:(NSString *)ip hash:(NSString *)hash {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@", ddp_linkImageURL(ip, hash), [JQDDPLinkURLWithToken getAPIToken]]];
}

+(NSURL *)ddp_linkVideoURL_withToken:(NSString *)ip hash:(NSString *)hash {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@", ddp_linkVideoURL(ip, hash), [JQDDPLinkURLWithToken getAPIToken]]];
}

+ (NSURL *)ddp_linkSubtitleURL_withToken:(NSString *)ip Id:(NSString *)Id fileName:(NSString *)fileName {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@&token=%@", ddp_linkSubtitleURL(ip, Id, fileName), [JQDDPLinkURLWithToken getAPIToken]]];
}

@end
