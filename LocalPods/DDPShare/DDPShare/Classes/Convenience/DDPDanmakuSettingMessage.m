//
//  DDPDanmakuSettingMessage.m
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import "DDPDanmakuSettingMessage.h"
#import "NSData+DDPMessage.h"
#import "DDPBaseMessage+DDPPrivate.h"
#import "DDPBridgeFilter.h"

@implementation DDPDanmakuSettingMessage

+ (NSString *)filtersKey {
    return NSStringFromSelector(@selector(filters));
}

+ (NSString *)fontKey {
    return NSStringFromSelector(@selector(danmakuFont));
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    NSMutableDictionary *mDic = [dic mutableCopy];
    
    {
        NSString *key = [self.class filtersKey];
        
        NSString *str = mDic[key];
        if (str) {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:kNilOptions];
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            mDic[key] = obj;
        }
    }
    
    return mDic;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    NSString *key = [self.class fontKey];
    
    id value = dic[key];
    if ([value isKindOfClass:[NSString class]]) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:kNilOptions];
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *name = obj[@"fontName"];
        CGFloat size = [(NSNumber *)obj[@"fontSize"] doubleValue];
        _danmakuFont = [DDPFont fontWithName:name size:size];
        if (_danmakuFont == nil) {
            _danmakuFont = [DDPFont systemFontOfSize:size];
        }
    } else if ([value isKindOfClass:[DDPFont class]]) {
        _danmakuFont = value;
    }
    
    return YES;
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    {
        NSString *key = [self.class filtersKey];
        
        NSArray *obj = dic[key];
        if (obj) {
            NSData *date = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:nil];
            NSString *base64Str = [date ddp_base64EncodedString];
            dic[key] = base64Str;
        }
    }
    
    if (self.danmakuFont) {
        NSString *key = [self.class fontKey];
        
        NSMutableDictionary *obj = [NSMutableDictionary dictionary];
        obj[@"fontName"] = self.danmakuFont.fontName;
        obj[@"fontSize"] = @(self.danmakuFont.pointSize);
        NSData *date = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:nil];
        NSString *base64Str = [date ddp_base64EncodedString];
        dic[key] = base64Str;
    }
    
    return YES;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{[self filtersKey] : [DDPBridgeFilter class]};
}

@end
