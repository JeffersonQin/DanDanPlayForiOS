//
//  DDPLoalLocalDanmakuMessage.m
//  DDPShare
//
//  Created by JimHuang on 2019/11/26.
//

#import "DDPLoalLocalDanmakuMessage.h"
#import "DDPBaseMessage+DDPPrivate.h"
#import "DDPBridgeDanmaku.h"
#import "NSData+DDPMessage.h"

@implementation DDPLoalLocalDanmakuMessage

+ (NSString *)danmakuKey {
    return NSStringFromSelector(@selector(danmaku));
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    NSString *key = [self.class danmakuKey];
    NSString *danmaku = dic[key];
    if (danmaku) {
        NSMutableDictionary *mDic = [dic mutableCopy];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:danmaku options:kNilOptions];
        NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        mDic[key] = jsonObj;
        return mDic;
    }
    return dic;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSString *key = [self.class danmakuKey];
    NSArray *filters = dic[key];
    if (filters) {
        NSData *date = [NSJSONSerialization dataWithJSONObject:filters options:kNilOptions error:nil];
        NSString *base64Str = [date ddp_base64EncodedString];
        dic[key] = base64Str;
    }
    
    return YES;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{[self danmakuKey] : [DDPBridgeDanmaku class]};
}

@end
