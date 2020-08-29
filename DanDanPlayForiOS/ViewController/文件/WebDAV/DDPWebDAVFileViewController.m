//
//  DDPWebDAVFileViewController.m
//  DDPlay
//
//  Created by JimHuang on 2020/4/26.
//  Copyright © 2020 JimHuang. All rights reserved.
//

#import "DDPWebDAVFileViewController.h"
#import "DDPPlayNavigationController.h"
#import "DDPMatchViewController.h"

#import "DDPFileManagerFolderLongViewCell.h"
#import "DDPFileManagerVideoTableViewCell.h"
#import "DDPEdgeButton.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "UITableViewCell+Tools.h"
#import "DDPBaseTableView.h"
#import "DDPWebDAVFile.h"
#import "DDPWebDAVVideoModel.h"

@interface DDPWebDAVFileViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) DDPBaseTableView *tableView;
@property (strong, nonatomic) UIImage *folderImg;
@end

@implementation DDPWebDAVFileViewController
{
    DDPWebDAVFile *_selectedFile;
    dispatch_group_t _group;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _group = dispatch_group_create();
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    if (_file.parentFile) {
        self.navigationItem.title = _file.name;
    }
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc {
    _group = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _file.subFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDPSMBFile *file = _file.subFiles[indexPath.row];
    
    //文件
    if (file.type == DDPFileTypeDocument) {
        DDPFileManagerVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDPFileManagerVideoTableViewCell" forIndexPath:indexPath];
        if (cell.isFromCache == NO) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.tintColor = [UIColor ddp_mainColor];
            cell.fromCache = YES;
        }
        cell.model = file;
        
        return cell;
    }
    
    //文件夹
    DDPFileManagerFolderLongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDPFileManagerFolderLongViewCell" forIndexPath:indexPath];
    if (cell.isFromCache == NO) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.tintColor = [UIColor ddp_mainColor];
        cell.fromCache = YES;
    }
    
    cell.titleLabel.text = file.name;
    cell.detailLabel.text = nil;
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.detailLabel.textColor = [UIColor blackColor];
    cell.iconImgView.image = self.folderImg;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DDPWebDAVFile *file = _file.subFiles[indexPath.row];
    
    if (file.type == DDPFileTypeFolder) {
        DDPWebDAVFileViewController *vc = [[DDPWebDAVFileViewController alloc] init];
        vc.file = file;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        if (ddp_isVideoFile(file.fileURL.absoluteString)) {
            
            _selectedFile = file;
            
            //查找是否获取过文件hash
            NSString *hash = [[DDPCacheManager shareCacheManager] webDAVHash:_selectedFile];
            if (hash.length) {
                [self startMatchWithHash:hash];
            }
            else {
                
            MBProgressHUD *_aHUD = [MBProgressHUD defaultTypeHUDWithMode:MBProgressHUDModeAnnularDeterminate InView:self.view];
            _aHUD.label.text = @"分析视频中...";
            @weakify(self)
            @weakify(_aHUD)
            
            [[DDPToolsManager shareToolsManager] downloadWebDAVFile:_selectedFile destinationPath:nil progressCallBack:^(NSProgress *progress) {
                @strongify(self)
                @strongify(_aHUD)
                if (!self || !_aHUD) {
                    return;
                }
                
                _aHUD.progress = progress.completedUnitCount * 1.0 / MIN(progress.totalUnitCount, MEDIA_MATCH_LENGTH);
                
                if (progress.completedUnitCount >= MEDIA_MATCH_LENGTH) {
                    [progress cancel];
                }
            } cancelCallBack:^(NSData *data) {
                if (data.length > MEDIA_MATCH_LENGTH) {
                    data = [data subdataWithRange:NSMakeRange(0, MEDIA_MATCH_LENGTH)];
                }
                NSString *hash = [data md5String];
                
                [[DDPCacheManager shareCacheManager] saveWebDAVFileHashWithHash:hash file:file];
                [self startMatchWithHash:hash];
            } completion:^(NSString *destinationFilePath, NSError *error) {
                @strongify(self)
                @strongify(_aHUD)
                if (!self || !_aHUD) {
                    return;
                }
                
                [_aHUD hideAnimated:YES];
            }];
                
            }
        }
        else {
            [self.view showWithText:@"不支持的文件格式!"];
        }
    }
}

#pragma mark - 私有方法
- (void)startMatchWithHash:(NSString *)hash {
        
    DDPWebDAVVideoModel *model = [[DDPWebDAVVideoModel alloc] initWithFileURL:_selectedFile.fileURL hash:hash length:(NSUInteger)_selectedFile.fileSize];
    model.file = _selectedFile;
    
    [self tryAnalyzeVideo:model];
}

