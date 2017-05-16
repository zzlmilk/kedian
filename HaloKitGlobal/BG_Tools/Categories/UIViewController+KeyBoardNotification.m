//
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//   佛祖保佑       永无BUG
//   Created by haytor.
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//

#import "UIViewController+KeyBoardNotification.h"

#define BG_VIEW_TAG 993571
#define BUTTON_KEY_TAG 993572

#ifndef IOS7_OR_LATER_T
#define IOS7_OR_LATER_T		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#endif

@implementation UIViewController (KeyBoardNotification)

@dynamic isKeyBackground;

- (void)addObserverForKeyBoard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowHandle:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidShowHandle:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideHandle:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidHideHandle:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeFrameHandle:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unaddObserverForKeyBoard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)KeyBoardWillShowHandle:(NSNotification *)notify{}
- (void)KeyBoardDidShowHandle:(NSNotification *)notify{}
- (void)KeyBoardWillHideHandle:(NSNotification *)notify{}
- (void)KeyBoardDidHideHandle:(NSNotification *)notify{}
- (void)KeyBoardWillChangeHandle:(NSNotification *)notify{}

#pragma mark -

- (void)willShowHandle:(NSNotification *)notify
{
    [self KeyBoardWillShowHandle:notify];
}

- (void)DidShowHandle:(NSNotification *)notify
{
    [self KeyBoardDidShowHandle:notify];
}

- (void)willHideHandle:(NSNotification *)notify
{
    [self KeyBoardWillHideHandle:notify];
}

- (void)DidHideHandle:(NSNotification *)notify
{
    [self KeyBoardDidHideHandle:notify];
}

- (void)willChangeFrameHandle:(NSNotification *)notify
{
    [self KeyBoardWillChangeHandle:notify];
}

#pragma mark - 
- (void)unaddActionKey
{
    UIButton *btnkeyboard = (UIButton *)[self.view viewWithTag:BUTTON_KEY_TAG];
    if (btnkeyboard.superview)
    {
        [btnkeyboard removeFromSuperview];
    }
}
- (void)addActionKey
{
    UIButton *btnkeyboard = (UIButton *)[self.view viewWithTag:BUTTON_KEY_TAG];
    if ( btnkeyboard)
    {
        btnkeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
        btnkeyboard.tag = BUTTON_KEY_TAG;
    }
    
    [btnkeyboard setTitle:@"完成" forState:UIControlStateNormal];
    [btnkeyboard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnkeyboard.titleLabel.font = [UIFont systemFontOfSize:15];
    btnkeyboard.backgroundColor = [UIColor whiteColor];
 
    btnkeyboard.frame = CGRectMake(0,self.view.frame.size.height-(IOS7_OR_LATER_T?9:-11), 104, 52);
    btnkeyboard.adjustsImageWhenHighlighted = NO;
    [btnkeyboard  addTarget:self action:@selector(keyBoardHide) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    if (btnkeyboard.superview == nil)
    {
        [tempWindow addSubview:btnkeyboard];    // 注意这里直接加到window上
    }
}

- (void)keyBoardHide
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

@end
