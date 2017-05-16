//
//  BGDeviceSetSecCell.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/14.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BGDeviceSetSecCellDelegate <NSObject>

-(void)lighterOpen:(BOOL)isOpen;

@end
@interface BGDeviceSetSecCell : UITableViewCell
@property (assign ,nonatomic) id<BGDeviceSetSecCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *lighterLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)lighterOpenAction:(UISwitch *)sender;

@end
