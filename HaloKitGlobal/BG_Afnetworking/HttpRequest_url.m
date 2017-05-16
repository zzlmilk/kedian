//
//  HttpRequest_url.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/4/25.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "HttpRequest_url.h"//
# define BaseURL  @"http://paimukeji.vicp.io/halokitglobal/"

@implementation HttpRequest_url
//获取七牛token
+ (NSString *)qiniu_token_getUrl{

    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"qiniu/token"];
    return url;
}

//获取短信验证码
+ (NSString *)authcode_getUrl:(NSString *)mobile{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,@"authcode/",mobile];
    return url;
}

//设备注册(绑定Client和deviceid)
+ (NSString *)register_postUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"comm/register"];
    return url;
}

//设置离线时间
+ (NSString *)offline_postUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"comm/offline"];
    return url;
}

//设备坐标存储

+ (NSString *)coordinates_postUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"comm/coordinates"];
    return url;
}

//宠物逃脱围栏推送通知

+ (NSString *)getui_getUrl:(NSString *)clientid{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,@"comm/getui/",clientid];
    return url;
}

//登录（推送语言设置）
+ (NSString *)login_postUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"comm/login"];
    return url;
}

//根据ClientID查询语言

+ (NSString *)language_select_getUrl:(NSString *)clientid{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,@"comm/language/select/",clientid];
    return url;
}

//根据设备号获得最后轨迹点

+ (NSString *)coordinates_getUrl:(NSString *)deviceid{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,@"comm/coordinates/",deviceid];
    return url;
}

//获得24小时内轨迹列表
+ (NSString *)walkpath_getUrl:(NSString *)deviceid{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,@"comm/walkpath/",deviceid];
    return url;
}

//提交意见

+ (NSString *)advice_postUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"advice"];
    return url;
}

//根据Deviceid查询电子围栏信息

+ (NSString *)fence_getUrl:(NSString *)deviceid{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,@"fence/",deviceid];
    return url;
}

//新增电子围栏

+ (NSString *)newFence_postUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"fence"];
    return url;
}

//根据deviceid设置电子围栏报警状态

+ (NSString *)fence_update_alarm_putUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"fence/update/alarm"];
    return url;
}

//根据deviceid删除电子围栏
+ (NSString *)fence_delete_getUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"fence/delete"];
    return url;
}

//查询遛狗画面广告
+ (NSString *)advertising_walk_getUrl{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"advertising/walk"];
    return url;
}

//根据最大id号取得比id号大的消息

+ (NSString *)message_getUrl:(NSString *)Id{
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BaseURL,@"message/",Id];
    return url;
}



@end
