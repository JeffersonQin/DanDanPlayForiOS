//
//  PlayerControlPlayModeTableViewCell.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/4/26.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "PlayerControlPlayModeTableViewCell.h"

@interface PlayerControlPlayModeTableViewCell ()
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation PlayerControlPlayModeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}

#pragma mark - 私有方法
- (void)touchSegmentedControl:(UISegmentedControl *)sender {
    [CacheManager shareCacheManager].playMode = sender.selectedSegmentIndex;
}

#pragma mark - 懒加载
- (UISegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"单集播放", @"单集循环", @"列表循环", @"顺序播放"]];
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName : NORMAL_SIZE_FONT} forState:UIControlStateNormal | UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(touchSegmentedControl:) forControlEvents:UIControlEventTouchUpInside];
        
        _segmentedControl.selectedSegmentIndex = [CacheManager shareCacheManager].playMode;
        
        [self.contentView addSubview:_segmentedControl];
    }
    return _segmentedControl;
}

@end
