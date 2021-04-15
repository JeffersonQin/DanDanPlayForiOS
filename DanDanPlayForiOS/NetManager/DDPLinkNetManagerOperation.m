//
//  DDPLinkNetManagerOperation.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 2017/9/13.
//  Copyright © 2017年 JimHuang. All rights reserved.
//

#import "DDPLinkNetManagerOperation.h"
#import <AFNetworking/AFNetworking.h>
#import "DDPSharedNetManager.h"

JHControlLinkTaskMethod JHControlLinkTaskMethodStart = @"start";
JHControlLinkTaskMethod JHControlLinkTaskMethodPause = @"pause";
JHControlLinkTaskMethod JHControlLinkTaskMethodDelete = @"delete";


JHControlVideoMethod JHControlVideoMethodPlay = @"play";
JHControlVideoMethod JHControlVideoMethodStop = @"stop";
JHControlVideoMethod JHControlVideoMethodPause = @"pause";
JHControlVideoMethod JHControlVideoMethodNext = @"next";
JHControlVideoMethod JHControlVideoMethodPrevious = @"previous";

@implementation DDPLinkNetManagerOperation

+ (DDPBaseNetManager *)sharedNetManager {
    static DDPBaseNetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DDPBaseNetManager alloc] init];
    });
    return manager;
}

