//
//  DDPRecommedNetManagerOperation.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DDPBaseNetManager.h"
#import "DDPHomePage.h"
#import "DDPNewHomePage.h"


@interface DDPRecommedNetManagerOperation : NSObject

/**
 新版首页

 @param completionHandler 完成回调
 @return 任务
 */
+ (NSURLSessionTask *)homePageWithCompletionHandler:(DDP_ENTITY_RESPONSE_ACTION(DDPNewHomePage))completionHandler;
@end
