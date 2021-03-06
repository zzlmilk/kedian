//
//  BGTableBarVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/4/25.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGTableBarVc.h"
#import "BGLanageTool.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BGLanageTool.h"
#import "LinkDeviceVc.h"
#import "UIViewController+PopMessage.h"
@interface BGTableBarVc ()

@end

@implementation BGTableBarVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginState:) name:@"loginstate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offLineState:) name:@"AppOffLine" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(state:) name:@"poststate" object:nil];
    //设置底部颜色
    UIBarItem *item=[UIBarItem appearance];
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]=[UIColor grayColor];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateSelected];
    
    NSString *map = BGGetStringWithKeyFromTable(@"Map" , @"BGLanguageSetting");
    NSString *trajectory = BGGetStringWithKeyFromTable(@"Monitor" , @"BGLanguageSetting");
    NSString *Setting = BGGetStringWithKeyFromTable(@"Device" , @"BGLanguageSetting");
    
    //设置底部文字
    NSArray *titleArray = [NSArray arrayWithObjects:map, trajectory, Setting, nil];
    for (int idx = 0; idx < self.viewControllers.count; idx++) {
        NSString *imgName = [NSString stringWithFormat:@"tabBar%d",idx + 1 ];
        NSString *selectImageName = [NSString stringWithFormat:@"tabBar_selected%d", idx + 1 ];
        UIImage *img = [UIImage imageNamed:imgName];
        UIImage *selectImage = [UIImage imageNamed:selectImageName];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArray[idx] image:img selectedImage:selectImage];
        UIViewController *navc = self.viewControllers[idx];
        NSLog(@"tabBar:%@", navc);
        navc.tabBarItem = tabBarItem;

    }

    self.view.backgroundColor = [UIColor whiteColor];

    
}

-(void)loginState:(NSNotification *)center//Please turn on your device and reconnect it on the device page
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:BGGetStringWithKeyFromTable(@"Please turn on your device and reconnect it on the device page", @"BGLanguageSetting")  preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:BGGetStringWithKeyFromTable(@"OK", @"BGLanguageSetting")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


//接收报警的个推
-(void)state:(NSNotification *)center//Make sure to close the electronic fence
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self popSuccessShow: BGGetStringWithKeyFromTable(@"Make sure to close the electronic fence" , @"BGLanguageSetting") afterDelay:1.5];
}

-(void)offLineState:(NSNotification *)center
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:BGGetStringWithKeyFromTable(@"Please turn on your device and reconnect it on the device page", @"BGLanguageSetting")  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:BGGetStringWithKeyFromTable(@"Not connected", @"BGLanguageSetting")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginstate" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppOffLine" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"poststate" object:nil];

}

@end
