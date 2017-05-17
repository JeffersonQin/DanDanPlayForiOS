//
//  PlayerSubTitleIndexView.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/5/17.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "PlayerSubTitleIndexView.h"
#import "JHBlurView.h"
#import "BaseTableView.h"
#import "FTPReceiceTableViewCell.h"

@interface PlayerSubTitleIndexView ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong, nonatomic) JHBlurView *contentView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) BaseTableView *tableView;
@end

@implementation PlayerSubTitleIndexView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(20);
            make.bottom.mas_offset(-20);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(self).multipliedBy(0.5);
        }];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)show {
    
    if (self.superview == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.videoSubTitlesNames.count > 0;
    }
    return self.videoSubTitlesNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FTPReceiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FTPReceiceTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"选择字幕...";
        cell.iconImgView.hidden = YES;
    }
    else {
        cell.titleLabel.text = self.videoSubTitlesNames[indexPath.row];
        if (indexPath.row < self.videoSubTitlesIndexes.count) {
            cell.iconImgView.hidden = ![self.videoSubTitlesIndexes[indexPath.row] isEqual:@(self.currentVideoSubTitleIndex)];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self emptyDataSet:nil didTapView:nil];
    }
    else if (indexPath.row < self.videoSubTitlesIndexes.count) {
        if (self.selectedIndexCallBack) {
            self.currentVideoSubTitleIndex = [self.videoSubTitlesIndexes[indexPath.row] intValue];
            [tableView reloadData];
            [self dismiss];
            self.selectedIndexCallBack(self.currentVideoSubTitleIndex);
        }
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"字幕呢( ・_ゝ・)" attributes:@{NSFontAttributeName : NORMAL_SIZE_FONT, NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    return str;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"点击选择" attributes:@{NSFontAttributeName : SMALL_SIZE_FONT, NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    return str;
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.didTapEmptyViewCallBack) {
        self.didTapEmptyViewCallBack();
        [self dismiss];
    }
}


#pragma mark - 懒加载
- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        @weakify(self)
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self)
            if (!self) return;
            
            [self dismiss];
        }]];
        _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (JHBlurView *)contentView {
    if (_contentView == nil) {
        _contentView = [[JHBlurView alloc] init];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        _contentView.blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        [_contentView addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (BaseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[BaseTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.showEmptyView = YES;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FTPReceiceTableViewCell class] forCellReuseIdentifier:@"FTPReceiceTableViewCell"];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}


@end
