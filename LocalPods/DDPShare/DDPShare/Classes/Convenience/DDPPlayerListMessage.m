//
//  DDPPlayerListMessage.m
//  DDPShare
//
//  Created by JimHuang on 2019/10/9.
//

#import "DDPPlayerListMessage.h"
#import "DDPBaseMessage+DDPPrivate.h"
#import "DDPBridgeDanmaku.h"
#import "NSData+DDPMessage.h"

@implementation DDPPlayerListMessage

+ (NSString *)pathKey {
    return NSStringFromSelector(@selector(paths));
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    NSString *key = [self.class pathKey];
    NSString *value = dic[key];
    if (value) {
        NSMutableDictionary *mDic = [dic mutableCopy];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:kNilOptions];
        NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        mDic[key] = jsonObj;
        return mDic;
    }
    return dic;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSString *key = [self.class pathKey];
    NSArray *value = dic[key];
    if (value) {
        NSData *date = [NSJSONSerialization dataWithJSONObject:value options:kNilOptions error:nil];
        NSString *base64Str = [date ddp_base64EncodedString];
        dic[key] = base64Str;
    }
    
    return YES;
}

@end
