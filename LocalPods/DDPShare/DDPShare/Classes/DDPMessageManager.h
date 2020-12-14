//
//  DDPMessageManager.h
//  DDPlayMacPlayer
//
//  Created by JimHuang on 2019/7/28.
//  Copyright © 2019 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDPMessageProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class DDPMessageManager;

@protocol DDPMessageManagerObserver <NSObject>
@optional
- (void)dispatchManager:(DDPMessageManager *)manager didReceiveMessages:(NSArray <id<DDPMessageProtocol>>*)messages;
@end

@interface DDPMessageManager : NSObject

@property (strong, nonatomic, class, readonly) DDPMessageManager *sharedManager;

- (void)addObserver:(id<DDPMessageManagerObserver>)observer;
- (void)removeObserver:(id<DDPMessageManagerObserver>)observer;

- (void)sendMessage:(id<DDPMessageProtocol>)message;
- (void)receiveMessage:(id<DDPMessageProtocol>)message;

@end

NS_ASSUME_NONNULL_END
