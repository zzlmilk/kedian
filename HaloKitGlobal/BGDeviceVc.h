//
//  BGDeviceVc.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/3.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGLanageTool.h"

@interface BGDeviceVc : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *linkStateLabel;
- (IBAction)feedBackAction:(id)sender;
- (IBAction)deciceSettingAction:(id)sender;

@end