+ (NSURLSessionDataTask *)linkWithIpAdress:(NSString *)ipAdress
                         completionHandler:(void(^)(DDPLinkWelcome *responseObject, NSError *error))completionHandler {
    
    if (ipAdress.length == 0) {
        if (completionHandler) {
            completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/welcome", ipAdress, LINK_API_INDEX];
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:DDPBaseNetManagerSerializerTypeJSON
                                                 parameters:nil
                                          completionHandler:^(DDPResponse *responseObj) {
        if (completionHandler) {
            completionHandler([DDPLinkWelcome yy_modelWithJSON:responseObj.responseObject], responseObj.error);
        }
    }];
}

+ (NSURLSessionDataTask *)linkAddDownloadWithIpAdress:(NSString *)ipAdress
                                               magnet:(NSString *)magnet
                                    completionHandler:(void(^)(DDPLinkDownloadTask *responseObject, NSError *error))completionHandler {
    //编码最后一段
    NSMutableArray<NSString *>*parameters = [[magnet componentsSeparatedByString:@":"] mutableCopy];
    NSMutableString *str = [[NSMutableString alloc] init];
    [parameters enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:parameters.lastObject]) {
            [str appendFormat:@"%@", [obj stringByURLEncode]];
        }
        else {
            [str appendFormat:@"%@:", obj];
        }
    }];
    magnet = str;
    
    if (ipAdress.length == 0 || magnet.length == 0) {
        if (completionHandler) {
            completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/download/tasks/add", ipAdress, LINK_API_INDEX];
    
    // 删除原有链接中的所有trackers以及其他参数
    for (int i = 0; i < [magnet length]; i ++)
        if ([magnet characterAtIndex:i] == '&' || [magnet characterAtIndex:i] == '%') {
            magnet = [magnet substringToIndex:i];
            break;
        }
    
    // 添加自己的trackers
    magnet = [magnet stringByAppendingFormat:@"&tr=https://w.wwwww.wtf:443/announce&tr=https://tracker.nitrix.me:443/announce&tr=udp://tracker4.itzmx.com:2710/announce&tr=https://tracker.tamersunion.org:443/announce&tr=http://vps02.net.orel.ru:80/announce&tr=http://h4.trakx.nibba.trade:80/announce&tr=udp://retracker.netbynet.ru:2710/announce&tr=udp://tracker.zerobytes.xyz:1337/announce&tr=https://tracker.nanoha.org:443/announce&tr=http://tracker3.itzmx.com:6961/announce&tr=udp://tracker.uw0.xyz:6969/announce&tr=http://tr.cili001.com:8070/announce&tr=udp://tracker.torrent.eu.org:451/announce&tr=udp://valakas.rollo.dnsabr.com:2710/announce&tr=udp://opentracker.i2p.rocks:6969/announce&tr=udp://tracker.moeking.me:6969/announce&tr=udp://exodus.desync.com:6969/announce&tr=udp://open.stealth.si:80/announce&tr=udp://tracker.sbsub.com:2710/announce&tr=udp://retracker.lanta-net.ru:2710/announce&tr=udp://opentor.org:2710/announce&tr=https://tracker.sloppyta.co:443/announce&tr=http://tracker.gbitt.info:80/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://zephir.monocul.us:6969/announce&tr=udp://tracker3.itzmx.com:6961/announce&tr=udp://bt2.archive.org:6969/announce&tr=udp://xxxtor.com:2710/announce&tr=udp://thetracker.org:80/announce&tr=udp://tracker.leechers-paradise.org:6969/announce&tr=udp://tracker.coppersurfer.tk:6969/announce&tr=udp://tracker.e-utp.net:6969/announce&tr=udp://retracker.akado-ural.ru:80/announce&tr=udp://tracker.army:6969/announce&tr=http://trun.tom.ru:80/announce&tr=udp://tracker2.itzmx.com:6961/announce&tr=http://tracker1.itzmx.com:8080/announce&tr=https://tk.mabo.ltd:443/announce&tr=http://tracker.ipv6tracker.ru:80/announce&tr=udp://tracker.fortu.io:6969/announce&tr=udp://tracker.iamhansen.xyz:2000/announce&tr=udp://tracker.teambelgium.net:6969/announce&tr=udp://ipv6.tracker.harry.lu:80/announce&tr=udp://ipv6.tracker.zerobytes.xyz:16661/announce&tr=udp://retracker.hotplug.ru:2710/announce&tr=udp://tracker.0o.is:6969/announce&tr=udp://tracker.beeimg.com:6969/announce&tr=udp://tracker.birkenwald.de:6969/announce&tr=udp://tracker.ds.is:6969/announce&tr=udp://chihaya.de:6969/announce&tr=https://t3.leech.ie:443/announce&tr=http://t3.leech.ie:80/announce&tr=https://t1.leech.ie:443/announce&tr=https://t2.leech.ie:443/announce&tr=http://t2.leech.ie:80/announce&tr=http://www.yqzuji.com:80/announce&tr=http://tracker.files.fm:6969/announce&tr=http://tracker.trackerfix.com:80/announce&tr=https://tracker.gbitt.info:443/announce&tr=udp://tracker1.itzmx.com:8080/announce&tr=udp://tracker.tiny-vps.com:6969/announce&tr=udp://u.wwwww.wtf:1/announce&tr=udp://tracker-udp.gbitt.info:80/announce&tr=udp://ipv4.tracker.harry.lu:80/announce&tr=udp://9.rarbg.to:2710/announce&tr=udp://9.rarbg.me:2710/announce&tr=udp://tracker.cyberia.is:6969/announce&tr=https://tracker.lelux.fi:443/announce&tr=udp://aaa.army:8866/announce&tr=udp://bt1.archive.org:6969/announce&tr=http://tracker2.itzmx.com:6961/announce&tr=http://tr.bangumi.moe:6969/announce&tr=http://tracker.bt4g.com:2095/announce&tr=http://open.acgnxtracker.com:80/announce&tr=http://t.nyaatracker.com/announce&tr=http://open.acgtracker.com:1096/announce&tr=http://open.nyaatorrents.info:6544/announce&tr=http://t2.popgo.org:7456/annonce&tr=http://share.camoe.cn:8080/announce&tr=http://opentracker.acgnx.se/announce&tr=http://tracker.acgnx.se/announce&tr=http://nyaa.tracker.wf:7777/announce&tr=http://opentracker.acgnx.com:6869/announce&tr=udp://tracker.openbittorrent.com:80/announce&tr=udp://tracker.publicbt.com:80/announce&tr=udp://tracker.prq.to:80/announce&tr=udp://104.238.198.186:8000/announce&tr=http://104.238.198.186:8000/announce&tr=http://94.228.192.98/announce&tr=http://share.dmhy.org/annonuce&tr=http://tracker.btcake.com/announce&tr=http://tracker.ktxp.com:6868/announce&tr=http://tracker.ktxp.com:7070/announce&tr=udp://bt.sc-ol.com:2710/announce&tr=http://btfile.sdo.com:6961/announce&tr=https://t-115.rhcloud.com/only_for_ylbud&tr=http://exodus.desync.com:6969/announce&tr=udp://coppersurfer.tk:6969/announce&tr=http://tracker3.torrentino.com/announce&tr=http://tracker2.torrentino.com/announce&tr=udp://open.demonii.com:1337/announce&tr=udp://tracker.ex.ua:80/announce&tr=http://pubt.net:2710/announce&tr=http://tracker.tfile.me/announce&tr=http://bigfoot1942.sektori.org:6969/announce&tr=http://bt.sc-ol.com:2710/announce"];
    
    NSMutableDictionary *dic = @{@"magnet" : magnet}.mutableCopy;
    [dic addEntriesFromDictionary:self.additionParameters];
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:DDPBaseNetManagerSerializerTypeJSON
                                                 parameters:dic
                                          completionHandler:^(DDPResponse *responseObj) {
        if (responseObj.error) {
            if (completionHandler) {
                completionHandler(nil, responseObj.error);
            }
        }
        else if (responseObj.responseObject == nil) {
            if (completionHandler) {
                completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
            }
        }
        else {
            if (completionHandler) {
                completionHandler([DDPLinkDownloadTask yy_modelWithJSON:responseObj.responseObject], responseObj.error);
            }
        }
    }];
}

