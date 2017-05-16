//
//  BGDeviceInfoVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/9.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGDeviceInfoVc.h"
#import "DeviceInfoSecCell.h"
#import "BGDeviceInfoFirstCell.h"
#import "HGDQQRCodeView.h"
@interface BGDeviceInfoVc ()

@end

@implementation BGDeviceInfoVc
{
    NSString *deviceId;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 44;
    }else{
        return 460;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BGDeviceInfoFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fistCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BGDeviceInfoFirstCell" owner:nil options:nil].lastObject;
        }
        NSLog(@"dddddddd:%@", deviceId);
        cell.deviceLabel.text = deviceId;
        return cell;

    }else{
        DeviceInfoSecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"DeviceInfoSecCell" owner:nil options:nil].lastObject;
        }

        if (deviceId) {
            [HGDQQRCodeView creatQRCodeWithURLString:deviceId superView:cell.QRView logoImage:[UIImage imageNamed:@"Icon-60"] logoImageSize:CGSizeMake(40, 40) logoImageWithCornerRadius:0];
        }
        return cell;
    }
}


@end
