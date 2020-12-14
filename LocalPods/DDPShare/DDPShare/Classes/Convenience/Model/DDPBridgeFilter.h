//
//  DDPBridgeFilter.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import "DDPBridgeBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPBridgeFilter : DDPBridgeBase
/*
  name 屏蔽规则名称
 */

/**
 是否为正则表达式
 */
@property (assign, nonatomic) BOOL isRegex;

/**
 内容
 */
@property (copy, nonatomic) NSString *content;

@property (assign, nonatomic) BOOL enable;


/// 是否是云端规则
@property (nonatomic, assign, getter=isCloudRule) BOOL cloudRule;
@end

NS_ASSUME_NONNULL_END