+ (NSURLSessionDataTask *)linkControlDownloadWithIpAdress:(NSString *)ipAdress
                                                   taskId:(NSString *)taskId
                                                   method:(JHControlLinkTaskMethod)method
                                              forceDelete:(BOOL)forceDelete
                                        completionHandler:(void(^)(DDPLinkDownloadTask *responseObject, NSError *error))completionHandler {
    if (ipAdress.length == 0 || taskId.length == 0 || method.length == 0) {
        if (completionHandler) {
            completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/download/tasks/%@/%@", ipAdress, LINK_API_INDEX, taskId, method];
    NSMutableDictionary *parameters = @{@"remove" : @(forceDelete)}.mutableCopy;
    
    [parameters addEntriesFromDictionary:self.additionParameters];
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:DDPBaseNetManagerSerializerTypeJSON
                                                 parameters:parameters
                                          completionHandler:^(DDPResponse *responseObj) {
        if (responseObj.error) {
            if (completionHandler) {
                completionHandler(nil, responseObj.error);
            }
        }
        else if (responseObj.responseObject == nil) {
            if (completionHandler) {
                completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
            }
        }
        else {
            if (completionHandler) {
                completionHandler([DDPLinkDownloadTask yy_modelWithJSON:responseObj.responseObject], responseObj.error);
            }
        }
    }];
}

+ (NSURLSessionDataTask *)linkDownloadListWithIpAdress:(NSString *)ipAdress
                                     completionHandler:(void(^)(DDPLinkDownloadTaskCollection *responseObject, NSError *error))completionHandler {
    
    if (ipAdress.length == 0) {
        if (completionHandler) {
            completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/download/tasks", ipAdress, LINK_API_INDEX];
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:DDPBaseNetManagerSerializerTypeJSON
                                                 parameters:self.additionParameters
                                          completionHandler:^(DDPResponse *responseObj) {
        DDPLinkDownloadTaskCollection *collection = [[DDPLinkDownloadTaskCollection alloc] init];
        collection.collection = [NSArray yy_modelArrayWithClass:[DDPLinkDownloadTask class] json:responseObj.responseObject].mutableCopy;
        if (completionHandler) {
            completionHandler(collection, responseObj.error);
        }
    }];
}

+ (NSURLSessionDataTask *)linkChangeWithIpAdress:(NSString *)ipAdress
                                          volume:(NSUInteger)volume
                               completionHandler:(DDPErrorCompletionAction)completionHandler {
    if (ipAdress.length == 0) {
        if (completionHandler) {
            completionHandler(DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/control/volume/%lu", ipAdress, LINK_API_INDEX, (unsigned long)volume];
    
    DDPBaseNetManagerSerializerType serializerType = DDPBaseNetManagerSerializerTypeJSON;
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:serializerType
                                                 parameters:self.additionParameters
                                          completionHandler:^(DDPResponse *responseObj) {
                                              if (completionHandler) {
                                                  completionHandler(responseObj.error);
                                              }
                                          }];
}

+ (NSURLSessionDataTask *)linkChangeWithIpAdress:(NSString *)ipAdress
                                            time:(NSUInteger)time
                               completionHandler:(DDPErrorCompletionAction)completionHandler {
    if (ipAdress.length == 0) {
        if (completionHandler) {
            completionHandler(DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/control/seek/%lu", ipAdress, LINK_API_INDEX, (unsigned long)time];
    
    DDPBaseNetManagerSerializerType serializerType = DDPBaseNetManagerSerializerTypeJSON;
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:serializerType
                                                 parameters:self.additionParameters
                                          completionHandler:^(DDPResponse *responseObj) {
                                              if (completionHandler) {
                                                  completionHandler(responseObj.error);
                                              }
                                          }];
}

+ (NSURLSessionDataTask *)linkControlWithIpAdress:(NSString *)ipAdress
                                           method:(JHControlVideoMethod)method
                                completionHandler:(DDPErrorCompletionAction)completionHandler {
    if (ipAdress.length == 0 || method.length == 0) {
        if (completionHandler) {
            completionHandler(DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/control/%@", ipAdress, LINK_API_INDEX, method];
    
    DDPBaseNetManagerSerializerType serializerType = DDPBaseNetManagerSerializerTypeJSON;
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:serializerType
                                                 parameters:self.additionParameters
                                          completionHandler:^(DDPResponse *responseObj) {
                                              if (completionHandler) {
                                                  completionHandler(responseObj.error);
                                              }
                                          }];
}

+ (NSURLSessionDataTask *)linkGetVideoInfoWithIpAdress:(NSString *)ipAdress
                                     completionHandler:(DDP_ENTITY_RESPONSE_ACTION(DDPLibrary))completionHandler {
    if (ipAdress.length == 0) {
        if (completionHandler) {
            completionHandler(nil , DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/current/video", ipAdress, LINK_API_INDEX];
    

    DDPBaseNetManagerSerializerType serializerType = DDPBaseNetManagerSerializerTypeJSON;
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:serializerType
                                                 parameters:self.additionParameters
                                          completionHandler:^(DDPResponse *responseObj) {
                                              if (completionHandler) {
                                                  completionHandler([DDPLibrary yy_modelWithJSON:responseObj.responseObject], responseObj.error);
                                              }
                                          }];
}

+ (NSURLSessionDataTask *)linkLibraryWithIpAdress:(NSString *)ipAdress
                                completionHandler:(void(^)(DDPLibraryCollection *responseObject, NSError *error))completionHandler {
    
    if (ipAdress.length == 0) {
        if (completionHandler) {
            completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/library", ipAdress, LINK_API_INDEX];
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                             serializerType:DDPBaseNetManagerSerializerTypeJSON
                                                 parameters:self.additionParameters
                                          completionHandler:^(DDPResponse *responseObj) {
        DDPLibraryCollection *collection = [[DDPLibraryCollection alloc] init];
        collection.collection = [NSArray yy_modelArrayWithClass:[DDPLibrary class] json:responseObj.responseObject].mutableCopy;
        if (completionHandler) {
            completionHandler(collection, responseObj.error);
        }
    }];
}

+ (NSURLSessionDataTask *)linkGetVideoSubtitleInfo:(NSString *)ipAddress
                                       videoID:(NSString *)videoID
                             completionHandler:(DDP_COLLECTION_RESPONSE_ACTION(DDPSubtitleCollection))completionHandler {
    if (ipAddress.length == 0) {
        if (completionHandler) {
            completionHandler(nil, DDPErrorWithCode(DDPErrorCodeParameterNoCompletion));
        }
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/subtitle/info/%@", ipAddress, LINK_API_INDEX, videoID];
    
    return [[DDPLinkNetManagerOperation sharedNetManager] GETWithPath:path
                                                       serializerType:DDPBaseNetManagerSerializerTypeJSON
                                                           parameters:self.additionParameters
                                                    completionHandler:^(DDPResponse *responseObj) {
        DDPSubtitleCollection *collection = [[DDPSubtitleCollection alloc] init];
        NSString *jsonSubtitle = [[responseObj.responseObject objectForKey:@"subtitles"] jsonStringEncoded];
        collection.collection = [NSArray yy_modelArrayWithClass:[DDPSubtitle class] json:jsonSubtitle].mutableCopy;
        if (completionHandler) {
            completionHandler(collection, responseObj.error);
        }
    }];
}

+ (NSDictionary *)additionParameters {
    let dic = [NSMutableDictionary dictionary];
    let password = [DDPCacheManager shareCacheManager].linkInfo.apiToken;
    dic[@"token"] = password.length > 0 ? password : nil;
    return dic;
}

@end
