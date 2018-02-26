//
//  HomePageBangumiProgressCollectionViewCell.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/12/10.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "HomePageBangumiProgressCollectionViewCell.h"
#import "DDPCacheManager.h"

@interface HomePageBangumiProgressCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation HomePageBangumiProgressCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont ddp_smallSizeFont];
    self.progressLabel.font = [UIFont ddp_verySmallSizeFont];
    self.descLabel.font = [UIFont ddp_verySmallSizeFont];
    self.descLabel.textColor = [UIColor lightGrayColor];
    self.progressLabel.textColor = [UIColor ddp_mainColor];
}

- (void)setModel:(DDPBangumiQueueIntro *)model {
    _model = model;
    
    [self.iconImgView ddp_setImageWithURL:_model.imageUrl placeholder:nil progress:nil manager:[[DDPCacheManager shareCacheManager] imageManagerWithRoundedCornersRadius:6] transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return [[image yy_imageByResizeToSize:CGSizeMake(self.itemSize.width, 150) contentMode:UIViewContentModeScaleAspectFill] yy_imageByRoundCornerRadius:6];
    } completion:nil];
    self.nameLabel.text = _model.name;
    self.progressLabel.text = _model.episodeTitle;
    self.descLabel.text = _model.desc;
}

@end
