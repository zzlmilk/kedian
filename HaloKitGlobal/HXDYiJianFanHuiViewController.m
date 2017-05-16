//
//  HXDYiJianFanHuiViewController.m
//  一生记忆
//
//  Created by 何小弟 on 16/5/19.
//  Copyright © 2016年 何小弟. All rights reserved.
//

#import "HXDYiJianFanHuiViewController.h"
#import "UIView+UIViewEx.h"
#import "UIViewController+PopMessage.h"
#import "HttpRequest.h"
#import "HttpRequest_url.h"

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
/** 宽度比 */
#define kScaleW [UIScreen mainScreen].bounds.size.width/375
/** 高度比 */
#define kScaleH [UIScreen mainScreen].bounds.size.height/667
//RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define iPhone6splus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//设备分辨率 CGSizeMake(640, 1136)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//750x1334
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//640x960
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#define iPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//iPhone6s plus  (1242x2208->)
//1080x1920
#define iPhone6splus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


@interface HXDYiJianFanHuiViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UITextView * feedBackTextView;// 用来填写反馈内容
    UITextField * phoneNum;//用来填写联系方式
    UILabel *tipLabel; //提示语
}

@end

@implementation HXDYiJianFanHuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self createNavigationView];
    
    [self mainview];
}
- (void)backClick
{
    //NSLog(@"backClick返回调用");
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//创建导航栏的视图
-(void)createNavigationView
{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44 *kScaleH)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10*kScaleW, 10*kScaleH, 15*kScaleW, 24*kScaleH);
    [topView addSubview:backButton];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"profile-back"] forState:UIControlStateNormal];
    
}

