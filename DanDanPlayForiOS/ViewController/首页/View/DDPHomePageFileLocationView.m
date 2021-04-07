//
//  DDPHomePageFileLocationView.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2018/10/11.
//  Copyright © 2018 JimHuang. All rights reserved.
//

#import "DDPHomePageFileLocationView.h"
#import "DDPFileManagerViewController.h"
#import "DDPSMBViewController.h"
#import "DDPQRScannerViewController.h"
#import "DDPLinkFileManagerViewController.h"
#import "../../../JQUpdate/Tools/JQDDPLinkFileRedirector.h"

@implementation DDPHomePageFileLocationView

- (IBAction)touchPhoneButton:(UIButton *)sender {
    DDPFileManagerViewController *vc = [[DDPFileManagerViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.file = ddp_getANewRootFile();
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchSMBButton:(UIButton *)sender {
    DDPSMBViewController *vc = [[DDPSMBViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchComputerButton:(UIButton *)sender {
    //已经登录
    if ([DDPCacheManager shareCacheManager].linkInfo) {
        UIAlertController *versionChoosingVC = [UIAlertController alertControllerWithTitle:@"选择远程连接查看器版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [versionChoosingVC addAction:[UIAlertAction actionWithTitle:@"v1" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            DDPLinkFileManagerViewController *vc = [[DDPLinkFileManagerViewController alloc] init];
            vc.file = ddp_getANewLinkRootFile();
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }]];
        [versionChoosingVC addAction:[UIAlertAction actionWithTitle:@"v2 (推荐)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到自己的界面
            [JQDDPLinkFileRedirector redirectFrom:self.viewController push:YES];
        }]];
        [self.viewController presentViewController:versionChoosingVC animated:YES completion:nil];
    }
    else {
        DDPQRScannerViewController *vc = [[DDPQRScannerViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        @weakify(self)
        vc.linkSuccessCallBack = ^(DDPLinkInfo *info) {
            @strongify(self)
            if (!self) return;
            
            UIAlertController *versionChoosingVC = [UIAlertController alertControllerWithTitle:@"选择远程连接查看器版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [versionChoosingVC addAction:[UIAlertAction actionWithTitle:@"v1" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //连接成功直接跳转到列表
                DDPLinkFileManagerViewController *avc = [[DDPLinkFileManagerViewController alloc] init];
                avc.file = ddp_getANewLinkRootFile();
                avc.hidesBottomBarWhenPushed = YES;
                
                NSMutableArray *arr = [self.viewController.navigationController.viewControllers mutableCopy];
                [arr removeLastObject];
                [arr addObject:avc];
                [self.viewController.navigationController setViewControllers:arr animated:YES];
            }]];
            [versionChoosingVC addAction:[UIAlertAction actionWithTitle:@"v2 (推荐)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳转到自己的界面
                [JQDDPLinkFileRedirector redirectFrom:self.viewController push:NO];
            }]];
            [self.viewController presentViewController:versionChoosingVC animated:YES completion:nil];
        };
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}



@end
