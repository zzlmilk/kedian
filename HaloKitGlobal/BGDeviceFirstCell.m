//
//  BGDeviceFirstCell.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/3.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGDeviceFirstCell.h"

@implementation BGDeviceFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)lianjieAction:(id)sender {
    [self.delegate lianjieAct];
}
@end
