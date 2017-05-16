//
//  HttpRequest_url.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/4/25.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest_url : NSObject
//获取七牛token
+ (NSString *)qiniu_token_getUrl;
//获取短信验证码
+ (NSString *)authcode_getUrl:(NSString *)mobile;
//设备注册(绑定Client和deviceid)
+ (NSString *)register_postUrl;
//设置离线时间
+ (NSString *)offline_postUrl;
//设备坐标存储
+ (NSString *)coordinates_postUrl;
//宠物逃脱围栏推送通知
+ (NSString *)getui_getUrl:(NSString *)clientid;
//登录（推送语言设置）
+ (NSString *)login_postUrl;
//根据ClientID查询语言
+ (NSString *)language_select_getUrl:(NSString *)clientid;
//根据设备号获得最后轨迹点
+ (NSString *)coordinates_getUrl:(NSString *)deviceid;
//获得24小时内轨迹列表
+ (NSString *)walkpath_getUrl:(NSString *)deviceid;
//提交意见
+ (NSString *)advice_postUrl;
//根据Deviceid查询电子围栏信息
+ (NSString *)fence_getUrl:(NSString *)deviceid;
//新增电子围栏
+ (NSString *)newFence_postUrl;
//根据deviceid设置电子围栏报警状态
+ (NSString *)fence_update_alarm_putUrl;
//根据deviceid删除电子围栏
+ (NSString *)fence_delete_getUrl;
//查询遛狗画面广告
+ (NSString *)advertising_walk_getUrl;
//根据最大id号取得比id号大的消息
+ (NSString *)message_getUrl:(NSString *)Id;
@end