- (void)configRightItem {
    if (ddp_appType == DDPAppTypeReview) {
        return;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil configAction:^(UIButton *aButton) {
        [aButton addTarget:self action:@selector(touchRightItem:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTitle:@"下载" forState:UIControlStateNormal];
        [aButton setTitle:@"取消" forState:UIControlStateSelected];
    }];
    
    [self.navigationItem addRightItemFixedSpace:item];
}

- (void)touchRightItem:(UIButton *)sender {
//    BOOL flag = !self.tableView.isEditing;
//    sender.selected = flag;
//    [self.tableView setEditing:flag animated:YES];
//    //显示
//    if (flag) {
//        [self.oprationView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.mas_equalTo(0);
//        }];
//    }
//    //隐藏
//    else {
//        [self.oprationView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0);
//            make.top.equalTo(self.view.mas_bottom);
//        }];
//    }
//
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    }];
}

- (void)touchSelectedAllButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [_file.subFiles enumerateObjectsUsingBlock:^(__kindof DDPFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
    }
    else {
        [self.tableView reloadData];
    }
}

- (void)touchDownloadButton:(UIButton *)sender {
//    NSArray <NSIndexPath *>*arr =  [self.tableView indexPathsForSelectedRows];
//
//    if (arr.count == 0) return;
//
//    NSMutableArray <TOSMBSessionDownloadTask *>*taskArr = [NSMutableArray array];
//
//    MBProgressHUD *aHUD = [MBProgressHUD defaultTypeHUDWithMode:MBProgressHUDModeIndeterminate InView:nil];
//    aHUD.label.text = @"处理中...";
//    NSString *downloadPath = ddp_taskDownloadPath();
//
//    dispatch_queue_t _queue = dispatch_queue_create("com.dandanplay.download", DISPATCH_QUEUE_SERIAL);
//
//    [arr enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        DDPSMBFile *file = _file.subFiles[obj.row];
//        //文件夹
//        if (file.type == DDPFileTypeFolder) {
//            dispatch_group_async(_group, _queue, ^{
//                dispatch_group_enter(_group);
//                [[DDPToolsManager shareToolsManager] startDiscovererSMBFileWithParentFile:file completion:^(DDPSMBFile *file1, NSError *error1) {
//                    [file1.subFiles enumerateObjectsUsingBlock:^(__kindof DDPSMBFile * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
//                        if (obj1.type == DDPFileTypeDocument) {
//                            //下载文件夹设置下载路径
//                            NSString *fileName = [file.name stringByDeletingPathExtension];
//                            NSString *destinationPath = [downloadPath stringByAppendingPathComponent:fileName];
//                            if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath] == NO) {
//                                [[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
//                            }
//
//                            TOSMBSessionDownloadTask *aTask = [[DDPToolsManager shareToolsManager].SMBSession downloadTaskForFileAtPath:obj1.sessionFile.filePath destinationPath:destinationPath delegate:nil];
//                            //设置文件大小
//                            [aTask setValue:@(obj1.sessionFile.fileSize) forKey:@"countOfBytesExpectedToReceive"];
//                            [taskArr addObject:aTask];
//                        }
//                    }];
//                    dispatch_group_leave(_group);
//                }];
//            });
//        }
//        else {
//            dispatch_group_async(_group, _queue, ^{
//                TOSMBSessionDownloadTask *aTask = [[DDPToolsManager shareToolsManager].SMBSession downloadTaskForFileAtPath:file.sessionFile.filePath destinationPath:downloadPath delegate:nil];
//                //设置文件大小
//                [aTask setValue:@(file.sessionFile.fileSize) forKey:@"countOfBytesExpectedToReceive"];
//                [taskArr addObject:aTask];
//            });
//        }
//    }];
//
//    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
//
//        [[DDPDownloadManager shareDownloadManager] addTasks:taskArr completion:^{
//            [aHUD hideAnimated:YES];
//
//            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"创建下载任务成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [vc addAction:[UIAlertAction actionWithTitle:@"下载列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                DDPDownloadViewController *vc = [[DDPDownloadViewController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }]];
//
//            [vc addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil]];
//
//            [self presentViewController:vc animated:YES completion:nil];
//        }];
//
//    });
//
//    [self touchRightItem:self.navigationItem.rightBarButtonItem.customView];
}

#pragma mark - 懒加载
- (DDPBaseTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[DDPBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.estimatedRowHeight = 60;
        [_tableView registerClass:[DDPFileManagerVideoTableViewCell class] forCellReuseIdentifier:@"DDPFileManagerVideoTableViewCell"];
        [_tableView registerClass:[DDPFileManagerFolderLongViewCell class] forCellReuseIdentifier:@"DDPFileManagerFolderLongViewCell"];
        
        @weakify(self)
        _tableView.mj_header = [MJRefreshHeader ddp_headerRefreshingCompletionHandler:^{
            @strongify(self)
            if (!self) return;
            
            [[DDPToolsManager shareToolsManager] startDiscovererWebDevFileWithParentFile:self.file completion:^(DDPWebDAVFile *file, NSError *error) {
                if (error) {
                    [self.view showWithText:@"网络错误"];
                }
                else {
                    self.file = file;
                    [self.tableView reloadData];
                }
                
                [self.tableView endRefreshing];
            }];
        }];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIImage *)folderImg {
    if (_folderImg == nil) {
        _folderImg = [[UIImage imageNamed:@"comment_local_file_folder"] renderByMainColor];
    }
    return _folderImg;
}

@end

