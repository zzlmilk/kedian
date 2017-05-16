//
//  BGDeviceSetSecCell.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/14.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGDeviceSetSecCell.h"

@implementation BGDeviceSetSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)lighterOpenAction:(UISwitch *)sender {
    
    if (sender.on == YES){
    
        [self.delegate lighterOpen:YES];
    }else{
        [self.delegate lighterOpen:NO];

    }
    
    
}
@end
