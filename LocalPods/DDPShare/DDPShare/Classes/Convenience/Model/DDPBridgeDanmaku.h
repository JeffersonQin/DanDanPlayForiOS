//
//  DDPBridgeDanmaku.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import "DDPBridgeBase.h"

typedef NS_ENUM(NSUInteger, DDPDanmakuMode) {
    DDPDanmakuModeNormal = 1,
    DDPDanmakuModeBottom = 4,
    DDPDanmakuModeTop = 5,
};

NS_ASSUME_NONNULL_BEGIN

@interface DDPBridgeDanmaku : DDPBridgeBase

/*
 
 identity -> CId 弹幕编号，此编号在同一个弹幕库中唯一，且新弹幕永远比旧弹幕编号要大。
 
 */

/**
 *  Time: 浮点数形式的弹幕时间，单位为秒。
 */
@property (nonatomic, assign) NSTimeInterval time;
/**
 *  Mode: 弹幕模式，1普通弹幕，4底部弹幕，5顶部弹幕。
 */
@property (nonatomic, assign) DDPDanmakuMode mode;
/**
 *  Color: 32位整形数的弹幕颜色，算法为 R*256*256 + G*256 + B。
 */
@property (nonatomic, assign) uint32_t color;

/**
 弹幕发送时间戳，单位为毫秒。可以理解为Unix时间戳，但起始点为1970年1月1日7:00:00。
 */
@property (assign, nonatomic) NSTimeInterval timestamp;

/**
 *  Message: 弹幕内容文字。\r和\n不会作为换行转义符。
 */
@property (nonatomic, strong) NSString* message;

/**
 用户id 可能为第三方弹幕
 */
@property (copy, nonatomic) NSString *UId;

#pragma mark - 自定义属性
/**
 *  是否被过滤
 */
@property (assign, nonatomic, getter=isFilter) BOOL filter;

@end

NS_ASSUME_NONNULL_END
