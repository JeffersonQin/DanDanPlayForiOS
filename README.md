# 弹弹play for iOS

[弹弹play](http://www.dandanplay.com/)的iOS版。下面是Fork逻辑:

```
@sunsx9316 sunsx9316 / DanDanPlayForiOS
 @wolfcon wolfcon / DanDanPlayForiOS
  @JeffersonQin JeffersonQin / DanDanPlayForiOS
```

由于原项目已经不再维护, 根据GitHub相关规范, 本项目从原项目中Detach, 作为独立项目继续开发。

## 新版功能介绍

- [bug fix] 修复了无法远程BT下载encodeURI两次导致无法下载
- [bug fix] 修复DDPMethods中部分网络请求未使用token
- [warning] 原“局域网设备”功能更改为“SMBv1”
- [feature] 增加了远程PC的字幕选择功能
- [feature] 增加了新的远程PC文件查看界面
    - 支持文件索引
    - 以文件名展示

## TODO
- 远程PC文件查看界面v2的上拉刷新
- 实现SMBv2/SMBv3
- 搭建平台, 使用Internal Test的通道进行分发

## 功能介绍
1. 视频智能识别
2. 支持从其它APP或者通过HTTP的方式导入视频

## 系统要求
最低支持 iOS 8.0

## 第三方库
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [Masonry](https://github.com/SnapKit/Masonry)
* [YYKit](https://github.com/ibireme/YYKit)
* [VLCKit](https://code.videolan.org/videolan/VLCKit)
* [GDataXML-HTML](https://github.com/graetzer/GDataXML-HTML)
* [JHDanmakuRender](https://github.com/sunsx9316/JHDanmakuRender)
* [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
* [UITableView+FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell)
* [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)
* [RATreeView](https://github.com/Augustyniak/RATreeView)
* [WMPageController](https://github.com/wangmchn/WMPageController)
* [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
* [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)
* [NKOColorPickerView](https://github.com/nakiostudio/NKOColorPickerView)
* [CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer)

## thank
* [Bilibili Mac Client](https://github.com/typcn/bilibili-mac-client)
* [BarrageRenderer](https://github.com/unash/BarrageRenderer)

## build
项目依赖CocoaPods 运行前请手动 ```pod update ```

## 软件截图
![预览图1](http://wx1.sinaimg.cn/mw690/005tgoOjgy1ff125h3tj9j30vk0hs7eb.jpg)

![预览图2](http://wx1.sinaimg.cn/mw690/005tgoOjgy1ff125pbx12j30hs0vk4b5.jpg)

## 联系
- 原作者: [O浪微博](http://weibo.com/u/2996607392)
- 我: 1247006353@qq.com

## 许可证
软件遵循MIT协议 详情请见LICENSE文件
