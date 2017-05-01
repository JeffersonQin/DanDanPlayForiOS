//
//  PlayerDanmakuControlView.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/4/24.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "PlayerDanmakuControlView.h"
#import "BaseTableView.h"
#import "PlayerSliderTableViewCell.h"
#import "PlayerControlHeaderView.h"
#import "PlayerShadowStyleTableViewCell.h"
#import "PlayerStepTableViewCell.h"

@interface PlayerDanmakuControlView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) BaseTableView *tableView;
@end

@implementation PlayerDanmakuControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PlayerSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerSliderTableViewCell" forIndexPath:indexPath];
        cell.type = PlayerSliderTableViewCellTypeFontSize;
        return cell;
    }
    else if (indexPath.section == 1) {
        PlayerSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerSliderTableViewCell" forIndexPath:indexPath];
        cell.type = PlayerSliderTableViewCellTypeSpeed;
        return cell;
    }
    else if (indexPath.section == 2) {
        PlayerShadowStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerShadowStyleTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 3) {
        PlayerStepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerStepTableViewCell" forIndexPath:indexPath];
        [cell setTouchStepperCallBack:self.touchStepperCallBack];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 + jh_isPad() * 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlayerControlHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PlayerControlHeaderView"];
    if (section == 0) {
        view.titleLabel.text = @"弹幕字体大小";
    }
    else if (section == 1) {
        view.titleLabel.text = @"弹幕速度";
    }
    else if (section == 2) {
        view.titleLabel.text = @"弹幕特效";
    }
    else if (section == 3) {
        view.titleLabel.text = @"弹幕时间偏移";
    }
    return view;
}

#pragma mark - 懒加载
- (BaseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[PlayerSliderTableViewCell class] forCellReuseIdentifier:@"PlayerSliderTableViewCell"];
        [_tableView registerClass:[PlayerControlHeaderView class] forHeaderFooterViewReuseIdentifier:@"PlayerControlHeaderView"];
        [_tableView registerClass:[PlayerShadowStyleTableViewCell class] forCellReuseIdentifier:@"PlayerShadowStyleTableViewCell"];
        [_tableView registerClass:[PlayerStepTableViewCell class] forCellReuseIdentifier:@"PlayerStepTableViewCell"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end