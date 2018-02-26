//
//  CALayer+Tools.h
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/9/8.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Tools)
- (void)ddp_setImageWithURL:(NSURL *)imageURL;
- (void)ddp_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;
@end
