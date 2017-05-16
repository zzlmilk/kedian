//
//  BGDeviceFirstCell.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/3.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BGDeviceFirstCellDelegate <NSObject>

-(void)lianjieAct;

@end
@interface BGDeviceFirstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shebeihao;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *electricityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianliangLabel;
- (IBAction)lianjieAction:(id)sender;
@property (assign ,nonatomic) id<BGDeviceFirstCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *lianjieBtn;


@end
