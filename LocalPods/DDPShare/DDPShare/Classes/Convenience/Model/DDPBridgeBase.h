//
//  DDPBridgeBase.h
//  DDPShare
//
//  Created by JimHuang on 2019/9/8.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDPBridgeBase : NSObject<YYModel, NSCoding, NSCopying>
@property (assign, nonatomic) NSUInteger identity;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *desc;
@end

NS_ASSUME_NONNULL_END
