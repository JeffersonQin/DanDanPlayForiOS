# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

inhibit_all_warnings!
# install! 'cocoapods', generate_multiple_pod_projects: true

abstract_target 'DDPlay_Target' do
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    # use_frameworks!
    
    # pod 'JHDanmakuRender', :path => 'LocalPods/JHDanmakuRender'
    pod 'YYUtility', :path => 'LocalPods/YYUtility'

    pod 'Masonry'
    pod 'YYModel'
    pod 'YYCategories'
    pod 'MJRefresh'
    pod 'MBProgressHUD'
    pod 'JHDanmakuRender'
    pod 'UITableView+FDTemplateLayoutCell'
    pod 'RATreeView'
    pod 'WMPageController'
    pod 'IQKeyboardManager'
    pod 'DZNEmptyDataSet'
    pod 'NKOColorPickerView'
    pod 'YYKeyboardManager'
    pod 'MGSwipeTableCell'
    pod 'iCarousel'
    pod 'BlocksKit'#, :path => 'LocalPods/BlocksKit'
    pod 'YYWebImage', :git => 'https://github.com/sunsx9316/YYWebImage_UIKitForMac.git'

    pod 'DDPShare', :path => 'LocalPods/DDPShare'
    pod 'SSZipArchive'
    pod 'AFNetworking'
    pod 'Ono'

abstract_target 'iOS_Only' do
    pod 'UMCCommon'
    pod 'UMCSecurityPlugins'
    # 集成新浪微博
    pod 'UMCShare/Social/ReducedSina'
    # 集成QQ
    pod 'UMCShare/Social/ReducedQQ'
    # 集成微信
    pod 'UMCShare/Social/ReducedWeChat'

    # 友盟统计
#    pod 'UMCAnalytics'
    pod 'Bugly'
    #内存泄露检测
    # pod 'MLeaksFinder', :configurations => ['Debug'] 
    pod 'DDPEncrypt', :path => 'LocalPods/Encrypt'
    pod 'WCDB'
    pod 'MobileVLCKit'#, '3.3.10'#:path => 'LocalPods/MobileVLCKit'
    pod 'Ono'

    target 'DDPlay' do
    pod 'TOSMBClient', '~> 1.0.5'
    pod 'CocoaHTTPServer'
    end

    target 'DDPlay_Review' do
    pod 'TOSMBClient', '~> 1.0.5'
    pod 'CocoaHTTPServer'
    end
end


    target 'DDPlay_ToMac' do
    # pod 'AFNetworking', :git => 'https://github.com/sunsx9316/AFNetworking_UIKitForMac.git'
    pod 'CocoaLumberjack'
    pod 'DDPShare', :path => 'LocalPods/DDPShare'
#    pod 'WCDB_UIKitForMac', :path => 'LocalPods/WCDB'
    pod 'CocoaHTTPServer'
    # pod 'TOSMBClient', '~> 1.0.5'
    end
end


post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
       end
   end
end
