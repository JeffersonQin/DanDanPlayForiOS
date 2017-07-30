//
//  WebViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController<WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) NSURL *URL;

/**
 显示顶部的进度条 默认YES
 */
@property (assign, nonatomic) BOOL showProgressView;
@end