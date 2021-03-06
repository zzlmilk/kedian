//
//  DeviceVc.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceVcDelegate <NSObject>

-(void)scanActionDelegate;

@end


@interface DeviceVc : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
- (IBAction)scanAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;
- (IBAction)linkAct:(id)sender;
@property (assign ,nonatomic) id<DeviceVcDelegate> delegate;


@end
