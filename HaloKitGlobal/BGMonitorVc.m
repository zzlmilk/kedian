//
//  BGMonitorVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/16.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGMonitorVc.h"
#import "BGLanageTool.h"
@interface BGMonitorVc ()

@end

@implementation BGMonitorVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = BGGetStringWithKeyFromTable(@"Monitor" , @"BGLanguageSetting");
    [self.guijiBtn setTitle:BGGetStringWithKeyFromTable(@"Pets 24 hours trajectory" , @"BGLanguageSetting") forState:UIControlStateNormal];
    [self.weilanBtn setTitle:BGGetStringWithKeyFromTable(@"Create an electronic fence", @"BGLanguageSetting") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
