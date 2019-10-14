//
//  DDPPlayView.m
//  DDPlayMacPlayer
//
//  Created by JimHuang on 2019/9/13.
//  Copyright © 2019 JimHuang. All rights reserved.
//

#import "DDPPlayView.h"
#import <DDPShare/DDPShare.h>

@implementation DDPPlayView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerForDraggedTypes:@[NSPasteboardTypeFileURL]];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)event {
    if (self.keyDownCallBack) {
        self.keyDownCallBack(event);
    }
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSMutableArray <NSString *>*paths = [NSMutableArray array];
    [sender enumerateDraggingItemsWithOptions:kNilOptions forView:nil classes:@[NSURL.class] searchOptions:@{NSPasteboardURLReadingFileURLsOnlyKey : @(YES)} usingBlock:^(NSDraggingItem * _Nonnull draggingItem, NSInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = draggingItem.item;
        [paths addObject:url.path];
    }];
    
    [self sendParseMessageWithURL:paths];
    return YES;
}

- (void)sendParseMessageWithURL:(NSArray <NSString *>*)urls {
    if (self.didDragItemCallBack) {
        self.didDragItemCallBack(urls);
    }
}

@end
