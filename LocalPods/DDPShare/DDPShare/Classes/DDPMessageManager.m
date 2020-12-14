//
//  DDPMessageManager.m
//  DDPlayMacPlayer
//
//  Created by JimHuang on 2019/7/28.
//  Copyright © 2019 JimHuang. All rights reserved.
//

#import "DDPMessageManager.h"
#if !TARGET_OS_IPHONE
#import <Cocoa/Cocoa.h>
#endif
#import <objc/runtime.h>

@interface DDPMessageManager ()
@property (strong, nonatomic) NSHashTable *observers;
@end

@implementation DDPMessageManager

+ (DDPMessageManager *)sharedManager {
    static dispatch_once_t onceToken;
    static DDPMessageManager *_manager;
    dispatch_once(&onceToken, ^{
        _manager = [[DDPMessageManager alloc] init];
    });
    return _manager;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserver:(id<DDPMessageManagerObserver>)observer {
    if ([self.observers containsObject:observer] == NO) {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id<DDPMessageManagerObserver>)observer {
    if ([self.observers containsObject:observer]) {
        [self.observers removeObject:observer];
    }
}

- (void)sendMessage:(id<DDPMessageProtocol>)message {
    NSAssert(message.messageTo.length > 0 &&
             message.messageType.length > 0, @"消息参数有误");

    NSURLComponents *com = [[NSURLComponents alloc] init];
    com.host = message.messageType;
    com.scheme = message.messageTo;
    
    NSDictionary *dic = message.messageParameter;
    
    NSMutableArray <NSURLQueryItem *>*arr = [NSMutableArray arrayWithCapacity:dic.count];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *strValue = [NSString stringWithFormat:@"%@", obj];
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:strValue];
        [arr addObject:item];
    }];
    
    {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:@"_channelId" value:@"dandanplay"];
        [arr addObject:item];
    }
    
    com.queryItems = arr;
    
    [self _sendMessageWithURL:com.URL completion:^(BOOL success) {
        if (!success) {
            NSLog(@"发送消息出错");
        }
    }];
}

- (void)_sendMessageWithURL:(NSURL *)url completion:(void(^)(BOOL success))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
#if TARGET_OS_IPHONE
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (completion) {
                    completion(success);
                }
            }];
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            if (completion) {
                completion(success);
            }
        }
#else
        NSWorkspaceOpenConfiguration *config = [NSWorkspaceOpenConfiguration configuration];
        
        __block BOOL appIsRunning = NO;
        NSArray <NSRunningApplication *>*runningApp = [[NSWorkspace sharedWorkspace] runningApplications];
        [runningApp enumerateObjectsUsingBlock:^(NSRunningApplication * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.bundleIdentifier isEqualToString:@"maccatalyst.com.dandanplay.iosplayer"]) {
                appIsRunning = YES;
                *stop = YES;
            }
        }];
        
        config.allowsRunningApplicationSubstitution = NO;
        config.activates = !appIsRunning;
        [[NSWorkspace sharedWorkspace] openURL:url configuration:config completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
            if (completion) {
                completion(error == nil);
            }
        }];
#endif        
    });
}

- (void)receiveMessage:(id<DDPMessageProtocol>)message {
    if (message == nil) {
        return;
    }
    
    if (![message.messageParameter[@"_channelId"] isEqual:@"dandanplay"]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<DDPMessageManagerObserver>obj in [self.observers copy]) {
            if ([obj respondsToSelector:@selector(dispatchManager:didReceiveMessages:)]) {
                [obj dispatchManager:self didReceiveMessages:@[message]];
            }
        }
    });
}

#pragma mark - 懒加载
- (NSHashTable *)observers {
    if (_observers == nil) {
        _observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPointerPersonality capacity:0];
    }
    return _observers;
}


@end
