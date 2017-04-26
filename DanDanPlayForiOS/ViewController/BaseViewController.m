//
//  BaseViewController.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 17/2/18.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "BaseViewController.h"
#import "JHEdgeButton.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAV_BAR_DEFAULT
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_GROUND_COLOR;
    [self configLeftItem];
}

- (void)dealloc {
    NSLog(@"%@ ViewController dealloc", NSStringFromClass(self.class));
}

#pragma mark - 私有方法
- (void)configLeftItem {
    JHEdgeButton *backButton = [[JHEdgeButton alloc] init];
    backButton.inset = CGSizeMake(10, 10);
    [backButton addTarget:self action:@selector(touchLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"barbuttonicon_back"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)touchLeftItem:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
