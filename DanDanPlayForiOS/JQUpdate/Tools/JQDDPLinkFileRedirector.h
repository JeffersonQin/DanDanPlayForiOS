//
//  JQDDPLinkFileRedirector.h
//  DanDanPlayForiOS
//
//  Created by JeffersonQin on 2021/4/7.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef JQDDPLinkFileRedirector_h
#define JQDDPLinkFileRedirector_h

@class JQDDPLinkFileTableViewController;

@interface JQDDPLinkFileRedirector : NSObject

+ (void) redirectFrom:(UIViewController *) presentViewController push:(bool) flag;

@end

#endif /* JQDDPLinkFileRedirector_h */
