//
//  AboutUsViewController.m
//  可点
//
//  Created by jimZT on 16/10/19.
//  Copyright © 2016年 赵东明. All rights reserved.
//

#import "AboutUsViewController.h"
#import "BGLanageTool.h"


@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
    self.title =  BGGetStringWithKeyFromTable(@"About us" , @"BGLanguageSetting");//Current version
    self.lianxinwoLabel.text =   BGGetStringWithKeyFromTable(@"Contact number" , @"BGLanguageSetting");
    self.currentVersion.text =   BGGetStringWithKeyFromTable(@"Current version" , @"BGLanguageSetting");

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    
}


//一进来就调用查询当前版本的号码
-(void)request
{
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1114713303"];
//    NSString *appName = @"可点"; // @"app的名称"
//    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&country=CN&entity=software", appName];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlStr]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    
    NSArray *infoContent = [jsonData objectForKey:@"results"];
    NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    [_verisionBtn setTitle:version forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//调用系统的方法，打电话
- (IBAction)PlayPhone:(id)sender
{
    
    NSString *phoneStr = [NSString stringWithFormat:@"4007759206"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
}



//返回到关于我们
- (IBAction)back:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
