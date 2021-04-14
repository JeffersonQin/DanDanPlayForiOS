//
//  DDPSubtitle.h
//  DanDanPlayForiOS
//
//  Created by JeffersonQin on 2021/4/14.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

#ifndef DDPSubtitle_h
#define DDPSubtitle_h

#import "DDPBase.h"

@interface DDPSubtitle : DDPBase

/**
 字幕文件名
 */
@property (copy, nonatomic) NSString *fileName;

/**
 字幕文件大小
 */
@property (assign, nonatomic) NSUInteger fileSize;

@end

#endif /* DDPSubtitle_h */