-(void)mainview
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * view1=[[UIView alloc]init];
    view1.userInteractionEnabled=YES;
    
    view1.backgroundColor=HWColor(0, 231, 157);
    view1.layer.borderWidth=0.5;//边框设置
    view1.layer.cornerRadius = 5;//倒角
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.borderColor=[HWColor(201, 202, 203) CGColor];
    [self.view addSubview:view1];
    
    
    // 用来填写反馈内容文本框
    feedBackTextView = [[UITextView alloc]init];
    [feedBackTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];//取消首字母大写功能
    feedBackTextView.backgroundColor=[UIColor whiteColor];
    feedBackTextView.delegate = self;
    feedBackTextView.editable = YES;
    // [feedBackTextView setEditable:NO];
    [view1 addSubview:feedBackTextView];//用来填写反馈内容
    
    //提示语
    tipLabel = [[UILabel alloc]init];
    
    tipLabel.text = @"感谢您在此提供问题和意见";
    tipLabel.numberOfLines = 0; // 最关键的一句
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.textColor = [UIColor lightGrayColor];
    
    [view1 addSubview:tipLabel]; //提示语
    
    
    
    UIView * view2=[[UIView alloc]init];
    view2.userInteractionEnabled=YES;
    
    view2.backgroundColor=HWColor(0, 231, 157);
    
    view2.layer.borderWidth=0.5;//边框设置
    view2.layer.cornerRadius = 5;//倒角
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.borderColor=[HWColor(201, 202, 203) CGColor];
    [self.view addSubview:view2];
    
    
    //提示语
    UILabel * latipLabel = [[UILabel alloc]init];
    latipLabel.text = @"联系方式";
    
    latipLabel.backgroundColor=[UIColor whiteColor];
    //latipLabel.numberOfLines = 0; // 最关键的一句
    latipLabel.font = [UIFont systemFontOfSize:14.0];
    latipLabel.textColor = [UIColor blackColor];
    
    [view2 addSubview:latipLabel]; //提示语
    
    
    UILabel * latipLabellin = [[UILabel alloc]init];
    
    latipLabellin.backgroundColor=[UIColor lightGrayColor];
    //latipLabel.numberOfLines = 0; // 最关键的一句
    latipLabellin.font = [UIFont systemFontOfSize:14.0];
    //latipLabellin.textColor = [UIColor blackColor];
    
    [view2 addSubview:latipLabellin]; //提示语
    
    
    
    //用来填写联系方式文本框
    phoneNum = [[UITextField alloc]init];
    
    phoneNum.backgroundColor=[UIColor whiteColor];
    phoneNum.font = [UIFont systemFontOfSize:14.0];
    phoneNum.textColor = [UIColor blackColor];
    [phoneNum setPlaceholder:@"请输入您的手机号"];
    //phoneNum.secureTextEntry = YES;
    phoneNum.delegate=self;
    phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [phoneNum setAutocorrectionType:UITextAutocorrectionTypeNo];//关闭系统自动联想
    [phoneNum setAutocapitalizationType:UITextAutocapitalizationTypeNone];//取消首字母大写功能
    [view2 addSubview:phoneNum];
    
    
    
    
    UIView * view3=[[UIView alloc]init];
    view3.userInteractionEnabled=YES;
    
    //view3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view3];
    
    
        
    UIButton * registerBtn = [[UIButton alloc] init];
    
    if (iPhone6plus || iPhone6splus) {
        registerBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_down@3x"]];
    }else{
        registerBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_down"]];
    }

    
    [registerBtn setTitle:@"提  交" forState:UIControlStateNormal];
    registerBtn.backgroundColor = [UIColor colorWithRed:0.76 green:0.86 blue:0.11 alpha:0.5];
    [registerBtn addTarget:self action:@selector(tijiaoTap) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view3 addSubview:registerBtn];//登陆按钮
    
    
    if (iPhone5||iPhone5s) {
        view1.frame=CGRectMake(5, 80, SCREEN_WIDTH-10, 160);
        feedBackTextView.frame=CGRectMake(5, 5, view1.frame.size.width-10, 150);
        tipLabel.frame=CGRectMake(10, 0, SCREEN_WIDTH - 40, 45);
        view2.frame=CGRectMake(5, view1.bottom+15, SCREEN_WIDTH-10, 50);
        latipLabel.frame=CGRectMake(5, 5, 60, 40);
        latipLabellin.frame=CGRectMake(CGRectGetMaxX(latipLabel.frame), 5, 1, 40);
        phoneNum.frame=CGRectMake(CGRectGetMaxX(latipLabel.frame)+5, 5, view2.frame.size.width-latipLabel.frame.size.width-latipLabellin.frame.size.width-15, 40);
        view3.frame=CGRectMake(10, view2.bottom+15, SCREEN_WIDTH-20, 44);
        registerBtn.frame = CGRectMake(0, 0, view3.frame.size.width, 54);
        
    }
    else
    {
        view1.frame=CGRectMake(5, 80, SCREEN_WIDTH-10, 200);
        feedBackTextView.frame=CGRectMake(5, 5, view1.frame.size.width-10, 190);
        tipLabel.frame=CGRectMake(10, 0, SCREEN_WIDTH - 40, 45);
        view2.frame=CGRectMake(5, view1.bottom+15, SCREEN_WIDTH-10, 50);
        latipLabel.frame=CGRectMake(5, 5, 60, 40);
        latipLabellin.frame=CGRectMake(CGRectGetMaxX(latipLabel.frame), 5, 1, 40);
        phoneNum.frame=CGRectMake(CGRectGetMaxX(latipLabel.frame)+5, 5, view2.frame.size.width-latipLabel.frame.size.width-latipLabellin.frame.size.width-15, 40);
        view3.frame=CGRectMake(10, view2.bottom+15, SCREEN_WIDTH-20, 44);
        registerBtn.frame = CGRectMake(0, 0, view3.frame.size.width, 54);
        
    }
}
-(void)tijiaoTap
{
    [feedBackTextView resignFirstResponder];//任意触摸关闭键盘
    [phoneNum resignFirstResponder];//任意触摸关闭键盘
    if ([self judgeTextField])
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //往字典里面添加需要提交的参数
        [parameters setObject:feedBackTextView.text forKey:@"message"];//内容
        [parameters setObject:phoneNum.text forKey:@"phone"];//联系方式
        
        [[HttpRequest sharedInstance] POST:[HttpRequest_url advice_postUrl] dict:parameters succeed:^(id data) {
            [self popFailureShow:@"意见反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSError *error) {
            [self popFailureShow:@"请检查网络是否连接"];

        }];
    }
}

- (BOOL)judgeTextField
{
    //如果帐号为空
    if ([feedBackTextView.text isEqualToString:@""] || [phoneNum.text isEqualToString:@""])
    {
        [self popFailureShow:@"反馈内容或手机号码为空"];
        return NO;
    }
    //如果输入的手机号格式不对
    else if ([self isValidateMobile:phoneNum.text] == NO)
    {
        [self popFailureShow:@"您输入的手机号码有误，请检查重新输入"];
        return NO;
    }
        //提示 标签不能输入特殊字符
        NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
        NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
        if (![emailTest evaluateWithObject:feedBackTextView.text])
        {
            [self popFailureShow:@"您输入的反馈内容包含非法字符"];
            return NO;
    }
    return YES;
}

//点击空白隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [feedBackTextView resignFirstResponder];
    [phoneNum resignFirstResponder];
    if ([feedBackTextView.text isEqual:@""])
    {
        tipLabel.hidden = NO;
    }
}
#pragma mark uitextview 代理
- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    tipLabel.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    //关闭键盘
    if ([textView.text isEqual:@""])
    {
        tipLabel.hidden = NO;
    }
}


- (void)textViewDidChangeSelection:(UITextView *)textView;
{
    
}
//点击Return关闭键盘
#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击Return关闭键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([textView.text isEqual:@""])
        {
            tipLabel.hidden = NO;
        }
        return NO;
    }
    return YES;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
