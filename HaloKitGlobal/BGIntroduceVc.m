//
//  BGIntroduceVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGIntroduceVc.h"

@interface BGIntroduceVc ()<UIWebViewDelegate>

@end

@implementation BGIntroduceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self webviewmain];
}

-(void)webviewmain
{
    
    _webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://halokit.cn/faq"]];
    //加载
    NSURLRequest * request          = [NSURLRequest requestWithURL:_webUrl];
    //显示
    [_webview loadRequest:request];
    _webview.delegate              = self;
    
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
