//
//  DDPHomePageBannerView.h
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2018/10/5.
//  Copyright © 2018 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HOME_BANNER_VIEW_HEIGHT 180

NS_ASSUME_NONNULL_BEGIN

@interface DDPHomePageBannerView : UIView
@property (strong, nonatomic) NSArray <DDPNewBanner *>*models;
@end

NS_ASSUME_NONNULL_END
