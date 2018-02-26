//
//  DDPLinkFile.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/9/15.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "DDPLinkFile.h"

@implementation DDPLinkFile
{
    DDPLinkVideoModel *_videoModel;
}

- (instancetype)initWithLibraryFile:(DDPLibrary *)file {
    if (self = [super initWithFileURL:nil type:file.fileType]) {
        _library = file;
    }
    return self;
}

- (NSString *)name {
    return _library.name;
}

- (NSURL *)fileURL {
    if (_library.fileType == DDPFileTypeFolder) {
        return [NSURL URLWithString:[_library.path stringByURLEncode]];
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/stream/%@", [DDPCacheManager shareCacheManager].linkInfo.selectedIpAdress, LINK_API_INDEX, _library.md5]];
}

- (DDPVideoModel *)videoModel {
    if (_videoModel == nil) {
        _videoModel = [[DDPLinkVideoModel alloc] initWithName:self.name fileURL:self.fileURL hash:_library.md5 length:_library.size];
        _videoModel.file = self;
    }
    return _videoModel;
}

@end
