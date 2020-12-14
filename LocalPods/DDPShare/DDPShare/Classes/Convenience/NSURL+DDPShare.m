//
//  NSURL+DDPShare.m
//  DDPShare
//
//  Created by JimHuang on 2019/9/1.
//

#import "NSURL+DDPShare.h"

@interface _DDPNSURLToMessageModel : NSObject<DDPMessageProtocol>
@property (strong, nonatomic) NSString *messageTo;
@property (strong, nonatomic) NSString *messageType;
@property (strong, nonatomic) NSDictionary * _Nullable messageParameter;
@end

@implementation _DDPNSURLToMessageModel

@end


@implementation NSURL (DDPShare)

- (id<DDPMessageProtocol>)makeMessage {
    NSURLComponents *com = [[NSURLComponents alloc] initWithString:self.absoluteString];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:com.queryItems.count];
    
    _DDPNSURLToMessageModel *model = [[_DDPNSURLToMessageModel alloc] init];
    
    [com.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj.name] = obj.value;
    }];
    
    model.messageTo = com.scheme;
    model.messageType = com.host;
    model.messageParameter = dic;
    return model;
}

@end
