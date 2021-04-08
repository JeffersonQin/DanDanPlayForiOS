//
//  JQDDPLinkFileRedirector.m
//  DDPlay
//
//  Created by JeffersonQin on 2021/4/7.
//  Copyright © 2021 JimHuang. All rights reserved.
//

#import "JQDDPLinkFileRedirector.h"
#import "DDPlay-Swift.h"

@implementation JQDDPLinkFileRedirector

+ (void) redirectFrom:(UIViewController *) presentViewController push:(bool) flag {
//    JQDDPLinkFileTableViewController *jqvc = [[JQDDPLinkFileTableViewController alloc] init];
    JQDDPLinkFileTableViewController *jqvc = [[UIStoryboard storyboardWithName:@"Update" bundle:nil] instantiateViewControllerWithIdentifier:@"JQDDPLinkFileTVC"];
    if (flag) {
        // 直接push一个新的vc
        [presentViewController.navigationController pushViewController:jqvc animated:YES];
    } else {
        // 把最后一个vc删掉,再加一个vc
        NSMutableArray *arr = [presentViewController.navigationController.viewControllers mutableCopy];
        [arr removeLastObject];
        [arr addObject:jqvc];
        [presentViewController.navigationController setViewControllers:arr animated:YES];
    }
}

@end
