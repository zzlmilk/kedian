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
#import "BGLanageTool.h"
#import "GeTuiModel.h"
#import "JSONKit.h"
#import "NSObject+YYModel.h"


#define DESDEVICEID @"deviceId"

@interface BGDeviceVc ()<NSStreamDelegate,UINavigationControllerDelegate,BGDeviceSetSecCellDelegate, BGDeviceFirstCellDelegate, DeviceVcDelegate>

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
    deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:DESDEVICEID];
    self.title =  BGGetStringWithKeyFromTable(@"Device" , @"BGLanguageSetting");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginState:) name:@"loginstate" object:nil];
    electricity =   BGGetStringWithKeyFromTable(@"Getting" , @"BGLanguageSetting");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(data:) name:@"postelector" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"BGDeviceFirstCell" bundle:nil] forCellReuseIdentifier:@"BGfirstCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"BGDeviceSetSecCell" bundle:nil] forCellReuseIdentifier:@"BGSetSecCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"BGDeviceSetThreCell" bundle:nil] forCellReuseIdentifier:@"BGSetThreCell"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpen"];


}

-(void)loginState:(NSNotification *)center//Please turn on your device and reconnect it on the device page
{
    [self.tableView reloadData];
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
    }else{
        return 1;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
                            NSLog(@"stateStringstateStringstateString:%@", stateString);
                            int fun = [getModel.servercode intValue];
                            NSString *msgStr = [NSString stringWithFormat:@"%@",getModel.msg];
                            if ([stateString intValue] == 200 && fun == 00) {
                                NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"TRUE" forKey:@"contect"];
                                [self.tableView reloadData];
                                
                            }
                            if ([stateString intValue] == 404) {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""message:BGGetStringWithKeyFromTable(@"Not connected" , @"BGLanguageSetting")preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *UIAlertActionStyleDefaultAction = [UIAlertAction actionWithTitle:@"OK"style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    
                                }];
                                [alertController addAction:UIAlertActionStyleDefaultAction];
                                [self presentViewController:alertController animated:YES  completion:nil];
                                
                                
                            }
                            //直接在这边做出判断
                            if ([stateString intValue]==402) {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""message:BGGetStringWithKeyFromTable(@"Not connected" , @"BGLanguageSetting")preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *UIAlertActionStyleDefaultAction = [UIAlertAction actionWithTitle:@"OK"style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    
                                }];
                                [alertController addAction:UIAlertActionStyleDefaultAction];
                                [self presentViewController:alertController animated:YES  completion:nil];
                            }
                            //直接在这边做出判断
                            if ([stateString intValue]==400) {
                                NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"FALSE" forKey:@"contect"];
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:msgStr message:nil delegate:self cancelButtonTitle:BGGetStringWithKeyFromTable(@"OK" , @"BGLanguageSetting") otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            if ([stateString intValue] == 405) {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""message:BGGetStringWithKeyFromTable(@"Not connected" , @"BGLanguageSetting")preferredStyle:UIAlertControllerStyleAlert];
                                NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"FALSE" forKey:@"contect"];

                                UIAlertAction *UIAlertActionStyleDefaultAction = [UIAlertAction actionWithTitle:@"OK"style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    
                                }];
                                [alertController addAction:UIAlertActionStyleDefaultAction];
                                [self presentViewController:alertController animated:YES  completion:nil];
                                
                                
                            }if ([stateString intValue] == 411) {
                                
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""message:BGGetStringWithKeyFromTable(@"When the registration times out, restart the device" , @"BGLanguageSetting")preferredStyle:UIAlertControllerStyleAlert];
                                NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
                                [userD setObject:@"FALSE" forKey:@"contect"];

                                UIAlertAction *UIAlertActionStyleDefaultAction = [UIAlertAction actionWithTitle:@"OK"style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    
                                }];
                                [alertController addAction:UIAlertActionStyleDefaultAction];
                                [self presentViewController:alertController animated:YES  completion:nil];
                                
                                
                            }if ([stateString intValue] == 413) {
                            }
                            
                            
                            [theStream close];
                            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                            [theStream setDelegate:nil];
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
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


-(void)scanActionDelegate{
    [self.tableView reloadData];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 75;
        }else{
            return 44;
        }
    }else {
        return 44;
        
    }
}

-(void)lianjieAct{
    [self linkAction];
}





