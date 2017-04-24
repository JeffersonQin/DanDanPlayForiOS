//
//  MBProgressHUD+Tools.m
//  Fumuzhihui
//
//  Created by JimHuang on 16/5/11.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "MBProgressHUD+Tools.h"

static MBProgressHUD *progressHUD = nil;

@implementation MBProgressHUD (Tools)
+ (void)showWithText:(NSString *)text {
    [self showWithText:text atView:nil];
}

+ (void)showWithText:(NSString *)text atView:(UIView *)view {
    
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [self defaultTypeHUDWithMode:MBProgressHUDModeText InView:view];
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)showWithError:(NSError *)error {
    [self showWithText:error.domain atView:nil];
}

+ (void)showIndeterminateHUDWithView:(UIView *)view text:(NSString *)text {
    if (!text.length) text = @"加载中...";
    
    [self hideIndeterminateHUD];
    
    progressHUD = [self defaultTypeHUDWithMode:MBProgressHUDModeIndeterminate InView:view];
    progressHUD.label.text = text;
}

+ (instancetype)showProgressHUDInView:(UIView *)view {
    MBProgressHUD *progressHUD = [self defaultTypeHUDWithMode:MBProgressHUDModeAnnularDeterminate InView:view];
    return progressHUD;
}

+ (instancetype)defaultTypeHUDWithMode:(MBProgressHUDMode)mode InView:(UIView *)view {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *aHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    aHUD.mode = mode;
    aHUD.bezelView.color = RGBACOLOR(0, 0, 0, 0.8);
    aHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    aHUD.label.textColor = [UIColor whiteColor];
    aHUD.contentColor = [UIColor whiteColor];
    return aHUD;
}

+ (void)hideIndeterminateHUD {
    if (progressHUD) {
        [progressHUD hideAnimated:YES];
        progressHUD = nil;
    }
}
@end
