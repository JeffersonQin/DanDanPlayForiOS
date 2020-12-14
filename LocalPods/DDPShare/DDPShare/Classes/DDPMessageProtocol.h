//
//  DDPMessageModel.h
//  DDPlayMacPlayer
//
//  Created by JimHuang on 2019/7/28.
//  Copyright © 2019 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDPMessageProtocol <NSObject>
@property (strong, nonatomic) NSString *messageTo;
@property (strong, nonatomic) NSString *messageType;
@property (strong, nonatomic, readonly) NSDictionary * _Nullable messageParameter;

@end



NS_ASSUME_NONNULL_END
