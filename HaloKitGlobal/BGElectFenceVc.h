//
//  BGElectFenceVc.h
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTSlider.h"

@interface BGElectFenceVc : UIViewController
@property(nonatomic,strong) ZTSlider *pointSlider;//积分的段落
@property(nonatomic,strong) UILabel *tilbl;//标题
@property(strong, nonatomic) UIView *operationView;

@end
