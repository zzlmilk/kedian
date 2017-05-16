//
//  BGDeviceVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/3.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGDeviceVc.h"
#import "BGDeviceFirstCell.h"
#import "BGLanageTool.h"
#import "DeviceVc.h"
#import "HXDYiJianFanHuiViewController.h"
#import "BGDeviceFirstCell.h"
#import "BGDeviceSetSecCell.h"
#import "BGDeviceSetThreCell.h"
#import "BGLighterVc.h"
#import "AboutUsViewController.h"
#import "BGIntroduceVc.h"
#import "HXDYiJianFanHuiViewController.h"
#import "LinkDeviceVc.h"
#import "BGDeviceInfoVc.h"
#import "DeviceVc.h"
#import "BoGeLangageSettingVc.h"
#import "Scan_VC.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import "JSONKit.h"

#define DESDEVICEID @"deviceId"

@interface BGDeviceVc ()<Scan_VCDelegate,NSStreamDelegate,UINavigationControllerDelegate,BGDeviceSetSecCellDelegate>

@end

@implementation BGDeviceVc
{
    UILabel *linkState;
    NSString *electricity;
    UILabel *deviceNum;
    Scan_VC * vc;
    NSInputStream  * inputStream;
    NSOutputStream * outputStream;
    NSString *deviceId;
    BOOL IsOpen;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";

    electricity = @"正在获取电量";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(data:) name:@"postelector" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"BGDeviceFirstCell" bundle:nil] forCellReuseIdentifier:@"BGfirstCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"BGDeviceSetSecCell" bundle:nil] forCellReuseIdentifier:@"BGSetSecCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"BGDeviceSetThreCell" bundle:nil] forCellReuseIdentifier:@"BGSetThreCell"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpen"];


}

-(void)data:(NSNotification *)center
{
    NSString * postStr = [NSString stringWithFormat:@"%@",center.object];
    NSArray * arr = [postStr componentsSeparatedByString:@","];
    NSString * chargeStr = [NSString stringWithFormat:@"%@",arr[1]];
    NSString * chargeValue = [NSString stringWithFormat:@"%@", arr[0]];
    NSLog(@"电量：%d", [chargeValue intValue]);
    if ([chargeStr intValue] == 9) {
        
        NSString *str1 = [NSString stringWithFormat:@"%@", chargeValue];
        electricity  = [str1 stringByAppendingString:@"%"];
        [self.tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isOpen"]) {
        IsOpen = YES;
    }else{
        IsOpen = NO;
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;

    }else{
        return 3;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 75;
        }else{
            return 44;
        }
    }else if (indexPath.section == 1){
        return 44;
        
    }else{
        return 44;
        
    }
}

-(void)returnValue:(NSString *)value
{
    //需要把返给我的字符串截取一部分
    [[self class] encryptWithContent:value type:kCCDecrypt key:@"hAlokiTs"];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *desStr = [NSString stringWithFormat:@"%@",[userD objectForKey:DESDEVICEID]];
    if (desStr.length > 6) {
        deviceId = desStr;
        [self linkAction];
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



//返回怎样的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BGDeviceFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceFirstCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceFirstCell" owner:nil options:nil].lastObject;
            }
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"contect"] isEqualToString:@"TRUE"]){
                cell.stateLabel.text = @"已链接";
                cell.electricityLabel.text = electricity;

            }else{
                cell.stateLabel.text = @"未链接";
                cell.electricityLabel = 0;
            }
            
            cell.deviceNumLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
            return cell;

        }else if (indexPath.row == 1){
            
            BGDeviceSetThreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGSetThreCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceSetThreCell" owner:nil options:nil].lastObject;
            }
            cell.moreImg.hidden = NO;
            cell.lanuageLabel.hidden = YES;
            cell.img.image = [UIImage imageNamed:@"linkDevice"];
            cell.titleLabel.text = @"链接其他设备";

            return cell;
        }else{
            
            BGDeviceSetSecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGSetSecCell"];
            cell.delegate = self;
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceSetSecCell" owner:nil options:nil].lastObject;
            }
            cell.titleLabel.text = @"灯光控制";
            if (IsOpen) {
                [cell.lighterLabel setOn:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpen"];

            }else{
                [cell.lighterLabel setOn:NO];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpen"];

            }

            return cell;
        }
        
    }else if (indexPath.section == 1){
        BGDeviceSetThreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGSetThreCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceSetThreCell" owner:nil options:nil].lastObject;
        }
        cell.moreImg.hidden = YES;
        cell.lanuageLabel.hidden = NO;
        cell.titleLabel.text = @"语言选择";

        return cell;

    }else{
        BGDeviceSetThreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGSetThreCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceSetThreCell" owner:nil options:nil].lastObject;
        }
        
        if (indexPath.row == 0) {
            cell.img.image = [UIImage imageNamed:@"feedBack"];
            cell.titleLabel.text = @"意见反馈";

        }else if (indexPath.row == 1){
            cell.img.image = [UIImage imageNamed:@"center_version"];
            cell.titleLabel.text = @"帮助中心";

        }else{
            cell.img.image = [UIImage imageNamed:@"aboutus"];
            cell.titleLabel.text = @"关于我们";

        }
        
        cell.moreImg.hidden = NO;
        cell.lanuageLabel.hidden = YES;

        return cell;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BGDeviceInfoVc *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"BGDeviceInfoVc"];
            [self.navigationController pushViewController:deviceVc animated:YES];

            
        }else if (indexPath.row == 1){
            vc = [[Scan_VC alloc]init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];

            
        }else{//BGLighterVc
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BGLighterVc *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"BGLighterVc"];
            [self.navigationController pushViewController:deviceVc animated:YES];

            
        }
    }else if (indexPath.section == 1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BoGeLangageSettingVc *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"BoGeLangageSettingVc"];
        [self.navigationController pushViewController:deviceVc animated:YES];

        
    }else{
        
        if (indexPath.row == 0) {
            HXDYiJianFanHuiViewController *ideaVC = [[HXDYiJianFanHuiViewController alloc] init];
            [self.navigationController pushViewController:ideaVC animated:NO];

            
        }else if (indexPath.row == 1){
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BGIntroduceVc *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"BGIntroduceVc"];
            [self.navigationController pushViewController:deviceVc animated:YES];

        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AboutUsViewController *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
            [self.navigationController pushViewController:deviceVc animated:YES];

        }
        
    }
}

- (void)linkAction {
    [self initNetworkCommunication];
    NSLog(@"deviceIddeviceId:%@", deviceId);
    NSString *clientid = [[NSUserDefaults standardUserDefaults]objectForKey:@"clientId"];
    NSDictionary * dict = @{@"deviceid":@"861933030001580",@"func":@"00",@"clientid":clientid};
    NSString * response = [dict JSONString];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:@"861933030001580" forKey:DESDEVICEID];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}

-(void)lighterOpen:(BOOL)isOpen{
    if (isOpen) {
        [self lighterSeting:@"7"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpen"];

    }else{
    
        [self lighterSeting:@"0"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpen"];

    }

}

//向服务器请求位置
-(void)lighterSeting:(NSString *)lighter
{
    [self initNetworkCommunication];
    NSDictionary *dict = @{@"deviceid":@"861933030001580",@"func":@"06",@"content":lighter, @"language":@"en"};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:(Byte *)[data bytes] maxLength:[data length]];
    
}



- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"postelector"];
}
@end
