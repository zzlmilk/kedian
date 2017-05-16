//
//  DeviceVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "DeviceVc.h"
#import "BGTableBarVc.h"
#import "JSONKit.h"
#import "Scan_VC.h"
#import "GTMBase64.h"
#import "GeTuiModel.h"
#import "BGMapVc.h"
#import "NSObject+YYModel.h"
#import "BGLanageTool.h"
#import "BoGeLangageSettingVc.h"
#import <CommonCrypto/CommonCryptor.h>
#import "BGSocketClass.h"
#import "AppDelegate.h"
#import "UIViewController+PopMessage.h"
#import "BGLanageTool.h"

#define DESDEVICEID @"deviceId"
@interface DeviceVc ()<Scan_VCDelegate,NSStreamDelegate,UINavigationControllerDelegate>

@end

@implementation DeviceVc
{
    Scan_VC * vc;
    NSInputStream  * inputStream;
    NSOutputStream * outputStream;
    NSString *deviceId;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //长链接DEMO
    _scanBtn.layer.cornerRadius = 15;
    _scanBtn.layer.masksToBounds = YES;
    _codeLabel.layer.cornerRadius = 15;
    _codeLabel.layer.masksToBounds = YES;
    
    _linkBtn.layer.cornerRadius = 15;
    _linkBtn.layer.masksToBounds = YES;
    NSString *scan = BGGetStringWithKeyFromTable(@"Scan",  @"BGLanguageSetting");

    
    [_scanBtn setTitle:scan forState:UIControlStateNormal];
  
    self.navigationController.delegate = self;
    [AppDelegate autoLayoutFillScreen:self.view];
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBarHidden = NO;
    
}


-(void)returnValue:(NSString *)value
{
    //需要把返给我的字符串截取一部分
    [[self class] encryptWithContent:value type:kCCDecrypt key:@"hAlokiTs"];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *desStr = [NSString stringWithFormat:@"%@",[userD objectForKey:DESDEVICEID]];
    if (desStr.length > 6) {
        deviceId = desStr;
        [userD setObject:deviceId forKey:DESDEVICEID];
        self.linkBtn.backgroundColor = [UIColor colorWithRed:94/225.0 green:64/255.0 blue:52/255.0 alpha:1.0];
        
    }else{
        deviceId = @"";
        
    }
}

+(NSString *)encryptWithContent:(NSString *)content type:(CCOperation)type key:(NSString *)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}

static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    //NSString *initIv = @"12345678";
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    NSString *result = nil;
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    NSString *desStr = [NSString stringWithFormat:@"%s",[result UTF8String]];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:desStr forKey:DESDEVICEID];/////////////////////861933030001580
    return [result UTF8String];
}


- (IBAction)scanAction:(id)sender {
    [self tapScan];
}

-(void)tapScan{
    
    vc = [[Scan_VC alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)linkAction {
    [self initNetworkCommunication];
    NSLog(@"deviceIddeviceId1:%@", deviceId);
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];

    NSString *clientid = [[NSUserDefaults standardUserDefaults]objectForKey:@"clientId"];
    NSDictionary * dict = @{@"deviceid":[userD objectForKey:@"deviceId"],@"func":@"00",@"clientid":clientid};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}




//初始化socket
- (void)initNetworkCommunication {
    
    uint portNo = 40738;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"16u7471l09.imwork.net", portNo, &readStream, &writeStream);
    inputStream =  (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    uint8_t buffer[1024];
    NSInteger len;
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened now");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"has bytes");
            
            if (theStream == inputStream) {
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        if (nil != output) {
                            GeTuiModel * getModel = [GeTuiModel yy_modelWithJSON:output];
                            NSString * stateString = [NSString stringWithFormat:@"%@",getModel.state];
                            int fun = [getModel.servercode intValue];
                            NSLog(@"GeTuiModelGeTuiModelGeTuiModel:%@", stateString);
                            if ([stateString intValue] == 200 && fun == 00) {//Connected
                                [self popFailureShow:BGGetStringWithKeyFromTable(@"Connected", @"BGLanguageSetting")];
                                [[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"contect"];
                                [self.delegate scanActionDelegate];
                                [self.navigationController popViewControllerAnimated:YES];

                            }
                            if ([stateString intValue] == 404) {//项圈未连接
                                [self popFailureShow:BGGetStringWithKeyFromTable(@"Not connected", @"BGLanguageSetting")];
                                [[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:@"contect"];

                            }
                            //直接在这边做出判断
                            if ([stateString intValue]==402) {//项圈未连接
                                [[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:@"contect"];

                            }
                            if ([stateString intValue]==400) {   //直接在这边做出判断
                                
                            }
                            if ([stateString intValue] == 405) {//项圈未连接
                                [[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:@"contect"];

                            }if ([stateString intValue] == 411) {//注册超时，请重启项圈
                                [[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:@"contect"];

                                
                            }if ([stateString intValue] == 413) {//该设备已经被注册，请先解绑"
                                [[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:@"contect"];

                            }
                            
                            [theStream close];
                            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                            [theStream setDelegate:nil];
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            } else {
                NSLog(@"it is NOT theStream == inputStream");
                [theStream close];
                [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [theStream setDelegate:nil];
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            
            break;
        case NSStreamEventEndEncountered:
            
            break;
        default:
            NSLog(@"Unknown event %lu", (unsigned long)streamEvent);
    }
}




- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)linkAct:(id)sender {
    [self linkAction];

    

}
@end
