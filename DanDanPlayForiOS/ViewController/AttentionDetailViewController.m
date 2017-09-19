//
//  AttentionDetailViewController.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/9/8.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "AttentionDetailViewController.h"
#import "HomePageSearchViewController.h"

#import "BaseTableView.h"
#import "AttentionDetailTableViewCell.h"
#import "AttentionDetailHistoryTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "NSDate+Tools.h"
#import "JHEdgeButton.h"

@interface AttentionDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) BaseTableView *tableView;
@property (strong, nonatomic) JHPlayHistory *historyModel;
@end

@implementation AttentionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configRightItem];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return !!self.historyModel;
    }
    return self.historyModel.collection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AttentionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionDetailTableViewCell" forIndexPath:indexPath];
        cell.model = self.historyModel;
        return cell;
    }
    
    AttentionDetailHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionDetailHistoryTableViewCell" forIndexPath:indexPath];
    cell.model = self.historyModel.collection[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    
    return [tableView fd_heightForCellWithIdentifier:@"AttentionDetailHistoryTableViewCell" cacheByIndexPath:indexPath configuration:^(AttentionDetailHistoryTableViewCell *cell) {
        cell.model = self.historyModel.collection[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        //未登录
        if ([CacheManager shareCacheManager].user == nil) {
            [[ToolsManager shareToolsManager] loginInViewController:self completion:^(JHUser *user, NSError *err) {
                
            }];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            JHEpisode *model = self.historyModel.collection[indexPath.row];
            //已观看
            if (model.time.length != 0) return;
            
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"是否标记为已看过？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBProgressHUD showLoadingInView:self.view text:@"添加中..."];
                [FavoriteNetManager favoriteAddHistoryWithUser:[CacheManager shareCacheManager].user episodeId:model.identity addToFavorite:YES completionHandler:^(NSError *error) {
                    [MBProgressHUD hideLoading];
                    
                    if (error) {
                        [MBProgressHUD showWithError:error];
                    }
                    else {
                        model.time = [NSDate historyTimeStyleWithDate:[NSDate date]];
                        if (self.attentionCallBack) {
                            self.attentionCallBack(self.animateId);
                        }
                        [self.tableView reloadData];
                    }
                }];
            }]];
            
            [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:vc animated:YES completion:nil];
        });
    }
}

#pragma mark - 私有方法
- (void)configRightItem {
    JHEdgeButton *backButton = [[JHEdgeButton alloc] init];
    backButton.inset = CGSizeMake(10, 10);
    [backButton addTarget:self action:@selector(touchRightItem:) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = NORMAL_SIZE_FONT;
    [backButton setTitle:@"搜索资源" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)touchRightItem:(UIButton *)button {
    if (self.historyModel.name.length == 0) return;
    
    HomePageSearchViewController *vc = [[HomePageSearchViewController alloc] init];
    JHDMHYSearchConfig *config = [[JHDMHYSearchConfig alloc] init];
    vc.config = config;
    config.keyword = self.historyModel.name;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载
- (BaseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AttentionDetailTableViewCell class] forCellReuseIdentifier:@"AttentionDetailTableViewCell"];
        [_tableView registerClass:[AttentionDetailHistoryTableViewCell class] forCellReuseIdentifier:@"AttentionDetailHistoryTableViewCell"];
        
        _tableView.tableFooterView = [[UIView alloc] init];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader jh_headerRefreshingCompletionHandler:^{
            @strongify(self)
            if (!self) return;
            
            [FavoriteNetManager favoriteHistoryAnimateWithUser:[CacheManager shareCacheManager].user animateId:self.animateId completionHandler:^(JHPlayHistory *responseObject, NSError *error) {
                if (error) {
                    [MBProgressHUD showWithError:error];
                }
                else {
                    self.historyModel = responseObject;
                    self.historyModel.isOnAir = self.isOnAir;
                    self.navigationItem.title = self.historyModel.name;
                    [self.tableView reloadData];
                }
                
                [self.tableView endRefreshing];
            }];
        }];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
