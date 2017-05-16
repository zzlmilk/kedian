//
//  AboutUsViewController.h
//  可点
//
//  Created by jimZT on 16/10/19.
//  Copyright © 2016年 赵东明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController
- (IBAction)PlayPhone:(id)sender;
- (IBAction)ideaUpload:(id)sender;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *verisionBtn;
@property (weak, nonatomic) IBOutlet UILabel *lianxinwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentVersion;

@end
