//
//  DDPFilterCollection.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/4/18.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "DDPFilterCollection.h"

@implementation DDPFilterCollection

+ (Class)entityClass {
    return [DDPFilter class];
}

+ (NSString *)collectionKey {
    return @"FilterItem";
}

@end