//返回怎样的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BGDeviceFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceFirstCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceFirstCell" owner:nil options:nil].lastObject;
            }
            
            cell.delegate = self;
                cell.dianliangLabel.text = BGGetStringWithKeyFromTable(@"Electricity" , @"BGLanguageSetting");
                cell.shebeihao.text = BGGetStringWithKeyFromTable(@"Device Info" , @"BGLanguageSetting");
            
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"contect"] isEqualToString:@"TRUE"]){
                cell.stateLabel.text = BGGetStringWithKeyFromTable(@"Connected" , @"BGLanguageSetting");
                cell.electricityLabel.text = electricity;//Connected
                cell.stateLabel.hidden = NO;
                cell.lianjieBtn.hidden = YES;
                cell.electricityLabel.hidden = NO;
                cell.dianliangLabel.hidden = NO;
                NSLog(@"dianliangLabeldianliangLabel:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"contect"] );

            }else{
                [cell.lianjieBtn setTitle:BGGetStringWithKeyFromTable(@"Unconnect" , @"BGLanguageSetting")  forState:UIControlStateNormal];
                cell.stateLabel.hidden = YES;
                cell.lianjieBtn.hidden = NO;
                cell.electricityLabel.hidden = YES;
                cell.dianliangLabel.hidden = YES;
                NSLog(@"dianliangLabeldianliangLabel:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"contect"] );
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
            cell.titleLabel.text = BGGetStringWithKeyFromTable(@"Connect to other devices" , @"BGLanguageSetting");

            return cell;
        }else{
            
            BGDeviceSetSecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGSetSecCell"];
            cell.delegate = self;
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceSetSecCell" owner:nil options:nil].lastObject;
            }
            cell.titleLabel.text = BGGetStringWithKeyFromTable(@"Lighting control" , @"BGLanguageSetting");
            if (IsOpen) {
                [cell.lighterLabel setOn:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpen"];

            }else{
                [cell.lighterLabel setOn:NO];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpen"];

            }

            return cell;
        }
        
    }else {
        BGDeviceSetThreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGSetThreCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceSetThreCell" owner:nil options:nil].lastObject;
        }
        cell.moreImg.hidden = NO;
        cell.lanuageLabel.hidden = NO;
        cell.titleLabel.text = BGGetStringWithKeyFromTable(@"LanageSetting" , @"BGLanguageSetting");
        return cell;

    }

    
//    else{
//        BGDeviceSetThreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BGSetThreCell"];
//        if (!cell) {
//            cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceSetThreCell" owner:nil options:nil].lastObject;
//        }
//        
//        if (indexPath.row == 0) {
//            cell.img.image = [UIImage imageNamed:@"feedBack"];
//            cell.titleLabel.text = BGGetStringWithKeyFromTable(@"Feedback" , @"BGLanguageSetting");
//
//        }else if (indexPath.row == 1){
//            cell.img.image = [UIImage imageNamed:@"center_version"];
//            cell.titleLabel.text = BGGetStringWithKeyFromTable(@"Help center" , @"BGLanguageSetting");
//
//        }else{
//            cell.img.image = [UIImage imageNamed:@"aboutus"];
//            cell.titleLabel.text = BGGetStringWithKeyFromTable(@"About us" , @"BGLanguageSetting");
//
//        }
//        
//        cell.moreImg.hidden = NO;
//        cell.lanuageLabel.hidden = YES;
//
//        return cell;
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BGDeviceInfoVc *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"BGDeviceInfoVc"];
            [self.navigationController pushViewController:deviceVc animated:YES];

            
        }else if (indexPath.row == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DeviceVc *deviceVc = [storyboard instantiateViewControllerWithIdentifier:@"DeviceVc"];
            deviceVc.delegate = self;
            [self.navigationController pushViewController:deviceVc animated:YES];
            
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
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSLog(@"deviceIddeviceId3:%@", deviceId);
    NSString *clientid = [[NSUserDefaults standardUserDefaults]objectForKey:@"clientId"];
    NSLog(@"[userD objectForKey:DESDEVICEID]:%@", [userD objectForKey:DESDEVICEID]);
    NSDictionary * dict = @{@"deviceid":[userD objectForKey:DESDEVICEID],@"func":@"00",@"clientid":clientid};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

-(void)lighterOpen:(BOOL)isOpen{
    if (isOpen) {
        [self lighterSeting:@"7"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpen"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWirte"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBlue"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGreen"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCyan"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isYellow"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispurple"];

    }else{
    
        [self lighterSeting:@"0"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isOpen"];

    }

}

//向服务器请求位置
-(void)lighterSeting:(NSString *)lighter
{
    [self initNetworkCommunication];
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"deviceid":[userD objectForKey:DESDEVICEID],@"func":@"06",@"content":lighter, @"language":@"en"};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:(Byte *)[data bytes] maxLength:[data length]];
}



- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"postelector"];
}
@end
