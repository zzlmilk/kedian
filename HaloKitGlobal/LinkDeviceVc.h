//
//  LinkDeviceVc.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/4/28.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkDeviceVc : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
- (IBAction)scanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;
@property (weak, nonatomic) IBOutlet UIButton *lanageSetBtn;
- (IBAction)skipAcion:(id)sender;
- (IBAction)lanageSetAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLableFirst;
@property (weak, nonatomic) IBOutlet UILabel *titleLbaleSec;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;


@end
